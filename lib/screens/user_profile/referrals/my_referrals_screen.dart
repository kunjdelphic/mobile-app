import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/user_profile/referrals/level_referrals_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class MyReferralsScreen extends StatefulWidget {
  const MyReferralsScreen({Key? key}) : super(key: key);

  @override
  _MyReferralsScreenState createState() => _MyReferralsScreenState();
}

class _MyReferralsScreenState extends State<MyReferralsScreen> {
  ReferralController referralController = Get.find();
  UserProfileController userProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Referrals List",
          style: kBlackLargeStyle,
        ),
      ),
      body: GetX<ReferralController>(
        init: referralController,
        builder: (controller) {
          if (controller.isFetching.value) {
            return const Center(
              child: SizedBox(
                height: 25,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOut,
                  colors: [
                    kAccentColor,
                  ],
                ),
              ),
            );
          }
          if (controller.myReferral.value.status != 200) {
            return Center(
              child: SizedBox(
                height: 35,
                child: Text(
                  controller.myReferral.value.message!,
                  style: kBlackSmallMediumStyle,
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kBlueBtnColor1,
                        kBlueBtnColor2,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Image.asset(
                          'assets/images/wallet/wallet_bg_shapes.png',
                          width: Get.width * 0.3,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Referral Earnings',
                                    style: kWhiteDarkMediumStyle,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/logo/logo_full.svg',
                                    width: Get.width * 0.18,
                                  ),
                                ],
                              ),
                              Text(
                                '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.myReferral.value.data!.referralEarning.toString()).toStringAsFixed(2)}',
                                style: kWhiteDarkSuperLargeStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                  color: kWhite,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.15,
                      height: Get.width * 0.15,
                      child: Center(
                        child: Container(
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
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Total Referrals:',
                      style: kBlackDarkMediumStyle,
                    ),
                    const Spacer(),
                    Text(
                      '${controller.myReferral.value.data!.referralCount}',
                      style: kBlackMediumStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(thickness: 0.30),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (controller.myReferral.value.data!.referralCount_1 > 0) {
                    Get.to(() => const LevelReferralsScreen(level: '1'));
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.1,
                        height: Get.width * 0.1,
                        child: Center(
                          child: Container(
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
                                radius: Get.width * 0.05,
                                child: SvgPicture.asset(
                                  'assets/icons/main_referrals.svg',
                                  width: Get.width * 0.065,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level 1',
                              style: kBlackMediumStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${controller.myReferral.value.data!.referralCount_1}',
                                  style: kBlackDarkMediumStyle,
                                ),
                                Text(
                                  'Referrals',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.myReferral.value.data!.referralEarning_1.toString()).toStringAsFixed(2)}',
                              style: kBlackDarkLargeStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (controller.myReferral.value.data!.referralCount_2 > 0) {
                    Get.to(() => const LevelReferralsScreen(level: '2'));
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.1,
                        height: Get.width * 0.1,
                        child: Center(
                          child: Container(
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
                                radius: Get.width * 0.05,
                                child: SvgPicture.asset(
                                  'assets/icons/main_referrals.svg',
                                  width: Get.width * 0.065,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level 2',
                              style: kBlackMediumStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${controller.myReferral.value.data!.referralCount_2}',
                                  style: kBlackDarkMediumStyle,
                                ),
                                Text(
                                  'Referrals',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.myReferral.value.data!.referralEarning_2.toString()).toStringAsFixed(2)}',
                              style: kBlackDarkLargeStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (controller.myReferral.value.data!.referralCount_3 > 0) {
                    Get.to(() => const LevelReferralsScreen(level: '3'));
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.1,
                        height: Get.width * 0.1,
                        child: Center(
                          child: Container(
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
                                radius: Get.width * 0.05,
                                child: SvgPicture.asset(
                                  'assets/icons/main_referrals.svg',
                                  width: Get.width * 0.065,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level 3',
                              style: kBlackMediumStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${controller.myReferral.value.data!.referralCount_3}',
                                  style: kBlackDarkMediumStyle,
                                ),
                                Text(
                                  'Referrals',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.myReferral.value.data!.referralEarning_3.toString()).toStringAsFixed(2)}',
                              style: kBlackDarkLargeStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (controller.myReferral.value.data!.referralCount_4 > 0) {
                    Get.to(() => const LevelReferralsScreen(level: '4'));
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.1,
                        height: Get.width * 0.1,
                        child: Center(
                          child: Container(
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
                                radius: Get.width * 0.05,
                                child: SvgPicture.asset(
                                  'assets/icons/main_referrals.svg',
                                  width: Get.width * 0.065,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level 4',
                              style: kBlackMediumStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${controller.myReferral.value.data!.referralCount_4}',
                                  style: kBlackDarkMediumStyle,
                                ),
                                Text(
                                  'Referrals',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.myReferral.value.data!.referralEarning_4.toString()).toStringAsFixed(2)}',
                              style: kBlackDarkLargeStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (controller.myReferral.value.data!.referralCount_5 > 0) {
                    Get.to(() => const LevelReferralsScreen(level: '5'));
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width * 0.1,
                        height: Get.width * 0.1,
                        child: Center(
                          child: Container(
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
                                radius: Get.width * 0.05,
                                child: SvgPicture.asset(
                                  'assets/icons/main_referrals.svg',
                                  width: Get.width * 0.065,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level 5',
                              style: kBlackMediumStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${controller.myReferral.value.data!.referralCount_5}',
                                  style: kBlackDarkMediumStyle,
                                ),
                                Text(
                                  'Referrals',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.myReferral.value.data!.referralEarning_5.toString()).toStringAsFixed(2)}',
                              style: kBlackDarkLargeStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
