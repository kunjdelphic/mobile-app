import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/models/signup/signup_referral.dart';
import 'package:parrotpos/screens/user_profile/referrals/my_qrcode_screen.dart';
import 'package:parrotpos/screens/user_profile/referrals/my_referrals_screen.dart';
import 'package:parrotpos/screens/user_profile/terms_and_conditions_screen.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../qr_code_scanner_screen.dart';
import '../reffreal_terms_and_condition.dart';

class ReferralsScreen extends StatefulWidget {
  const ReferralsScreen({Key? key}) : super(key: key);

  @override
  _ReferralsScreenState createState() => _ReferralsScreenState();
}

class _ReferralsScreenState extends State<ReferralsScreen> {
  ReferralController referralController = Get.find();
  UserProfileController userProfileController = Get.find();
  TextEditingController referralCodeController = TextEditingController();
  SignupReferral? signupReferral;
  SignupReferral? referrerDetails;
  // late String referralCode;
  final LoginController loginController = Get.put(LoginController());
  bool isReferrerAllowed = false;
  bool isConfirmed = false;
  bool isReferrerFetched = false;

  String referralProfileUrl = '';
  late Duration timeRemaining;
  bool hasImg = false;
  ButtonState confirmBtnState = ButtonState.idle;

  @override
  void initState() {
    referralController.getMyReferral({});

    var difference = DateTime.now().toLocal().difference(DateTime.parse(userProfileController.userProfile.value.data!.joiningTimestamp!).toLocal());

    print('JOINING :: ');
    print(DateTime.parse(userProfileController.userProfile.value.data!.joiningTimestamp!).toLocal());
    print('NOW :: ');
    print(DateTime.now().toLocal());

    print(difference.inDays);
    print(difference.inHours);

    if (difference.inHours < 1) {
      var futureTime = DateTime.parse(userProfileController.userProfile.value.data!.joiningTimestamp!).toLocal().add(const Duration(hours: 1));
      print('FUTURE :: ');
      print(futureTime);

      timeRemaining = futureTime.difference(DateTime.now().toLocal());
      isReferrerAllowed = true;
    }
    // timeRemaining = difference;
    // isReferrerAllowed = true;

    super.initState();
  }

  shareReferralCode() async {
    await FlutterShare.share(
      title: 'ParrotPos App',
      text: 'Share ParrotPos App & Earn Cashback up to RM10k/month from each referrals transaction. Download, Install & Pay to Donate Automatically!',
      linkUrl: '${referralController.referralLink}',
      chooserTitle: 'Share to apps',
    );
  }

  getReferrerDetails() async {
    if (referralCodeController.text.trim().isEmpty) {
      errorSnackbar(title: "Failed", subtitle: 'Enter the referral code!');
      return;
    }

    processingDialog(title: 'Processing..\nPlease wait.', context: context);

    referrerDetails = await referralController.getReferralDetails({
      "referral_code": referralCodeController.text.trim(),
    });

    Get.back();

    if (referrerDetails!.email.isNotEmpty) {
      setState(() {
        isReferrerFetched = true;
      });
    } else {
      //failed
      errorSnackbar1(title: referrerDetails!.message);
    }
  }

  submitReferral() async {
    processingDialog(title: 'Processing..\nPlease wait.', context: context);

    signupReferral = await loginController.signUpReferral({
      "referral_code": referralCodeController.text.trim(),
    });

    Get.back();

    if (signupReferral!.email.isNotEmpty) {
      setState(() {
        isConfirmed = true;
      });

      userProfileController.getUserDetails();
    } else {}
  }

  getImage() async {
    var res = await RemoteService.client.get(
      Uri.parse(signupReferral!.profileImage),
      headers: {
        "Content-type": "application/json; charset=utf-8",
        "access_id": RemoteService.accessId,
      },
    );
    var response = jsonDecode(res.body);

    if (response['status'] == 200) {
      print(response);
      referralProfileUrl = response['url'];
    } else {
      errorSnackbar(title: "Failed", subtitle: 'Unable to fetch the profile image!');
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
          "Referrals",
          style: kBlackLargeStyle,
        ),
      ),
      body: GetX<ReferralController>(
        init: referralController,
        builder: (controller) {
          // if (controller.isFetching.value) {
          //   return const Center(
          //     child: SizedBox(
          //       height: 25,
          //       child: LoadingIndicator(
          //         indicatorType: Indicator.lineScalePulseOut,
          //         colors: [
          //           kAccentColor,
          //         ],
          //       ),
          //     ),
          //   );
          // }
          // if (controller.myReferral.value.status != 200) {
          //   return Center(
          //     child: SizedBox(
          //       height: 35,
          //       child: Text(
          //         controller.myReferral.value.message.toString(),
          //         style: kBlackSmallMediumStyle,
          //       ),
          //     ),
          //   );
          // }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              !userProfileController.userProfile.value.data!.referredByState!
                  ? isReferrerAllowed
                      ? Column(
                          children: [
                            isReferrerFetched
                                ? isConfirmed
                                    ? Container(
                                        height: 150,
                                        width: Get.width,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: const Color(0xffF6F6F6),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/tick.png',
                                                width: Get.width * 0.15,
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                'Referrer Added',
                                                style: kBlackDarkLargeStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: const Color(0xffF6F6F6),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Referrer:',
                                              style: kBlackMediumStyle,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.15,
                                                  height: Get.width * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    color: kWhite,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        blurRadius: 4,
                                                        spreadRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    margin: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          kGreenBtnColor1,
                                                          kGreenBtnColor2,
                                                        ],
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(100),
                                                        child: CircleAvatar(
                                                            backgroundColor: kWhite,
                                                            radius: Get.width * 0.06,
                                                            child: referrerDetails!.profileImage.contains('no_image')
                                                                ? Padding(
                                                                    padding: const EdgeInsets.all(4.0),
                                                                    child: Image.asset('assets/images/logo/parrot_logo.png'),
                                                                  )
                                                                : null,
                                                            backgroundImage: referrerDetails!.profileImage.contains('no_image')
                                                                ? null
                                                                : NetworkImage(referrerDetails!.profileImage, headers: {
                                                                    "Content-type": "application/json; charset=utf-8",
                                                                    "access_id": RemoteService.accessId,
                                                                  })),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(
                                                  width: 20,
                                                ),

                                                Center(
                                                  child: Text(
                                                    referrerDetails!.name,
                                                    textAlign: TextAlign.center,
                                                    style: kBlackLargeStyle,
                                                  ),
                                                ),
                                                // Center(
                                                //   child: Text(
                                                //     'Joined on: 31.01.2021',
                                                //     textAlign: TextAlign.center,
                                                //     style: kBlackLightMediumStyle,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            // CircleAvatar(
                                            //   backgroundColor: kWhite,
                                            //   radius: Get.width * 0.05,
                                            //   backgroundImage: NetworkImage(
                                            //       referrerDetails.profileImage,
                                            //       headers: {
                                            //         "Content-type":
                                            //             "application/json; charset=utf-8",
                                            //         "access_id":
                                            //             RemoteService.accessId,
                                            //       }),
                                            //   // child: FutureBuilder(
                                            //   //   future: _imageFuture,
                                            //   //   builder: (context, snapshot) {
                                            //   //     String profileImageUrl = '';

                                            //   //     return Image.network(profileImageUrl);
                                            //   //   },
                                            //   // ),
                                            // ),

                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: WhiteButton(
                                                    text: 'Back',
                                                    width: false,
                                                    widthSize: 0,
                                                    onTap: () {
                                                      setState(() {
                                                        isReferrerFetched = false;
                                                        referrerDetails = null;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: GradientButton(
                                                    text: 'Confirm',
                                                    btnColor: true,
                                                    width: true,
                                                    onTap: () {
                                                      submitReferral();
                                                    },
                                                    widthSize: Get.width - 20,
                                                    buttonState: confirmBtnState,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xffF6F6F6),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Who is your referrer?',
                                          style: kBlackLargeStyle,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                var res = await Get.to(() => const QrCodeScannerScreen());
                                                if (res != null) {
                                                  setState(() {
                                                    referralCodeController.text = res.code;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 47,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.08),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.qr_code_scanner_outlined,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.08),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: TextFormField(
                                                  controller: referralCodeController,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  validator: (value) {
                                                    if (value!.trim().isEmpty) {
                                                      return 'Referral Code is required';
                                                    }

                                                    return null;
                                                  },
                                                  enableInteractiveSelection: true,
                                                  style: kBlackMediumStyle,
                                                  textInputAction: TextInputAction.done,
                                                  keyboardType: TextInputType.text,
                                                  textCapitalization: TextCapitalization.characters,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                                    helperStyle: kRedSmallLightMediumStyle,
                                                    errorStyle: kRedSmallLightMediumStyle,
                                                    hintStyle: kBlackSmallLightMediumStyle,
                                                    hintText: 'Referral Code',
                                                    labelStyle: kRedSmallLightMediumStyle,
                                                    fillColor: kWhite,
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(12.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide.none,
                                                      borderRadius: BorderRadius.circular(12.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                getReferrerDetails();
                                              },
                                              child: Container(
                                                width: 47,
                                                height: 47,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.08),
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 20,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Remaining Time to Add Referral Code: ',
                                                  style: kBlackExtraSmallMediumStyle,
                                                ),
                                                SlideCountdown(
                                                  duration: timeRemaining,
                                                  separatorType: SeparatorType.symbol,
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  // textStyle:
                                                  //     kWhiteExtraSmallDarkMediumStyle,
                                                  // decoration: const BoxDecoration(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Divider(thickness: 0.30),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      : const SizedBox()
                  : const SizedBox(),
              Center(
                child: Text(
                  'Refer Your Friends!',
                  style: kBlackLargeStyle,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Earn more money.',
                  style: kBlackSmallMediumStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffE4F0FA),
                      kWhite,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: Get.width * 0.2,
                          height: Get.width * 0.2,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                width: Get.width * 0.17,
                                height: Get.width * 0.2,
                                child: Center(
                                  child: Container(
                                    height: Get.width * 0.17,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CircleAvatar(
                                        backgroundColor: kWhite,
                                        radius: Get.width * 0.1,
                                        child: SvgPicture.asset(
                                          'assets/icons/main_referrals.svg',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                width: Get.width * 0.06,
                                bottom: 0,
                                right: 0,
                                height: Get.width * 0.2,
                                child: const CircleAvatar(
                                  radius: 17,
                                  backgroundColor: kAccentColor,
                                  child: Icon(
                                    Icons.add,
                                    color: kWhite,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        controller.isFetching.value
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Total Referrals: ',
                                    style: kBlackMediumStyle,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: LoadingIndicator(
                                        colors: [kBlack],
                                        indicatorType: Indicator.lineScalePulseOut,
                                      ))
                                ],
                              )
                            : Text(
                                'Total Referrals: ${controller.myReferral.value.data!.referralCount}',
                                style: kBlackMediumStyle,
                              ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: GradientButton(
                        text: 'View My Referrals',
                        width: true,
                        onTap: () {
                          Get.to(() => const MyReferralsScreen());
                        },
                        widthSize: Get.width,
                        buttonState: ButtonState.idle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              GradientButton(
                text: 'Share My Referral Code',
                width: true,
                onTap: () async {
                  shareReferralCode();
                },
                widthSize: Get.width,
                buttonState: ButtonState.idle,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const MyQrCodeScreen());
                },
                child: Center(
                  child: Container(
                    height: 45,
                    width: Get.width * 0.9,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffFFFFFF),
                          Color(0xffD2DFF8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'View My QR Code',
                      style: kBlackMediumStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              WhiteButton(
                text: 'Terms & Conditions',
                width: true,
                onTap: () {
                  Get.to(() => const ReferralTermsAndConditionsScreen(), arguments: 'referral');
                },
                widthSize: Get.width,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Please read our terms of use before using our referral services.',
                textAlign: TextAlign.center,
                style: kBlackSmallLightMediumStyle,
              ),
            ],
          );
        },
      ),
    );
  }
}
