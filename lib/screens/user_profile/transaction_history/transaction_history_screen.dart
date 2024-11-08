import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/wallet/transaction_history_item.dart';

import 'transaction_history_filter_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String search = '';
  TextEditingController searchController = TextEditingController();

  WalletController walletController = Get.find();
  Future<TransactionHistory>? _futureProducts;
  final sc = ScrollController();
  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // if (widget.toLoad) {
    //  walletController. pageNumberForTransactionHistory(0);
    //   walletController.getTransactionHistory({});
    // }
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        log('reached');

        // walletController.pageNumber.value++;
        walletController.pageNumberForTransactionHistory.value++;
        walletController.getTransactionHistory({});

        log(walletController.pageNumberForTransactionHistory.value.toString());
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      timer = Timer.periodic(const Duration(seconds: 2), (t) {
        log('timer fn called.......');
        walletController.getTransactionHistory(
          {},
          refreshing: true,
        );
        t.cancel();
      });
    });
  }

  Future<TransactionHistory> getFilteredCategories() async {
    TransactionHistory billPaymentProducts = TransactionHistory(
      data: [],
      message: walletController.transactionHistory.value.message,
      status: walletController.transactionHistory.value.status,
    );
    if (searchController.text.trim().isEmpty) {
      return walletController.transactionHistory.value;
    }

    for (var item in walletController.transactionHistory.value.data!) {
      if (item.transType!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase()) ||
          item.others!.productName!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase())) {
        //add
        billPaymentProducts.data!.add(item);
      }
    }

    return billPaymentProducts;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        walletController.pageNumberForTransactionHistory(0);
        timer!.cancel();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Transaction History",
            style: kBlackLargeStyle,
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                var res = await Get.to(() => const TransactionHistoryFilterScreen(
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
        body:
            // GetX<WalletController>(
            //   init: walletController,
            //   builder: (controller) {
            // print(controller.transactionHistory.value.status);
            // print(controller.transactionHistory.value.data);

            // if (controller.isFetchingTransactionHistory.value) {
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
            // if (controller.transactionHistory.value.data == null) {
            //   return Center(
            //     child: SizedBox(
            //       height: 35,
            //       child: Text(
            //         controller.transactionHistory.value.message!,
            //         style: kBlackSmallMediumStyle,
            //       ),
            //     ),
            //   );
            // }

            Column(
          children: [
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                  log('called');
                  walletController.getTransactionHistory(
                    {},
                    refreshing: true,
                  );

                  return;
                },
                child: GetX<WalletController>(
                  init: walletController,
                  builder: (controller) {
                    print(controller.isFetchingTransactionHistory.value.toString());
                    // print(controller.transactionHistory.value.data);

                    // if (controller.isFetchingTransactionHistory.value) {
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
                    // if (controller.transactionHistory.value.data == null) {
                    //   return Center(
                    //     child: SizedBox(
                    //       height: 35,
                    //       child: Text(
                    //         controller.transactionHistory.value.message!,
                    //         style: kBlackSmallMediumStyle,
                    //       ),
                    //     ),
                    //   );
                    // }

                    _futureProducts ??= getFilteredCategories();
                    return FutureBuilder<TransactionHistory?>(
                      future: _futureProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
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
                          shrinkWrap: true,
                          controller: sc,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          itemBuilder: (context, index) {
                            if (index == snapshot.data!.data!.length) {
                              log(walletController.isFetchingTransactionHistory.toString());
                              return Opacity(
                                opacity: walletController.isFetchingTransactionHistory.value ? 1 : 0,
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
                                  TransactionHistoryItem(
                                    transactionHistoryData: snapshot.data!.data![index],
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
                  },
                ),
              ),
            ),

            // const SizedBox(
            //   height: 25,
            // ),
          ],
        ),
      ),
    );
  }
}
