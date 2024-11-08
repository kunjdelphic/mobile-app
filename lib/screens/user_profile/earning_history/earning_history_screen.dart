import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/screens/user_profile/earning_history/earning_history_filter_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/wallet/earning_history_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/common_tools.dart';
import '../../../models/wallet/transaction_history.dart';
import '../../../widgets/buttons/gradient_button.dart';
import '../../../widgets/dialogs/common_dialogs.dart';
import '../../../widgets/dialogs/snackbars.dart';
import '../../../widgets/shimmer/earninghistoryShimmer.dart';
import 'package:gallery_saver/gallery_saver.dart';

class EarningHistoryScreen extends StatefulWidget {
  const EarningHistoryScreen({Key? key}) : super(key: key);

  @override
  _EarningHistoryScreenState createState() => _EarningHistoryScreenState();
}

class _EarningHistoryScreenState extends State<EarningHistoryScreen> {
  String search = '';
  TextEditingController searchController = TextEditingController();
  WalletController walletController = Get.find();

  List<EarningHistory> earningHistoryList = [];
  bool isFilter = false;
  Future<EarningHistory>? _futureProducts;
  // Timer? timer;

  // @override
  // void dispose() {
  //   timer!.cancel();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    // walletController.getEarningHistory();

    // if (walletController.earningHistory.value.data == null) {
    //   walletController.getEarningHistory();
    // }
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        log('reached');
        walletController.pageNumberForEarningHistory.value++;
        // walletController.pageNumber.value++;

        walletController.getEarningHistory();

        log(walletController.pageNumberForEarningHistory.value.toString());
      }
    });
    // Future.delayed(const Duration(seconds: 2), () {
    //   timer = Timer.periodic(const Duration(seconds: 2), (t) {
    //     log('timer fn called.......');
    //     walletController.getEarningHistory(refreshing: true);
    //     walletController.getEarningWallet({});
    //     t.cancel();
    //   });
    // });
  }

  Future<List<EarningHistory>> getEarningHistoryList(Map filterMap) async {
    if (filterMap.isEmpty) {
      setState(() {
        isFilter = false;
      });
      return [];
    }

    return earningHistoryList;
  }

  Future<EarningHistory> getFilteredCategories() async {
    EarningHistory billPaymentProducts = EarningHistory(
      data: [],
      message: walletController.earningHistory.value.message,
      status: walletController.earningHistory.value.status,
    );
    if (searchController.text.trim().isEmpty) {
      return walletController.earningHistory.value;
    }

    for (var item in walletController.earningHistory.value.data!) {
      if (item.transType!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase()) ||
          item.others!.productName!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase())) {
        //add
        billPaymentProducts.data!.add(item);
      }
    }

    return billPaymentProducts;
  }

  final sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Earning History",
          style: kBlackLargeStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              var res = await Get.to(() => const EarningHistoryFilterScreen(
                    filterMap: {},
                  ));
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
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
              color: kWhite,
              // color: kWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Search is required';
                  }

                  return null;
                },
                onSaved: (val) {
                  search = val!.trim();
                },
                onChanged: (value) {
                  if (walletController.transactionHistory.value.data != null) {
                    setState(() {
                      search = value.trim();
                    });
                    _futureProducts = getFilteredCategories();
                  }
                },
                controller: searchController,
                enableInteractiveSelection: true,
                style: kBlackMediumStyle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  helperStyle: kBlackSmallLightMediumStyle,
                  errorStyle: kBlackSmallLightMediumStyle,
                  hintStyle: kBlackSmallLightMediumStyle,
                  hintText: 'Search',
                  labelStyle: kBlackSmallLightMediumStyle,
                  fillColor: Colors.black.withOpacity(0.03),
                  filled: true,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  suffixIcon: search.isNotEmpty
                      ? GestureDetector(
                          onTap: () => setState(() {
                            search = '';
                            searchController.text = '';
                            setState(() {
                              _futureProducts = getFilteredCategories();
                            });
                          }),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black38,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 0,
          // ),
          SizedBox(height: 10),
          const Divider(
            // thickness: 0.30,
            height: 1,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                walletController.getEarningHistory(refreshing: true);
                walletController.getEarningWallet({});

                return;
              },
              child: GetX<WalletController>(
                init: walletController,
                builder: (controller) {
                  // print(controller.earningHistory.value.status);
                  print("Chekingssssssssssss  ${controller.isFetchingEarningHistory.value.toString()}");

                  // if (controller.earningHistory.value.data == null) {
                  //   return Center(
                  //     child: SizedBox(
                  //       height: 35,
                  //       child: Text(
                  //         controller.earningHistory.value.message!,
                  //         style: kBlackSmallMediumStyle,
                  //       ),
                  //     ),
                  //   );
                  // }

                  _futureProducts ??= getFilteredCategories();
                  return FutureBuilder<EarningHistory?>(
                    future: _futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // return const Center(
                        //   child: Padding(
                        //     padding: EdgeInsets.only(top: 30),
                        //     child: SizedBox(
                        //       height: 25,
                        //       child: LoadingIndicator(
                        //         indicatorType: Indicator.lineScalePulseOut,
                        //         colors: [
                        //           kAccentColor,
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                        return ListView(
                          children: [earningHistoryItemShimmer(), earningHistoryItemShimmer()],
                        );
                      }
                      if (snapshot.data == null) {
                        return const SizedBox();
                      }
                      if (snapshot.data!.data!.isEmpty) {
                        return SizedBox(
                          height: 55,
                          child: Center(
                            child: Text(
                              'No transaction history found!',
                              style: kBlackSmallMediumStyle,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        controller: sc,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.data!.length) {
                            return Opacity(
                              opacity: walletController.isFetchingEarningHistory.value ? 1 : 0,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return Column(
                              children: [
                                index == 0
                                    ? SizedBox(
                                        height: 5,
                                      )
                                    : SizedBox(),
                                EarningHistoryItem(
                                  earningHistoryData: snapshot.data!.data![index],
                                ),
                              ],
                            );
                          }
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                        itemCount: snapshot.data!.data!.length + 1,
                      );
                    },
                  );

                  // return ListView.separated(
                  //   shrinkWrap: true,
                  //   controller: sc,
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  //   itemBuilder: (context, index) {
                  //     if (index ==
                  //         controller.earningHistory.value.data!.length) {
                  //       return Opacity(
                  //         opacity:
                  //             walletController.isFetchingEarningHistory.value
                  //                 ? 1
                  //                 : 0,
                  //         child: const Center(
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //       );
                  //     } else {
                  //       return EarningHistoryItem(
                  //         earningHistoryData:
                  //             controller.earningHistory.value.data![index],
                  //       );
                  //     }
                  //   },
                  //   separatorBuilder: (context, index) => const SizedBox(
                  //     height: 15,
                  //   ),
                  //   itemCount: controller.earningHistory.value.data!.length + 1,
                  // );
                },
              ),
            ),
          ),
          // Expanded(
          //   child: ListView(
          //     shrinkWrap: true,
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           Get.to(() => const ReferralEarningsDetailsScreen());
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.2),
          //                 blurRadius: 6,
          //                 spreadRadius: 2,
          //               ),
          //             ],
          //             color: kWhite,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 15, vertical: 12),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 28,
          //                 height: 28,
          //                 padding: const EdgeInsets.all(6),
          //                 decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.1),
          //                       blurRadius: 5,
          //                       spreadRadius: 1,
          //                     ),
          //                   ],
          //                   color: Color(0xffF6F6F6),
          //                   // color: kWhite,
          //                   borderRadius: BorderRadius.circular(100),
          //                 ),
          //                 child: Image.asset(
          //                   'assets/icons/earning_history/ic_referral_earning.png',
          //                   // width: 18,
          //                   // height: 18,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           '08.10.2021 | 10:00 PM',
          //                           style: kBlackExtraSmallLightMediumStyle,
          //                         ),
          //                         const SizedBox(
          //                           width: 10,
          //                         ),
          //                         Row(
          //                           children: [
          //                             Image.asset(
          //                               'assets/icons/earning_history/ic_blue_wallet.png',
          //                               width: 13,
          //                               height: 13,
          //                             ),
          //                             const SizedBox(
          //                               width: 5,
          //                             ),
          //                             Text(
          //                               'RM 25.00',
          //                               style: kBlackDarkMediumStyle,
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                     const Divider(thickness: 0.30),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           'Referral Earnings',
          //                           style: kBlackMediumStyle,
          //                         ),
          //                         Text(
          //                           '+ RM 30.00',
          //                           style: kPrimaryDarkExtraLargeStyle,
          //                         ),
          //                       ],
          //                     ),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           'Total Referrals: 4',
          //                           style: kBlackExtraSmallLightMediumStyle,
          //                         ),
          //                         // SvgPicture.asset(
          //                         //   'assets/images/logo/logo_full.svg',
          //                         //   color: kColorPrimary,
          //                         //   width: Get.width * 0.1,
          //                         //   height: 20,
          //                         // )
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           Get.to(() => const CashbackDetailsScreen());
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.2),
          //                 blurRadius: 6,
          //                 spreadRadius: 2,
          //               ),
          //             ],
          //             color: kWhite,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 15, vertical: 12),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 28,
          //                 height: 28,
          //                 padding: const EdgeInsets.all(6),
          //                 decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.1),
          //                       blurRadius: 5,
          //                       spreadRadius: 1,
          //                     ),
          //                   ],
          //                   color: Color(0xffF6F6F6),
          //                   // color: kWhite,
          //                   borderRadius: BorderRadius.circular(100),
          //                 ),
          //                 child: Image.asset(
          //                   'assets/icons/earning_history/ic_cashback.png',
          //                   // width: 18,
          //                   // height: 18,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           '08.10.2021 | 10:00 PM',
          //                           style: kBlackExtraSmallLightMediumStyle,
          //                         ),
          //                         const SizedBox(
          //                           width: 10,
          //                         ),
          //                         Row(
          //                           children: [
          //                             Image.asset(
          //                               'assets/icons/earning_history/ic_blue_wallet.png',
          //                               width: 13,
          //                               height: 13,
          //                             ),
          //                             const SizedBox(
          //                               width: 5,
          //                             ),
          //                             Text(
          //                               'RM 25.00',
          //                               style: kBlackDarkMediumStyle,
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                     const Divider(thickness: 0.30),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           'Cashback',
          //                           style: kBlackMediumStyle,
          //                         ),
          //                         Text(
          //                           '+ RM 30.00',
          //                           style: kPrimaryDarkExtraLargeStyle,
          //                         ),
          //                       ],
          //                     ),
          //                     Text(
          //                       'Celcom Postpaid',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                     Text(
          //                       '0123456789',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           Get.to(() => const TransactionFeesDetailsScreen());
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.2),
          //                 blurRadius: 6,
          //                 spreadRadius: 2,
          //               ),
          //             ],
          //             color: kWhite,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 15, vertical: 12),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 28,
          //                 height: 28,
          //                 padding: const EdgeInsets.all(7),
          //                 decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.1),
          //                       blurRadius: 5,
          //                       spreadRadius: 1,
          //                     ),
          //                   ],
          //                   color: Color(0xffF6F6F6),
          //                   // color: kWhite,
          //                   borderRadius: BorderRadius.circular(100),
          //                 ),
          //                 child: Image.asset(
          //                   'assets/icons/earning_history/ic_txnfee.png',
          //                   // width: 18,
          //                   // height: 18,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           '08.10.2021 | 10:00 PM',
          //                           style: kBlackExtraSmallLightMediumStyle,
          //                         ),
          //                         const SizedBox(
          //                           width: 10,
          //                         ),
          //                         Row(
          //                           children: [
          //                             Image.asset(
          //                               'assets/icons/earning_history/ic_blue_wallet.png',
          //                               width: 13,
          //                               height: 13,
          //                             ),
          //                             const SizedBox(
          //                               width: 5,
          //                             ),
          //                             Text(
          //                               'RM 25.00',
          //                               style: kBlackDarkMediumStyle,
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                     const Divider(thickness: 0.30),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           'Transaction Fee',
          //                           style: kBlackMediumStyle,
          //                         ),
          //                         Text(
          //                           '- RM 30.00',
          //                           style: kPrimaryDarkExtraLargeStyle,
          //                         ),
          //                       ],
          //                     ),
          //                     Text(
          //                       'Main Wallet Reload',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           Get.to(() => const ReceivedMoneyDetailsScreen());
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.2),
          //                 blurRadius: 6,
          //                 spreadRadius: 2,
          //               ),
          //             ],
          //             color: kWhite,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 15, vertical: 12),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 28,
          //                 height: 28,
          //                 padding: const EdgeInsets.all(4),
          //                 decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.1),
          //                       blurRadius: 5,
          //                       spreadRadius: 1,
          //                     ),
          //                   ],
          //                   color: Color(0xffF6F6F6),
          //                   // color: kWhite,
          //                   borderRadius: BorderRadius.circular(100),
          //                 ),
          //                 child: Image.asset(
          //                   'assets/icons/earning_history/ic_received_money.png',
          //                   // width: 18,
          //                   // height: 18,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           '08.10.2021 | 10:00 PM',
          //                           style: kBlackExtraSmallLightMediumStyle,
          //                         ),
          //                         const SizedBox(
          //                           width: 10,
          //                         ),
          //                         Row(
          //                           children: [
          //                             Image.asset(
          //                               'assets/icons/earning_history/ic_blue_wallet.png',
          //                               width: 13,
          //                               height: 13,
          //                             ),
          //                             const SizedBox(
          //                               width: 5,
          //                             ),
          //                             Text(
          //                               'RM 25.00',
          //                               style: kBlackDarkMediumStyle,
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                     const Divider(thickness: 0.30),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           'Received Money',
          //                           style: kBlackMediumStyle,
          //                         ),
          //                         Text(
          //                           '+ RM 30.00',
          //                           style: kPrimaryDarkExtraLargeStyle,
          //                         ),
          //                       ],
          //                     ),
          //                     Text(
          //                       'John Doe',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                     Text(
          //                       '0123456789',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 15,
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           Get.to(() => const EarningsToMainWalletDetailsScreen());
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withOpacity(0.2),
          //                 blurRadius: 6,
          //                 spreadRadius: 2,
          //               ),
          //             ],
          //             color: kWhite,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 15, vertical: 12),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 28,
          //                 height: 28,
          //                 padding: const EdgeInsets.all(7),
          //                 decoration: BoxDecoration(
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.1),
          //                       blurRadius: 5,
          //                       spreadRadius: 1,
          //                     ),
          //                   ],
          //                   color: Color(0xffF6F6F6),
          //                   // color: kWhite,
          //                   borderRadius: BorderRadius.circular(100),
          //                 ),
          //                 child: Image.asset(
          //                   'assets/icons/earning_history/ic_txnfee.png',
          //                   // width: 18,
          //                   // height: 18,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Text(
          //                           '08.10.2021 | 10:00 PM',
          //                           style: kBlackExtraSmallLightMediumStyle,
          //                         ),
          //                         const SizedBox(
          //                           width: 10,
          //                         ),
          //                         Text(
          //                           'Successful',
          //                           style: kPrimaryExtraSmallMediumStyle,
          //                         ),
          //                         Spacer(),
          //                         Row(
          //                           children: [
          //                             Image.asset(
          //                               'assets/icons/earning_history/ic_blue_wallet.png',
          //                               width: 13,
          //                               height: 13,
          //                             ),
          //                             const SizedBox(
          //                               width: 5,
          //                             ),
          //                             Text(
          //                               'RM 25.00',
          //                               style: kBlackDarkMediumStyle,
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                     const Divider(thickness: 0.30),
          //                     Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         Text(
          //                           'Earning To Main Wallet',
          //                           style: kBlackMediumStyle,
          //                         ),
          //                         Text(
          //                           '- RM 30.00',
          //                           style: kPrimaryDarkExtraLargeStyle,
          //                         ),
          //                       ],
          //                     ),
          //                     Text(
          //                       'Wallet Transfer: RM 20.00',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                     Text(
          //                       'Transaction Charge: RM 1.00',
          //                       style: kBlackExtraSmallLightMediumStyle,
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
