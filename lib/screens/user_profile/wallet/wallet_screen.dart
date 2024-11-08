import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/screens/user_profile/earning_history/earning_history_screen.dart';
import 'package:parrotpos/screens/user_profile/referrals/referrals_screen.dart';
import 'package:parrotpos/screens/user_profile/todays_referral_earnings/todays_referral_earnings_screen.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/transaction_history_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/send_money/send_money_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/wallet/earning_history_item.dart';
import 'package:parrotpos/widgets/wallet/transaction_history_item.dart';

import 'earning_wallet/wallet_activation/ew_1_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({
    Key? key,
  }) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  ReferralController referralController = Get.find();
  WalletController walletController = Get.find();
  UserProfileController userProfileController = Get.find();

  @override
  void initState() {
    super.initState();

    // if (referralController.todaysReferralEarnings.value.data == null) {
    referralController
        .getTodaysReferralEarnings({"keywords": [], "start_time": null, "end_time": null, "arrange_by": "HIGHEST_TO_LOWEST", 'day': DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now())});
    // }

    // if (walletController.earningWallet.value.data == null) {
    walletController.getEarningWallet({});
    // }

    if (walletController.earningHistory.value.data == null) {
      log('fisrt time called');
      walletController.getEarningHistory();
      // walletController.getEarningHistorySocket();
    } else {
      if (walletController.earningHistory.value.data!.isNotEmpty) {
        walletController.getEarningHistory(refreshing: true);
      }
      walletController.getEarningWallet({});
    }
    // walletController.getEarningHistorySocket();
    walletController.getTransactionHistorySocket();

    if (walletController.transactionHistory.value.data == null) {
      walletController.getTransactionHistory({});
      // walletController.getTransactionHistorySocket();
    } else {
      if (walletController.transactionHistory.value.data!.isNotEmpty) {
        walletController.getTransactionHistory({}, refreshing: true);
      }
      walletController.getEarningWallet({});
    }
  }

  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Wallet",
          style: kBlackLargeStyle,
        ),
      ),
      body: GetX<UserProfileController>(
        init: UserProfileController(),
        builder: (_) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Container(
                // height: 250,
                width: Get.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kColorPrimary,
                      kColorPrimaryDark,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Main Wallet',
                              style: kWhiteDarkMediumStyle,
                            ),
                            Text(
                              'Balance',
                              style: kWhiteDarkMediumStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              'assets/images/logo/logo_full.svg',
                              width: Get.width * 0.2,
                            ),
                            Text(
                              '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
                              style: kWhiteDarkSuperLargeStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${_.userProfile.value.data?.name}',
                          style: kWhiteMediumStyle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const SendMoneyScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kWhite,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/send_money.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Send Money',
                                        style: kBlackSmallMediumStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const MainWalletReloadScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kWhite,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/reload_wallet.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Reload Wallet',
                                        style: kBlackSmallMediumStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GetX<WalletController>(
                init: walletController,
                builder: (controller) {
                  if (controller.isFetchingEarningWallet.value) {
                    return shimmeringWellet(_);
                  }
                  // if (controller.earningWallet.value.data == null) {
                  //   return Center(
                  //     child: SizedBox(
                  //       height: 35,
                  //       child: Text(
                  //         controller.earningWallet.value.message!.toString(),
                  //         style: kBlackSmallMediumStyle,
                  //       ),
                  //     ),
                  //   );
                  // }

                  return Container(
                    // height: 250,
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Earning Wallet',
                                  style: kBlackDarkMediumStyle,
                                ),
                                Text(
                                  'Referral Earnings | T&C Apply',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                              ],
                            ),
                            Text(
                              'Balance',
                              style: kBlackDarkMediumStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    color: const Color(0xffF6F6F6),
                                    // color: kWhite,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Image.asset(
                                    'assets/icons/referrals.png',
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${controller.earningWallet.value.data!.level1Referrals} Referrals',
                                  style: kPrimaryMediumStyle,
                                ),
                              ],
                            ),
                            Text(
                              'RM ${controller.earningWallet.value.data!.earningWalletAmount}',
                              style: controller.earningWallet.value.data!.earningWalletAmount.toString().contains('-') ? kRedDarkSuperLargeStyle : kBlackDarkSuperLargeStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: kWhite.withOpacity(0.7),
                                child: Container(
                                  child: Ink(
                                    height: 45,
                                    // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          kColorPrimary,
                                          kColorPrimaryDark,
                                        ],
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.2),
                                      //     blurRadius: 4,
                                      //     spreadRadius: 1,
                                      //     offset: const Offset(0, 0),
                                      //   ),
                                      // ],
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      splashColor: Colors.white.withOpacity(0.5),
                                      onTap: () {
                                        Get.to(() => const ReferralsScreen());
                                      },
                                      child: Center(
                                        child: Text(
                                          'Referrals',
                                          style: kWhiteMediumStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: kWhite.withOpacity(0.7),
                                child: Container(
                                  child: Ink(
                                    height: 45,
                                    // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff005BA8),
                                          Color(0xff003386),
                                        ],
                                      ),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.2),
                                      //     blurRadius: 4,
                                      //     spreadRadius: 1,
                                      //     offset: const Offset(0, 0),
                                      //   ),
                                      // ],
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      splashColor: Colors.white.withOpacity(0.5),
                                      onTap: () async {
                                        var dialogRes = await deleteDialog(
                                          title: 'Withdrawal to your bank account is currently unavailable, however, you can still add money from your earning wallet to main wallet.',
                                          buttonTitle: 'Yes',
                                          buttonTitle2: 'No',
                                          image: 'assets/icons/change_phone_dl.png',
                                          context: context,
                                          onTapNo: () {
                                            Get.back();
                                          },
                                          onTapYes: () async {
                                            Get.back();

                                            Get.to(() => const MainWalletReloadScreen());
                                          },
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          'Withdraw',
                                          style: kWhiteMediumStyle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _.userProfile.value.data?.accountStatus == 'APPROVED'
                            ? const SizedBox()
                            : _.userProfile.value.data?.accountStatus == 'NOT_APPROVED' || _.userProfile.value.data?.accountStatus == 'RESUBMIT'
                                ? GestureDetector(
                                    onTap: () async {
                                      await Get.to(() => const EW1Screen());
                                      userProfileController.getUserDetails();
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.15),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                            color: kRedBtnColor1,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          width: Get.width * 0.9,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Activate Earning Wallet',
                                                style: kWhiteMediumStyle,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Spacer(),
                                              Text(
                                                'Verification\nPending',
                                                style: kWhiteExtraSmallMediumStyle,
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: kWhite,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.black45,
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: kWhite,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kColorPrimary.withOpacity(0.3),
                                                  blurRadius: 3,
                                                  spreadRadius: 0.5,
                                                )
                                              ],
                                            ),
                                            width: 14,
                                            height: 14,
                                            child: const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: kRedBtnColor1,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _.userProfile.value.data?.accountStatus == 'PENDING'
                                    ? GestureDetector(
                                        onTap: () async {
                                          await Get.to(() => const EW1Screen());
                                          userProfileController.getUserDetails();
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.15),
                                                    blurRadius: 10,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                                color: const Color(0xffFFD958),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              width: Get.width * 0.9,
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Verification in Process…',
                                                    style: kBlackMediumStyle,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    'Verification\nPending',
                                                    style: kBlackExtraSmallMediumStyle,
                                                  ),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: kWhite,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black45,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: kWhite,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: kColorPrimary.withOpacity(0.3),
                                                      blurRadius: 3,
                                                      spreadRadius: 0.5,
                                                    )
                                                  ],
                                                ),
                                                width: 14,
                                                height: 14,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: kRedBtnColor1,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              GetX<ReferralController>(
                init: referralController,
                builder: (controller) {
                  if (controller.isFetchingTodaysReferralEarnings.value) {
                    return todayEarningShimmer();
                  }
                  if (controller.todaysReferralEarnings.value.data == null) {
                    return Center(
                      child: SizedBox(
                        height: 35,
                        child: Text(
                          '${controller.todaysReferralEarnings.value.message}',
                          style: kBlackSmallMediumStyle,
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => const TodaysReferralEarningsScreen());
                    },
                    child: Container(
                      width: Get.width * 0.9,
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                              color: const Color(0xffF6F6F6),
                              // color: kWhite,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/ref_earnings.png',
                                height: 35,
                                width: 35,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'RM ${controller.todaysReferralEarnings.value.data!.todaysReferralEarningWalletAmount}',
                                  style: kPrimaryDarkSuperLargeStyle,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Today\'s Referral Earnings',
                                  style: kBlackDarkMediumStyle,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Total Referrals: ${controller.todaysReferralEarnings.value.data!.totalReferrals}',
                                  style: kBlackSmallMediumStyle,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black26,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: Get.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                              });
                            },
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: selectedTab == 0
                                      ? [
                                          kColorPrimary,
                                          kColorPrimaryDark,
                                        ]
                                      : [
                                          const Color(0xffEDEDED),
                                          const Color(0xffEDEDED),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Earning History',
                                  overflow: TextOverflow.ellipsis,
                                  style: selectedTab == 0 ? kWhiteMediumStyle : kBlackLightMediumStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                              });
                            },
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: selectedTab == 1
                                      ? [
                                          kColorPrimary,
                                          kColorPrimaryDark,
                                        ]
                                      : [
                                          const Color(0xffEDEDED),
                                          const Color(0xffEDEDED),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Transaction History',
                                  overflow: TextOverflow.ellipsis,
                                  style: selectedTab == 1 ? kWhiteMediumStyle : kBlackLightMediumStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    selectedTab == 0
                        ? GetX<WalletController>(
                            init: walletController,
                            builder: (controller) {
                              if (controller.isFetchingEarningHistory.value) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: SizedBox(
                                      height: 25,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.lineScalePulseOut,
                                        colors: [
                                          kAccentColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (controller.earningHistory.value.data == null) {
                                return Center(
                                  child: SizedBox(
                                    height: 35,
                                    child: Text(
                                      '${controller.earningHistory.value.message}',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                );
                              }

                              if (controller.earningHistory.value.data!.isEmpty) {
                                return Center(
                                  child: SizedBox(
                                    height: 35,
                                    child: Text(
                                      'No earning history!',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                itemBuilder: (context, index) {
                                  return EarningHistoryItem(
                                    earningHistoryData: controller.earningHistory.value.data![index],
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                  height: 12,
                                ),
                                itemCount: controller.earningHistory.value.data!.length > 3 ? 3 : controller.earningHistory.value.data!.length,
                              );
                            },
                          )
                        : GetX<WalletController>(
                            init: walletController,
                            builder: (controller) {
                              if (controller.isFetchingTransactionHistory.value) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: SizedBox(
                                      height: 25,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.lineScalePulseOut,
                                        colors: [
                                          kAccentColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (controller.transactionHistory.value.data == null) {
                                return Center(
                                  child: SizedBox(
                                    height: 35,
                                    child: Text(
                                      controller.transactionHistory.value.message!,
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                );
                              }
                              if (controller.transactionHistory.value.data!.isEmpty) {
                                return Center(
                                  child: SizedBox(
                                    height: 35,
                                    child: Text(
                                      'No transaction history!',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ),
                                );
                              }

                              print('T HIS ::: ===>>>');
                              print(controller.transactionHistory.value.data!.length);

                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                itemBuilder: (context, index) {
                                  return TransactionHistoryItem(
                                    transactionHistoryData: controller.transactionHistory.value.data![index],
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                  height: 12,
                                ),
                                itemCount: controller.transactionHistory.value.data!.length > 3 ? 3 : controller.transactionHistory.value.data!.length,
                              );
                            },
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    selectedTab == 0
                        ? TextButton(
                            onPressed: () {
                              Get.to(() => const EarningHistoryScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View All Earning History ',
                                  style: kPrimaryDarkMediumStyle,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: kColorPrimaryDark,
                                ),
                              ],
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              Get.to(() => const TransactionHistoryScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'View All Transaction History ',
                                  style: kPrimaryDarkMediumStyle,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                  color: kColorPrimaryDark,
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget shimmeringWellet(_) {
  return Container(
    // height: 250,
    width: Get.width * 0.9,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: kWhite,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earning Wallet',
                  style: kBlackDarkMediumStyle,
                ),
                Text(
                  'Referral Earnings | T&C Apply',
                  style: kBlackExtraSmallLightMediumStyle,
                ),
              ],
            ),
            Text(
              'Balance',
              style: kBlackDarkMediumStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                    color: const Color(0xffF6F6F6),
                    // color: kWhite,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                    'assets/icons/referrals.png',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  // margin: const EdgeInsets.only(right: 10, top: 5),
                  height: 20, width: 20,
                  child: const LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                    colors: [
                      kColorPrimaryLight,
                    ],
                  ),
                ),
              ],
            ),
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.only(right: 10, top: 5),
            //     height: 20,
            //     child: const LoadingIndicator(
            //       indicatorType: Indicator.lineScalePulseOut,
            //       colors: [
            //         kAccentColor,
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Get.to(() => const ReferralsScreen());
                },
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kColorPrimary,
                        kColorPrimaryDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Referrals',
                      style: kWhiteMediumStyle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: null,
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff005BA8),
                        Color(0xff003386),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Withdraw',
                        style: kWhiteMediumStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 3,
        ),
        const SizedBox(
          height: 15,
        ),
        _.userProfile.value.data?.accountStatus == 'APPROVED'
            ? const SizedBox()
            : _.userProfile.value.data?.accountStatus == 'NOT_APPROVED' || _.userProfile.value.data?.accountStatus == 'RESUBMIT'
                ? GestureDetector(
                    onTap: null,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kRedBtnColor1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: Get.width * 0.9,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                'Activate Earning Wallet',
                                style: kWhiteMediumStyle,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Spacer(),
                              Text(
                                'Verification\nPending',
                                style: kWhiteExtraSmallMediumStyle,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black45,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kColorPrimary.withOpacity(0.3),
                                  blurRadius: 3,
                                  spreadRadius: 0.5,
                                )
                              ],
                            ),
                            width: 14,
                            height: 14,
                            child: const Center(
                              child: Icon(
                                Icons.error,
                                color: kRedBtnColor1,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : _.userProfile.value.data?.accountStatus == 'PENDING'
                    ? GestureDetector(
                        onTap: null,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                                color: const Color(0xffFFD958),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: Get.width * 0.9,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Verification in Process…',
                                    style: kBlackMediumStyle,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Verification\nPending',
                                    style: kBlackExtraSmallMediumStyle,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black45,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: kWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kColorPrimary.withOpacity(0.3),
                                      blurRadius: 3,
                                      spreadRadius: 0.5,
                                    )
                                  ],
                                ),
                                width: 14,
                                height: 14,
                                child: const Center(
                                  child: Icon(
                                    Icons.error,
                                    color: kRedBtnColor1,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
      ],
    ),
  );
}

Widget todayEarningShimmer() {
  return GestureDetector(
    // onTap: () {
    //   Get.to(() => const TodaysReferralEarningsScreen());
    // },
    child: Container(
      width: Get.width * 0.9,
      height: 100,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
              color: const Color(0xffF6F6F6),
              // color: kWhite,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/ref_earnings.png',
                height: 35,
                width: 35,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // margin: const EdgeInsets.only(right: 10, top: 5),
                  height: 20, width: 20,
                  child: const LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                    colors: [
                      kColorPrimaryLight,
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Today\'s Referral Earnings',
                  style: kBlackDarkMediumStyle,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Total Referrals: 0',
                  style: kBlackSmallMediumStyle,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black26,
            size: 22,
          ),
        ],
      ),
    ),
  );
}
