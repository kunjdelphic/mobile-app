import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/favorite/all_favorites.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/styled_text.dart';

import '../../../models/wallet/product_transaction_history.dart';

class ProductTransactionHistoryScreen extends StatefulWidget {
  final AllFavoritesData allFavoritesData;
  const ProductTransactionHistoryScreen({Key? key, required this.allFavoritesData}) : super(key: key);

  @override
  _ProductTransactionHistoryScreenState createState() => _ProductTransactionHistoryScreenState();
}

class _ProductTransactionHistoryScreenState extends State<ProductTransactionHistoryScreen> {
  String search = '';
  TextEditingController searchController = TextEditingController();
  WalletController walletController = Get.find();
  int n = 0;
  final sc = ScrollController();
  bool isLoadingTransactions = true;
  @override
  void initState() {
    super.initState();
    getAllProductTransactionHistory();

    print(widget.allFavoritesData.favoriteId);
    print(widget.allFavoritesData.type);
    print(widget.allFavoritesData.productId);
    print(widget.allFavoritesData.accountNumber);
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        log('reached');
        n++;
        if (mounted) {
          setState(() {
            getAllProductTransactionHistory();
          });
        }
      }
    });
    // if (walletController.transactionHistory.value.data == null) {
    //   walletController.getTransactionHistory({});
    // }
  }

  List<ProductTransactionHistoryTransactions>? transactions = [];

  getAllProductTransactionHistory() async {
    ProductTransactionHistory? productTransactionHistory;

    productTransactionHistory = await walletController.getProductTransactionHistory(
        {"transaction_type": widget.allFavoritesData.type, "filter": "ALL", "product_id": widget.allFavoritesData.productId, "account_number": widget.allFavoritesData.accountNumber, 'page_no': n});

    transactions!.addAll(productTransactionHistory.transactions!.toList());
    if (mounted) {
      setState(() {
        isLoadingTransactions = false;
      });
    }
  }

  String buildProcessingText() {
    return '<widget>';
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
          "Bill Transaction History",
          style: kBlackLargeStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // var res = await Get.to(() => const TransactionHistoryFilterScreen(
              //       filterMap: {},
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            width: Get.width,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
              color: kWhite,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              '${widget.allFavoritesData.productImage}',
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'assets/images/logo/parrot_logo.png',
                                fit: BoxFit.contain,
                                width: 50,
                                height: 50,
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
                                    widget.allFavoritesData.nickName ?? 'NA',
                                    style: kBlackMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    '${widget.allFavoritesData.productName}',
                                    style: kBlackExtraSmallMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    widget.allFavoritesData.accountNumber ?? 'NA',
                                    style: kBlackExtraSmallMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 0.30),
                        // FutureBuilder<ProductTransactionHistory>(
                        //   future: getAllProductTransactionHistory(n),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //             ConnectionState.waiting ||
                        //         !snapshot.hasData) {
                        //       return Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Text(
                        //             'Total Successful Payment: ',
                        //             style: kBlackExtraSmallMediumStyle,
                        //           ),
                        //           Text(
                        //             'RM --',
                        //             style: kPrimary2DarkExtraLargeStyle,
                        //           ),
                        //         ],
                        //       );
                        //     } else if (snapshot.data!.transactions!.isEmpty) {
                        //       return Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Text(
                        //             'Total Successful Payment: ',
                        //             style: kBlackExtraSmallMediumStyle,
                        //           ),
                        //           Text(
                        //             'RM --',
                        //             style: kPrimary2DarkExtraLargeStyle,
                        //           ),
                        //         ],
                        //       );
                        //     }
                        //     return Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Text(
                        //           'Total Successful Payment: ',
                        //           style: kBlackExtraSmallMediumStyle,
                        //         ),
                        //         Text(
                        //           'RM ${snapshot.data?.totalSuccessfullPayment}',
                        //           style: kPrimary2DarkExtraLargeStyle,
                        //         ),
                        //       ],
                        //     );
                        //   },
                        // ),

                        // widget.allFavoritesData.hasOutstandingAmount!
                        //     ? FutureBuilder<OutstandingBill?>(
                        //         future: _futureOutstandingBill,
                        //         builder: (context, snapshot) {
                        //           if (snapshot.connectionState ==
                        //               ConnectionState.waiting) {
                        //             return Row(
                        //               mainAxisAlignment: MainAxisAlignment.end,
                        //               children: [
                        //                 Text(
                        //                   'Due: ',
                        //                   style: kBlackSmallLightMediumStyle,
                        //                 ),
                        //                 Container(
                        //                   height: 24,
                        //                   width: 40,
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 8, vertical: 6),
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(5),
                        //                       color: kRedBtnColor1),
                        //                   child: const LoadingIndicator(
                        //                     indicatorType:
                        //                         Indicator.lineScalePulseOut,
                        //                     colors: [
                        //                       kWhite,
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ],
                        //             );
                        //           }
                        //           if (snapshot.data == null) {
                        //             return const SizedBox();
                        //           }
                        //           if (snapshot.data!.status != 200) {
                        //             return Row(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               children: [
                        //                 Expanded(
                        //                   child: Text(
                        //                     'Due amount currently unavailable.',
                        //                     style:
                        //                         kBlackExtraSmallLightMediumStyle,
                        //                   ),
                        //                 ),
                        //                 Container(
                        //                   height: 24,

                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 0, vertical: 3),
                        //                   // decoration: BoxDecoration(
                        //                   //     borderRadius: BorderRadius.circular(5),
                        //                   //     color: kRedBtnColor1),
                        //                   child: Text(
                        //                     '',
                        //                     style: kWhiteSmallMediumStyle,
                        //                   ),
                        //                 ),
                        //               ],
                        //             );
                        //           }

                        //           if (snapshot.data!.bill == null) {
                        //             return Row(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               children: [
                        //                 Expanded(
                        //                   child: Text(
                        //                     'Due amount currently unavailable.',
                        //                     style:
                        //                         kBlackExtraSmallLightMediumStyle,
                        //                   ),
                        //                 ),
                        //                 Container(
                        //                   height: 24,
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 0, vertical: 3),
                        //                   // decoration: BoxDecoration(
                        //                   //     borderRadius: BorderRadius.circular(5),
                        //                   //     color: kRedBtnColor1),
                        //                   child: Text(
                        //                     '',
                        //                     style: kWhiteSmallMediumStyle,
                        //                   ),
                        //                 ),
                        //               ],
                        //             );
                        //           }

                        //           if (snapshot.data!.bill != null &&
                        //               outstandingBill != null) {
                        //             // if (!snapshot.data!.bill!.outstandingAmount!
                        //             //     .contains('-')) {
                        //             //   //skip
                        //             //   return Row(
                        //             //     mainAxisAlignment:
                        //             //         MainAxisAlignment.start,
                        //             //     children: [
                        //             //       Expanded(
                        //             //         child: Text(
                        //             //           'Due amount viewing option not available for this bill.',
                        //             //           style:
                        //             //               kBlackExtraSmallLightMediumStyle,
                        //             //         ),
                        //             //       ),
                        //             //       Container(
                        //             //         height: 24,
                        //             //         padding: const EdgeInsets.symmetric(
                        //             //             horizontal: 0, vertical: 3),
                        //             //         // decoration: BoxDecoration(
                        //             //         //     borderRadius: BorderRadius.circular(5),
                        //             //         //     color: kRedBtnColor1),
                        //             //         child: Text(
                        //             //           '',
                        //             //           style: kWhiteSmallMediumStyle,
                        //             //         ),
                        //             //       ),
                        //             //     ],
                        //             //   );
                        //             // } else {
                        //             return Row(
                        //               mainAxisAlignment: MainAxisAlignment.end,
                        //               children: [
                        //                 Text(
                        //                   'Due: ',
                        //                   style: kBlackSmallLightMediumStyle,
                        //                 ),
                        //                 Container(
                        //                   height: 24,
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 5, vertical: 3),
                        //                   decoration: BoxDecoration(
                        //                       borderRadius:
                        //                           BorderRadius.circular(5),
                        //                       color: kRedBtnColor1),
                        //                   child: Text(
                        //                     'RM ${snapshot.data!.bill!.outstandingAmount}',
                        //                     style: kWhiteSmallMediumStyle,
                        //                   ),
                        //                 ),
                        //               ],
                        //             );
                        //             // }
                        //           }
                        //           return Row(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             children: [
                        //               Expanded(
                        //                 child: Text(
                        //                   'Due amount currently unavailable.',
                        //                   style: kBlackExtraSmallLightMediumStyle,
                        //                 ),
                        //               ),
                        //               Container(
                        //                 height: 24,
                        //                 padding: const EdgeInsets.symmetric(
                        //                     horizontal: 0, vertical: 3),
                        //                 // decoration: BoxDecoration(
                        //                 //     borderRadius: BorderRadius.circular(5),
                        //                 //     color: kRedBtnColor1),
                        //                 child: Text(
                        //                   '',
                        //                   style: kWhiteSmallMediumStyle,
                        //                 ),
                        //               ),
                        //             ],
                        //           );
                        //         },
                        //       )
                        //     : Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           StyledText(
                        //             text: widget.allFavoritesData
                        //                         .lastTransactionStatus ==
                        //                     'SUCCESS'
                        //                 ? 'Payment <success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                        //                 : 'Payment <fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                        //             textAlign: TextAlign.center,
                        //             style: kBlackExtraSmallLightMediumStyle,
                        //             tags: {
                        //               'success': StyledTextActionTag(
                        //                 (_, attrs) {},
                        //                 style: kPrimaryExtraSmallDarkMediumStyle,
                        //               ),
                        //               'fail': StyledTextActionTag(
                        //                 (_, attrs) {},
                        //                 style: kRedExtraSmallDarkMediumStyle,
                        //               ),
                        //             },
                        //           ),
                        //         ],
                        //       ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    // color: Color(0xffF2F1F6),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.black26,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: isLoadingTransactions
                  ? const Center(
                      child: SizedBox(
                        height: 25,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineScalePulseOut,
                          colors: [
                            kAccentColor,
                          ],
                        ),
                      ),
                    )
                  : transactions!.isEmpty
                      ? Center(
                          child: Text(
                            'No History Found!',
                            style: kBlackMediumStyle,
                          ),
                        )
                      : ListView.separated(
                          controller: sc,
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          itemCount: transactions!.length + 1,
                          itemBuilder: (context, index) {
                            if (transactions!.length == index) {
                              return Opacity(
                                opacity: isLoadingTransactions ? 1 : 0,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                width: Get.width,
                                child: Stack(
                                  // fit: StackFit.expand,
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 30,
                                        bottom: 10,
                                        right: 10,
                                        top: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              transactions![index].status == 'PENDING'
                                                  ? Container(
                                                      width: 60,
                                                      child: Shimmer.fromColors(
                                                        baseColor: Colors.yellow.shade500,
                                                        highlightColor: Colors.yellow.shade50,
                                                        child: Text(
                                                          "Processing",
                                                          style: kYellowExtraSmallDarkMediumStyle,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              Expanded(
                                                child: StyledText(
                                                  text: transactions![index].status == 'SUCCESS'
                                                      ? 'Payment <success>Successful</success>'
                                                      : transactions![index].status == 'FAILED'
                                                          ? 'Payment <fail>Failed</fail>'
                                                          : 'Payment <processing>${buildProcessingText()}</processing>',
                                                  textAlign: TextAlign.start,
                                                  style: kBlackMediumStyle,
                                                  tags: {
                                                    'success': StyledTextActionTag(
                                                      (_, attrs) {},
                                                      style: kPrimaryDarkMediumStyle,
                                                    ),
                                                    'fail': StyledTextActionTag(
                                                      (_, attrs) {},
                                                      style: kRedDarkMediumStyle,
                                                    ),
                                                    'processing': StyledTextActionTag(
                                                      (_, attrs) {},
                                                      style: kYellowDarkMediumStyle,
                                                    ),
                                                  },
                                                ),
                                              ),
                                              Text(
                                                '${transactions![index].currency} ${transactions![index].amount}',
                                                style: transactions![index].status == 'SUCCESS'
                                                    ? kBlackDarkMediumStyle
                                                    : transactions![index].status == 'FAILED'
                                                        ? kRedDarkMediumStyle
                                                        : kYellowDarkMediumStyle,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${CommonTools().getDateAndTime(transactions![index].timestamp!)}',
                                                  style: kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 13,
                                                    height: 13,
                                                    padding: const EdgeInsets.all(2),
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
                                                      'assets/icons/earning_history/ic_cashback.png',
                                                      // width: 18,
                                                      // height: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${transactions![index].cashback}',
                                                    style: transactions![index].status == 'SUCCESS'
                                                        ? kBlackSmallDarkMediumStyle
                                                        : transactions![index].status == 'FAILED'
                                                            ? kRedSmallDarkMediumStyle
                                                            : kYellowSmallDarkMediumStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${transactions![index].paymentType.toString().capitalizeFirst} Payment',
                                                  style: kBlackSmallLightMediumStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 6,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          transactions![index].status == 'SUCCESS'
                                              ? 'assets/icons/transaction_history/ic_success.png'
                                              : transactions![index].status == 'FAILED'
                                                  ? 'assets/icons/transaction_history/ic_failed.png'
                                                  : 'assets/icons/transaction_history/ic_processing.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 0,
                            );
                          },
                        )),
        ],
      ),
    );
  }
}
