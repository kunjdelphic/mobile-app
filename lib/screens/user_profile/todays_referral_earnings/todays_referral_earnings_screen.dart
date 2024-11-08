import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../widgets/dialogs/snackbars.dart';

class TodaysReferralEarningsScreen extends StatefulWidget {
  const TodaysReferralEarningsScreen({Key? key}) : super(key: key);

  @override
  _TodaysReferralEarningsScreenState createState() =>
      _TodaysReferralEarningsScreenState();
}

class _TodaysReferralEarningsScreenState
    extends State<TodaysReferralEarningsScreen> {
  ReferralController referralController = Get.find();
  UserProfileController userProfileController = Get.find();
  List openedLevels = [];
  int page_no_1 = 0;

  bool showLoadMore_1 = false;
  int page_no_2 = 0;

  bool showLoadMore_2 = false;
  int page_no_3 = 0;

  bool showLoadMore_3 = false;
  int page_no_4 = 0;

  bool showLoadMore_4 = false;
  int page_no_5 = 0;

  bool showLoadMore_5 = false;

  @override
  void initState() {
    super.initState();
    showLoadMore_1 = referralController.todaysReferralEarnings.value.data!
            .levelWise!.level1!.transactions!.length ==
        10;
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
          "Today's Referral Earnings",
          style: kBlackLargeStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // var res = await Get.to(() => LevelReferralsFilterScreen(
              //       filterMap: filterMap,
              //     ));
              // if (res != null) {
              //   filterMap = res;
              //   // getAllMyLevelReferralUsers(map: res);
              //   _future = getAllMyLevelReferralUsers(map: res);
              // }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/ic_filter.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetX<ReferralController>(
        init: referralController,
        builder: (controller) {
          if (controller.isFetchingTodaysReferralEarnings.value) {
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
          if (controller.todaysReferralEarnings.value.status != 200) {
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
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            children: [
              Container(
                width: Get.width * 0.9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    openedLevels.contains(1)
                        ? openedLevels.remove(1)
                        : openedLevels.add(1);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Level 1 - ',
                        style: kBlueMediumStyle,
                      ),
                      Text(
                        'RM ${controller.todaysReferralEarnings.value.data!.levelWise!.level1!.total}',
                        style: kGreenMediumStyle,
                      ),
                      const Spacer(),
                      Icon(
                        openedLevels.contains(1)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              openedLevels.contains(1)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                                  Container(
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
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
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: controller
                                                      .todaysReferralEarnings
                                                      .value
                                                      .data!
                                                      .levelWise!
                                                      .level1!
                                                      .transactions![index]
                                                      .profileImage !=
                                                  null
                                              ? Image.network(
                                                  controller
                                                      .todaysReferralEarnings
                                                      .value
                                                      .data!
                                                      .levelWise!
                                                      .level1!
                                                      .transactions![index]
                                                      .profileImage!,
                                                  width: Get.width * 0.1,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const Icon(
                                                    Icons.error,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icons/referrals_white.png',
                                                  width: Get.width * 0.08,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                '${controller.todaysReferralEarnings.value.data!.levelWise!.level1!.transactions![index].name}',
                                                style: kBlackMediumStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${controller.todaysReferralEarnings.value.data!.levelWise!.level1!.transactions![index].productName}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.todaysReferralEarnings.value.data!.levelWise!.level1!.transactions![index].amount.toString()).toStringAsFixed(2)}',
                                              style: kPrimaryDarkLargeStyle,
                                            ),
                                            Text(
                                              '${CommonTools().getTime(controller.todaysReferralEarnings.value.data!.levelWise!.level1!.transactions![index].timestamp!)}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: controller.todaysReferralEarnings.value
                              .data!.levelWise!.level1!.transactions!.length,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        Visibility(
                          visible: showLoadMore_1,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GradientButton(
                              text: 'Load more',
                              width: true,
                              widthSize: Get.width * 0.35,
                              buttonState: continueBtnState_1,
                              onTap: () async {
                                setState(() {
                                  continueBtnState_1 = ButtonState.loading;
                                });
                                page_no_1++;

                                var res = await referralController
                                    .getTodaysReferralEarnings({
                                  "keywords": [],
                                  "start_time": null,
                                  "end_time": null,
                                  "arrange_by": "HIGHEST_TO_LOWEST",
                                  'day': DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                      .format(DateTime.now()),
                                  "page_no": page_no_1
                                }, refreshing: true);

                                List moreData =
                                    res!.data!.levelWise!.level1!.transactions!;

                                if (moreData.isEmpty) {
                                  showLoadMore_1 = false;
                                  successSnackbar(
                                      title: 'Loaded',
                                      subtitle:
                                          "All referrals for level 1 are loaded");
                                } else {
                                  controller.todaysReferralEarnings
                                      .update((val) {
                                    val!.data!.levelWise!.level1!.transactions!
                                        .addAll(res.data!.levelWise!.level1!
                                            .transactions!);
                                  });
                                }

                                setState(() {
                                  continueBtnState_1 = ButtonState.success;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    openedLevels.contains(2)
                        ? openedLevels.remove(2)
                        : openedLevels.add(2);
                    showLoadMore_2 = referralController
                            .todaysReferralEarnings
                            .value
                            .data!
                            .levelWise!
                            .level2!
                            .transactions!
                            .length ==
                        10;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Level 2 - ',
                        style: kBlueMediumStyle,
                      ),
                      Text(
                        'RM ${controller.todaysReferralEarnings.value.data!.levelWise!.level2!.total}',
                        style: kGreenMediumStyle,
                      ),
                      const Spacer(),
                      Icon(
                        openedLevels.contains(2)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              openedLevels.contains(2)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                                  Container(
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
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
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.asset(
                                            'assets/icons/referrals_white.png',
                                            width: Get.width * 0.08,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                '${controller.todaysReferralEarnings.value.data!.levelWise!.level2!.transactions![index].name}',
                                                style: kBlackMediumStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${controller.todaysReferralEarnings.value.data!.levelWise!.level2!.transactions![index].productName}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.todaysReferralEarnings.value.data!.levelWise!.level2!.transactions![index].amount.toString()).toStringAsFixed(2)}',
                                              style: kPrimaryDarkLargeStyle,
                                            ),
                                            Text(
                                              '${CommonTools().getTime(controller.todaysReferralEarnings.value.data!.levelWise!.level2!.transactions![index].timestamp!)}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: controller.todaysReferralEarnings.value
                              .data!.levelWise!.level2!.transactions!.length,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        Visibility(
                          visible: showLoadMore_2,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GradientButton(
                              text: 'Load more',
                              width: true,
                              widthSize: Get.width * 0.35,
                              buttonState: continueBtnState_2,
                              onTap: () async {
                                setState(() {
                                  continueBtnState_2 = ButtonState.loading;
                                });
                                page_no_2++;
                                var res = await referralController
                                    .getTodaysReferralEarnings({
                                  "keywords": [],
                                  "start_time": null,
                                  "end_time": null,
                                  "arrange_by": "HIGHEST_TO_LOWEST",
                                  'day': DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                      .format(DateTime.now()),
                                  "page_no": page_no_2
                                }, refreshing: true);

                                List moreData =
                                    res!.data!.levelWise!.level2!.transactions!;

                                if (moreData.isEmpty) {
                                  showLoadMore_2 = false;
                                  successSnackbar(
                                      title: 'Loaded',
                                      subtitle:
                                          "All referrals for level 2 are loaded");
                                } else {
                                  controller.todaysReferralEarnings
                                      .update((val) {
                                    val!.data!.levelWise!.level2!.transactions!
                                        .addAll(res.data!.levelWise!.level2!
                                            .transactions!);
                                  });
                                }

                                setState(() {
                                  continueBtnState_2 = ButtonState.success;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    openedLevels.contains(3)
                        ? openedLevels.remove(3)
                        : openedLevels.add(3);
                    showLoadMore_3 = referralController
                            .todaysReferralEarnings
                            .value
                            .data!
                            .levelWise!
                            .level3!
                            .transactions!
                            .length ==
                        10;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Level 3 - ',
                        style: kBlueMediumStyle,
                      ),
                      Text(
                        'RM ${controller.todaysReferralEarnings.value.data!.levelWise!.level3!.total}',
                        style: kGreenMediumStyle,
                      ),
                      const Spacer(),
                      Icon(
                        openedLevels.contains(3)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              openedLevels.contains(3)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                                  Container(
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
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
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.asset(
                                            'assets/icons/referrals_white.png',
                                            width: Get.width * 0.08,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                '${controller.todaysReferralEarnings.value.data!.levelWise!.level3!.transactions![index].name}',
                                                style: kBlackMediumStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${controller.todaysReferralEarnings.value.data!.levelWise!.level3!.transactions![index].productName}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.todaysReferralEarnings.value.data!.levelWise!.level3!.transactions![index].amount.toString()).toStringAsFixed(2)}',
                                              style: kPrimaryDarkLargeStyle,
                                            ),
                                            Text(
                                              '${CommonTools().getTime(controller.todaysReferralEarnings.value.data!.levelWise!.level3!.transactions![index].timestamp!)}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: controller.todaysReferralEarnings.value
                              .data!.levelWise!.level3!.transactions!.length,
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 11,
              ),
              Visibility(
                visible: showLoadMore_3,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GradientButton(
                    text: 'Load more',
                    width: true,
                    widthSize: Get.width * 0.35,
                    buttonState: continueBtnState_3,
                    onTap: () async {
                      setState(() {
                        continueBtnState_3 = ButtonState.loading;
                      });
                      page_no_3++;
                      var res =
                          await referralController.getTodaysReferralEarnings({
                        "keywords": [],
                        "start_time": null,
                        "end_time": null,
                        "arrange_by": "HIGHEST_TO_LOWEST",
                        'day': DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                            .format(DateTime.now()),
                        "page_no": page_no_3
                      }, refreshing: true, index: 3);
                      log(res.toString());

                      List moreData =
                          res!.data!.levelWise!.level3!.transactions!;

                      if (moreData.isEmpty) {
                        showLoadMore_3 = false;
                        successSnackbar(
                            title: 'Loaded',
                            subtitle: "All referrals for level 3 are loaded");
                      } else {
                        controller.todaysReferralEarnings.update((val) {
                          val!.data!.levelWise!.level3!.transactions!.addAll(
                              res.data!.levelWise!.level3!.transactions!);
                        });
                      }

                      setState(() {
                        continueBtnState_3 = ButtonState.success;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    openedLevels.contains(4)
                        ? openedLevels.remove(4)
                        : openedLevels.add(4);
                    showLoadMore_4 = referralController
                            .todaysReferralEarnings
                            .value
                            .data!
                            .levelWise!
                            .level4!
                            .transactions!
                            .length ==
                        10;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Level 4 - ',
                        style: kBlueMediumStyle,
                      ),
                      Text(
                        'RM ${controller.todaysReferralEarnings.value.data!.levelWise!.level4!.total}',
                        style: kGreenMediumStyle,
                      ),
                      const Spacer(),
                      Icon(
                        openedLevels.contains(4)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              openedLevels.contains(4)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                                  Container(
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
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
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.asset(
                                            'assets/icons/referrals_white.png',
                                            width: Get.width * 0.08,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                '${controller.todaysReferralEarnings.value.data!.levelWise!.level4!.transactions![index].name}',
                                                style: kBlackMediumStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${controller.todaysReferralEarnings.value.data!.levelWise!.level4!.transactions![index].productName}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.todaysReferralEarnings.value.data!.levelWise!.level4!.transactions![index].amount.toString()).toStringAsFixed(2)}',
                                              style: kPrimaryDarkLargeStyle,
                                            ),
                                            Text(
                                              '${CommonTools().getTime(controller.todaysReferralEarnings.value.data!.levelWise!.level4!.transactions![index].timestamp!)}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: controller.todaysReferralEarnings.value
                              .data!.levelWise!.level4!.transactions!.length,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        Visibility(
                          visible: showLoadMore_4,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GradientButton(
                              text: 'Load more',
                              width: true,
                              widthSize: Get.width * 0.35,
                              buttonState: continueBtnState_4,
                              onTap: () async {
                                setState(() {
                                  continueBtnState_4 = ButtonState.loading;
                                });
                                page_no_4++;
                                var res = await referralController
                                    .getTodaysReferralEarnings({
                                  "keywords": [],
                                  "start_time": null,
                                  "end_time": null,
                                  "arrange_by": "HIGHEST_TO_LOWEST",
                                  'day': DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                      .format(DateTime.now()),
                                  "page_no": page_no_4
                                }, refreshing: true);

                                List moreData =
                                    res!.data!.levelWise!.level4!.transactions!;

                                if (moreData.isEmpty) {
                                  showLoadMore_4 = false;
                                  successSnackbar(
                                      title: 'Loaded',
                                      subtitle:
                                          "All referrals for level 4 are loaded");
                                } else {
                                  controller.todaysReferralEarnings
                                      .update((val) {
                                    val!.data!.levelWise!.level4!.transactions!
                                        .addAll(res.data!.levelWise!.level4!
                                            .transactions!);
                                  });
                                }

                                setState(() {
                                  continueBtnState_4 = ButtonState.success;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    openedLevels.contains(5)
                        ? openedLevels.remove(5)
                        : openedLevels.add(5);
                    showLoadMore_5 = referralController
                            .todaysReferralEarnings
                            .value
                            .data!
                            .levelWise!
                            .level5!
                            .transactions!
                            .length ==
                        10;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffF6F6F6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Level 5 - ',
                        style: kBlueMediumStyle,
                      ),
                      Text(
                        'RM ${controller.todaysReferralEarnings.value.data!.levelWise!.level5!.total}',
                        style: kGreenMediumStyle,
                      ),
                      const Spacer(),
                      Icon(
                        openedLevels.contains(5)
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black54,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              openedLevels.contains(5)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                                  Container(
                                    width: Get.width * 0.1,
                                    height: Get.width * 0.1,
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
                                      margin: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.asset(
                                            'assets/icons/referrals_white.png',
                                            width: Get.width * 0.08,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                '${controller.todaysReferralEarnings.value.data!.levelWise!.level5!.transactions![index].name}',
                                                style: kBlackMediumStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${controller.todaysReferralEarnings.value.data!.levelWise!.level5!.transactions![index].productName}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${userProfileController.userProfile.value.data!.currency} ${double.parse(controller.todaysReferralEarnings.value.data!.levelWise!.level5!.transactions![index].amount.toString()).toStringAsFixed(2)}',
                                              style: kPrimaryDarkLargeStyle,
                                            ),
                                            Text(
                                              '${CommonTools().getTime(controller.todaysReferralEarnings.value.data!.levelWise!.level5!.transactions![index].timestamp!)}',
                                              style:
                                                  kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                          itemCount: controller.todaysReferralEarnings.value
                              .data!.levelWise!.level5!.transactions!.length,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        Visibility(
                          visible: showLoadMore_5,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GradientButton(
                              text: 'Load more',
                              width: true,
                              widthSize: Get.width * 0.35,
                              buttonState: continueBtnState_5,
                              onTap: () async {
                                setState(() {
                                  continueBtnState_5 = ButtonState.loading;
                                });
                                page_no_5++;
                                var res = await referralController
                                    .getTodaysReferralEarnings({
                                  "keywords": [],
                                  "start_time": null,
                                  "end_time": null,
                                  "arrange_by": "HIGHEST_TO_LOWEST",
                                  'day': DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                      .format(DateTime.now()),
                                  "page_no": page_no_5
                                }, refreshing: true);

                                List moreData =
                                    res!.data!.levelWise!.level5!.transactions!;

                                if (moreData.isEmpty) {
                                  showLoadMore_5 = false;
                                  successSnackbar(
                                      title: 'Loaded',
                                      subtitle:
                                          "All referrals for level 5 are loaded");
                                } else {
                                  controller.todaysReferralEarnings
                                      .update((val) {
                                    val!.data!.levelWise!.level5!.transactions!
                                        .addAll(res.data!.levelWise!.level5!
                                            .transactions!);
                                  });
                                }

                                setState(() {
                                  continueBtnState_5 = ButtonState.success;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  ButtonState continueBtnState_1 = ButtonState.idle;

  ButtonState continueBtnState_2 = ButtonState.idle;

  ButtonState continueBtnState_3 = ButtonState.idle;

  ButtonState continueBtnState_4 = ButtonState.idle;

  ButtonState continueBtnState_5 = ButtonState.idle;
}
