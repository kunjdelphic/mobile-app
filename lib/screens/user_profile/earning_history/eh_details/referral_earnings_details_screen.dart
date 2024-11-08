import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/day_referral_earning.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/referral_earnings_filter_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../../widgets/buttons/gradient_button.dart';

class ReferralEarningsDetailsScreen extends StatefulWidget {
  final EarningHistoryData earningHistoryData;
  const ReferralEarningsDetailsScreen(
      {Key? key, required this.earningHistoryData})
      : super(key: key);

  @override
  _ReferralEarningsDetailsScreenState createState() =>
      _ReferralEarningsDetailsScreenState();
}

class _ReferralEarningsDetailsScreenState
    extends State<ReferralEarningsDetailsScreen> {
  List openedLevels = [];
  DayReferralEarning? dayReferralEarning;
  WalletController walletController = Get.find();
  late Future<DayReferralEarning?> _futureDayRefEarning;
  Map? filterMap;

  ButtonState continueBtnState_1 = ButtonState.idle;

  ButtonState continueBtnState_2 = ButtonState.idle;

  ButtonState continueBtnState_3 = ButtonState.idle;

  ButtonState continueBtnState_4 = ButtonState.idle;

  ButtonState continueBtnState_5 = ButtonState.idle;
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

    _futureDayRefEarning = getDayReferralEarning(
        {
          "keywords": [],
          "start_time": null,
          "end_time": null,
          "arrange_by": "HIGHEST_TO_LOWEST",
          "day": widget.earningHistoryData.timestamp
        },
        false,
        {});
  }

  Future<DayReferralEarning> getDayReferralEarning(
      Map map, bool loadingMore, Map<String, dynamic> loadMoreData) async {
    if (loadingMore) {
      int pageNNN = loadMoreData['page_no'];
      // pageNNN++;
      // DayReferralEarning? dayReferralEarning;
      var res = await walletController.getDayReferralEarning({
        "keywords": [],
        "start_time": null,
        "end_time": null,
        "arrange_by": "HIGHEST_TO_LOWEST",
        "day": widget.earningHistoryData.timestamp,
        "page_no": pageNNN
      });
      switch (loadMoreData['index']) {
        case 1:
          page_no_1++;
          List<Transactions> moreData =
              res.data!.levelWise!.level1!.transactions!;

          if (moreData.isEmpty) {
            showLoadMore_1 = false;
            successSnackbar(
                title: 'Loaded', subtitle: "All level 1 referrals are loaded");
          } else {
            dayReferralEarning!.data!.levelWise!.level1!.transactions!
                .addAll(moreData);
            double temp = double.parse(
                dayReferralEarning!.data!.levelWise!.level1!.total.toString());
            temp +=
                double.parse(res.data!.levelWise!.level1!.total!.toString());
            dayReferralEarning!.data!.levelWise!.level1!.total =
                temp.round().toString();
          }
          break;
        case 2:
          page_no_2++;
          List<Transactions> moreData =
              res.data!.levelWise!.level2!.transactions!;

          if (moreData.isEmpty) {
            showLoadMore_2 = false;
            successSnackbar(
                title: 'Loaded', subtitle: "All level 2 referrals are loaded");
          } else {
            dayReferralEarning!.data!.levelWise!.level2!.transactions!
                .addAll(moreData);
            double temp = double.parse(
                dayReferralEarning!.data!.levelWise!.level2!.total.toString());
            temp +=
                double.parse(res.data!.levelWise!.level2!.total!.toString());
            dayReferralEarning!.data!.levelWise!.level2!.total =
                temp.round().toString();
          }

          break;
        case 3:
          page_no_3++;
          List<Transactions> moreData =
              res.data!.levelWise!.level3!.transactions!;

          if (moreData.isEmpty) {
            showLoadMore_3 = false;
            successSnackbar(
                title: 'Loaded', subtitle: "All level 3 referrals are loaded");
          } else {
            dayReferralEarning!.data!.levelWise!.level3!.transactions!
                .addAll(moreData);
            double temp = double.parse(
                dayReferralEarning!.data!.levelWise!.level3!.total.toString());
            temp +=
                double.parse(res.data!.levelWise!.level3!.total!.toString());
            dayReferralEarning!.data!.levelWise!.level3!.total =
                temp.round().toString();
          }
          break;
        case 4:
          page_no_4++;
          List<Transactions> moreData =
              res.data!.levelWise!.level4!.transactions!;

          if (moreData.isEmpty) {
            showLoadMore_4 = false;
            successSnackbar(
                title: 'Loaded', subtitle: "All level 4 referrals are loaded");
          } else {
            dayReferralEarning!.data!.levelWise!.level4!.transactions!
                .addAll(moreData);
            double temp = double.parse(
                dayReferralEarning!.data!.levelWise!.level4!.total.toString());
            temp +=
                double.parse(res.data!.levelWise!.level4!.total!.toString());
            dayReferralEarning!.data!.levelWise!.level4!.total =
                temp.round().toString();
          }
          break;
        case 5:
          page_no_5++;
          List<Transactions> moreData =
              res.data!.levelWise!.level5!.transactions!;

          if (moreData.isEmpty) {
            showLoadMore_5 = false;
            successSnackbar(
                title: 'Loaded', subtitle: "All level 5 referrals are loaded");
          } else {
            dayReferralEarning!.data!.levelWise!.level5!.transactions!
                .addAll(moreData);

            double temp = double.parse(
                dayReferralEarning!.data!.levelWise!.level5!.total.toString());
            temp +=
                double.parse(res.data!.levelWise!.level5!.total!.toString());
            dayReferralEarning!.data!.levelWise!.level5!.total =
                temp.round().toString();
          }
          break;
        default:
      }
      setState(() {});
      return dayReferralEarning!;
    } else {
      var res = await walletController.getDayReferralEarning(map);

      // setState(() {});
      showLoadMore_1 = res.data!.levelWise!.level1!.transactions!.length == 10;

      showLoadMore_2 = res.data!.levelWise!.level2!.transactions!.length == 10;

      showLoadMore_3 = res.data!.levelWise!.level3!.transactions!.length == 10;

      showLoadMore_4 = res.data!.levelWise!.level4!.transactions!.length == 10;

      showLoadMore_5 = res.data!.levelWise!.level5!.transactions!.length == 10;
      if (res.status == 200) {
        //got it
        dayReferralEarning = res;

        return res;
      } else {
        //error
        errorSnackbar(title: 'Failed', subtitle: '${res.message}');
        return res;
      }
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
          "Referral Earnings",
          style: kBlackLargeStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (dayReferralEarning != null) {
                var res = await Get.to(() => ReferralEarningsFilterScreen(
                      filterMap: filterMap,
                      earningHistoryData: widget.earningHistoryData,
                    ));
                if (res != null) {
                  filterMap = res;
                  // getAllMyLevelReferralUsers(map: res);
                  setState(() {
                    _futureDayRefEarning = getDayReferralEarning(res, true, {});
                  });
                }
              }
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
      body: FutureBuilder<DayReferralEarning?>(
          future: _futureDayRefEarning,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
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
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  'Failed to fetch referral earnings!',
                  style: kBlackMediumStyle,
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                          color: const Color(0xffF6F6F6),
                          // color: kWhite,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.asset(
                          'assets/icons/earning_history/ic_referral_earning.png',
                          // width: 18,
                          // height: 18,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  CommonTools().getDate(
                                      widget.earningHistoryData.timestamp!),
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                // Row(
                                //   children: [
                                //     Image.asset(
                                //       'assets/icons/earning_history/ic_blue_wallet.png',
                                //       width: 13,
                                //       height: 13,
                                //     ),
                                //     const SizedBox(
                                //       width: 5,
                                //     ),
                                //     Text(
                                //       'RM 25.00',
                                //       style: kBlackDarkMediumStyle,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            const Divider(thickness: 0.30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Referral Earnings',
                                  style: kBlackMediumStyle,
                                ),
                                Text(
                                  '${widget.earningHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.earningHistoryData.currency} ${widget.earningHistoryData.amount}',
                                  style: kPrimaryDarkExtraLargeStyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Referrals: ${widget.earningHistoryData.others!.referralCount}',
                                  style: kBlackExtraSmallLightMediumStyle,
                                ),
                                // SvgPicture.asset(
                                //   'assets/images/logo/logo_full.svg',
                                //   color: kColorPrimary,
                                //   width: Get.width * 0.1,
                                //   height: 20,
                                // )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (openedLevels.contains(1)) {
                        openedLevels.remove(1);
                      } else {
                        openedLevels.add(1);
                      }
                    });
                  },
                  child: Container(
                    color: const Color(0xffF6F6F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Level 1 - ',
                          style: kBlueMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level1!.total}',
                          style: kPrimaryDarkLargeStyle,
                        ),
                        const Spacer(),
                        Icon(
                          openedLevels.contains(1)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                openedLevels.contains(1)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // Text(snapshot.data!.data!.levelWise!.level1!
                          //     .transactions!.length
                          //     .toString()),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: kWhite,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
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
                                          child: snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level1!
                                                      .transactions![index]
                                                      .profileImage !=
                                                  null
                                              ? Image.network(
                                                  snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level1!
                                                      .transactions![index]
                                                      .profileImage!,
                                                  width: Get.width * 0.065,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/icons/referrals_white.png',
                                                    width: Get.width * 0.065,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icons/referrals_white.png',
                                                  width: Get.width * 0.065,
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
                                                  '${snapshot.data!.data!.levelWise!.level1!.transactions![index].name}',
                                                  style: kBlackMediumStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data!.data!.levelWise!.level1!.transactions![index].productName}',
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
                                                '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level1!.transactions![index].amount}',
                                                style:
                                                    kPrimaryDarkExtraLargeStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                CommonTools().getTime(snapshot
                                                    .data!
                                                    .data!
                                                    .levelWise!
                                                    .level1!
                                                    .transactions![index]
                                                    .timestamp!),
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 15,
                            ),
                            itemCount: snapshot.data!.data!.levelWise!.level1!
                                .transactions!.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  await getDayReferralEarning({}, true,
                                      {'page_no': page_no_1, 'index': 1});
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
                  height: 02,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (openedLevels.contains(2)) {
                        openedLevels.remove(2);
                      } else {
                        openedLevels.add(2);
                      }
                    });
                  },
                  child: Container(
                    color: const Color(0xffF6F6F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Level 2 - ',
                          style: kBlueMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level2!.total}',
                          style: kPrimaryDarkLargeStyle,
                        ),
                        const Spacer(),
                        Icon(
                          openedLevels.contains(2)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                openedLevels.contains(2)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // Text(snapshot.data!.data!.levelWise!.level2!
                          //     .transactions!.length
                          //     .toString()),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: kWhite,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
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
                                          child: snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level2!
                                                      .transactions![index]
                                                      .profileImage !=
                                                  null
                                              ? Image.network(
                                                  snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level2!
                                                      .transactions![index]
                                                      .profileImage!,
                                                  width: Get.width * 0.065,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/icons/referrals_white.png',
                                                    width: Get.width * 0.065,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icons/referrals_white.png',
                                                  width: Get.width * 0.065,
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
                                                  '${snapshot.data!.data!.levelWise!.level2!.transactions![index].name}',
                                                  style: kBlackMediumStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data!.data!.levelWise!.level2!.transactions![index].productName}',
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
                                                '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level2!.transactions![index].amount}',
                                                style:
                                                    kPrimaryDarkExtraLargeStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                CommonTools().getTime(snapshot
                                                    .data!
                                                    .data!
                                                    .levelWise!
                                                    .level2!
                                                    .transactions![index]
                                                    .timestamp!),
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 15,
                            ),
                            itemCount: snapshot.data!.data!.levelWise!.level2!
                                .transactions!.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  await getDayReferralEarning({}, true,
                                      {'page_no': page_no_2, 'index': 2});
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
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (openedLevels.contains(3)) {
                        openedLevels.remove(3);
                      } else {
                        openedLevels.add(3);
                      }
                    });
                  },
                  child: Container(
                    color: const Color(0xffF6F6F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Level 3 - ',
                          style: kBlueMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level3!.total}',
                          style: kPrimaryDarkLargeStyle,
                        ),
                        const Spacer(),
                        Icon(
                          openedLevels.contains(3)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                openedLevels.contains(3)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // Text(snapshot.data!.data!.levelWise!.level3!
                          //     .transactions!.length
                          //     .toString()),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: kWhite,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
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
                                          child: snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level3!
                                                      .transactions![index]
                                                      .profileImage !=
                                                  null
                                              ? Image.network(
                                                  snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level3!
                                                      .transactions![index]
                                                      .profileImage!,
                                                  width: Get.width * 0.065,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/icons/referrals_white.png',
                                                    width: Get.width * 0.065,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icons/referrals_white.png',
                                                  width: Get.width * 0.065,
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
                                                  '${snapshot.data!.data!.levelWise!.level3!.transactions![index].name}',
                                                  style: kBlackMediumStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data!.data!.levelWise!.level3!.transactions![index].productName}',
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
                                                '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level3!.transactions![index].amount}',
                                                style:
                                                    kPrimaryDarkExtraLargeStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                CommonTools().getTime(snapshot
                                                    .data!
                                                    .data!
                                                    .levelWise!
                                                    .level3!
                                                    .transactions![index]
                                                    .timestamp!),
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 15,
                            ),
                            itemCount: snapshot.data!.data!.levelWise!.level3!
                                .transactions!.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  await getDayReferralEarning({}, true,
                                      {'page_no': page_no_3, 'index': 3});
                                  setState(() {
                                    continueBtnState_3 = ButtonState.success;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (openedLevels.contains(4)) {
                        openedLevels.remove(4);
                      } else {
                        openedLevels.add(4);
                      }
                    });
                  },
                  child: Container(
                    color: const Color(0xffF6F6F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Level 4 - ',
                          style: kBlueMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level4!.total}',
                          style: kPrimaryDarkLargeStyle,
                        ),
                        const Spacer(),
                        Icon(
                          openedLevels.contains(4)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                openedLevels.contains(4)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // Text(snapshot.data!.data!.levelWise!.level4!
                          //     .transactions!.length
                          //     .toString()),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: kWhite,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
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
                                          child: snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level4!
                                                      .transactions![index]
                                                      .profileImage !=
                                                  null
                                              ? Image.network(
                                                  snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level4!
                                                      .transactions![index]
                                                      .profileImage!,
                                                  width: Get.width * 0.065,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/icons/referrals_white.png',
                                                    width: Get.width * 0.065,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icons/referrals_white.png',
                                                  width: Get.width * 0.065,
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
                                                  '${snapshot.data!.data!.levelWise!.level4!.transactions![index].name}',
                                                  style: kBlackMediumStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data!.data!.levelWise!.level4!.transactions![index].productName}',
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
                                                '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level4!.transactions![index].amount}',
                                                style:
                                                    kPrimaryDarkExtraLargeStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                CommonTools().getTime(snapshot
                                                    .data!
                                                    .data!
                                                    .levelWise!
                                                    .level4!
                                                    .transactions![index]
                                                    .timestamp!),
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 15,
                            ),
                            itemCount: snapshot.data!.data!.levelWise!.level4!
                                .transactions!.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  await getDayReferralEarning({}, true,
                                      {'page_no': page_no_4, 'index': 4});
                                  setState(() {
                                    continueBtnState_4 = ButtonState.success;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (openedLevels.contains(5)) {
                        openedLevels.remove(5);
                      } else {
                        openedLevels.add(5);
                      }
                    });
                  },
                  child: Container(
                    color: const Color(0xffF6F6F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Level 5 - ',
                          style: kBlueMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level5!.total}',
                          style: kPrimaryDarkLargeStyle,
                        ),
                        const Spacer(),
                        Icon(
                          openedLevels.contains(5)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                openedLevels.contains(5)
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // Text(snapshot.data!.data!.levelWise!.level5!
                          //     .transactions!.length
                          //     .toString()),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(100),
                                    bottomLeft: Radius.circular(100),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: kWhite,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(2),
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
                                          child: snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level5!
                                                      .transactions![index]
                                                      .profileImage !=
                                                  null
                                              ? Image.network(
                                                  snapshot
                                                      .data!
                                                      .data!
                                                      .levelWise!
                                                      .level5!
                                                      .transactions![index]
                                                      .profileImage!,
                                                  width: Get.width * 0.065,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/icons/referrals_white.png',
                                                    width: Get.width * 0.065,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/icons/referrals_white.png',
                                                  width: Get.width * 0.065,
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
                                                  '${snapshot.data!.data!.levelWise!.level5!.transactions![index].name}',
                                                  style: kBlackMediumStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '${snapshot.data!.data!.levelWise!.level5!.transactions![index].productName}',
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
                                                '${widget.earningHistoryData.currency} ${snapshot.data!.data!.levelWise!.level5!.transactions![index].amount}',
                                                style:
                                                    kPrimaryDarkExtraLargeStyle,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                CommonTools().getTime(snapshot
                                                    .data!
                                                    .data!
                                                    .levelWise!
                                                    .level5!
                                                    .transactions![index]
                                                    .timestamp!),
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 15,
                            ),
                            itemCount: snapshot.data!.data!.levelWise!.level5!
                                .transactions!.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          const SizedBox(
                            height: 10,
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
                                  await getDayReferralEarning({}, true,
                                      {'page_no': page_no_5, 'index': 5});
                                  setState(() {
                                    continueBtnState_5 = ButtonState.success;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    : const SizedBox(),
              ],
            );
          }),
    );
  }
}
