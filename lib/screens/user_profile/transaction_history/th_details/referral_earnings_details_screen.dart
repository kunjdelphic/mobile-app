import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/referral_earnings_filter_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class ReferralEarningsDetailsScreen extends StatefulWidget {
  TransactionHistoryData transactionHistoryData;

  ReferralEarningsDetailsScreen({
    Key? key,
    required this.transactionHistoryData,
  }) : super(key: key);

  @override
  _ReferralEarningsDetailsScreenState createState() =>
      _ReferralEarningsDetailsScreenState();
}

class _ReferralEarningsDetailsScreenState
    extends State<ReferralEarningsDetailsScreen> {
  List openedLevels = [];

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
              // var res = await Get.to(() => const ReferralEarningsFilterScreen(
              //       filterMap: {}, earningHistoryData: ,
              //     ));
              // if (res != null) {
              //   // filterMap = res;
              //   // // getAllMyLevelReferralUsers(map: res);
              //   // _future = getAllMyLevelReferralUsers(map: res);
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
      body: ListView(
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                    color: Color(0xffF6F6F6),
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
                            '08.10.2021 | 10:00 PM',
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
                            '+ RM 30.00',
                            style: kPrimaryDarkExtraLargeStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Referrals: 4',
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
              color: Color(0xffF6F6F6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    'Level 1 - ',
                    style: kBlueMediumStyle,
                  ),
                  Text(
                    'RM 0.20',
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
                    ListView.separated(
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
                                    child:
                                        // snapshot.data!.data![index].profileImage !=
                                        //         null
                                        //     ? Image.network(
                                        //         snapshot.data!.data![index]
                                        //             .profileImage!,
                                        //         width: Get.width * 0.065,
                                        //       )
                                        //     :
                                        Image.asset(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: kBlackMediumStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                                          'RM 0.10',
                                          style: kPrimaryDarkExtraLargeStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                      itemCount: 3,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
              color: Color(0xffF6F6F6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    'Level 2 - ',
                    style: kBlueMediumStyle,
                  ),
                  Text(
                    'RM 0.20',
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
                    ListView.separated(
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
                                    child:
                                        // snapshot.data!.data![index].profileImage !=
                                        //         null
                                        //     ? Image.network(
                                        //         snapshot.data!.data![index]
                                        //             .profileImage!,
                                        //         width: Get.width * 0.065,
                                        //       )
                                        //     :
                                        Image.asset(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: kBlackMediumStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                                          'RM 0.10',
                                          style: kPrimaryDarkExtraLargeStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                      itemCount: 3,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
              color: Color(0xffF6F6F6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    'Level 3 - ',
                    style: kBlueMediumStyle,
                  ),
                  Text(
                    'RM 0.20',
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
                    ListView.separated(
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
                                    child:
                                        // snapshot.data!.data![index].profileImage !=
                                        //         null
                                        //     ? Image.network(
                                        //         snapshot.data!.data![index]
                                        //             .profileImage!,
                                        //         width: Get.width * 0.065,
                                        //       )
                                        //     :
                                        Image.asset(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: kBlackMediumStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                                          'RM 0.10',
                                          style: kPrimaryDarkExtraLargeStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                      itemCount: 3,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
              color: Color(0xffF6F6F6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    'Level 4 - ',
                    style: kBlueMediumStyle,
                  ),
                  Text(
                    'RM 0.20',
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
                    ListView.separated(
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
                                    child:
                                        // snapshot.data!.data![index].profileImage !=
                                        //         null
                                        //     ? Image.network(
                                        //         snapshot.data!.data![index]
                                        //             .profileImage!,
                                        //         width: Get.width * 0.065,
                                        //       )
                                        //     :
                                        Image.asset(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: kBlackMediumStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                                          'RM 0.10',
                                          style: kPrimaryDarkExtraLargeStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                      itemCount: 3,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
              color: Color(0xffF6F6F6),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Text(
                    'Level 5 - ',
                    style: kBlueMediumStyle,
                  ),
                  Text(
                    'RM 0.20',
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
                    ListView.separated(
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
                                    child:
                                        // snapshot.data!.data![index].profileImage !=
                                        //         null
                                        //     ? Image.network(
                                        //         snapshot.data!.data![index]
                                        //             .profileImage!,
                                        //         width: Get.width * 0.065,
                                        //       )
                                        //     :
                                        Image.asset(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: kBlackMediumStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                                          'RM 0.10',
                                          style: kPrimaryDarkExtraLargeStyle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '14:01:10',
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
                      itemCount: 3,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
