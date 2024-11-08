import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class TransactionHistoryFilterScreen extends StatefulWidget {
  final Map? filterMap;
  const TransactionHistoryFilterScreen({
    Key? key,
    required this.filterMap,
  }) : super(key: key);

  @override
  _TransactionHistoryFilterScreenState createState() =>
      _TransactionHistoryFilterScreenState();
}

class _TransactionHistoryFilterScreenState
    extends State<TransactionHistoryFilterScreen> {
  // ReferralController referralController = Get.find();
  WalletController walletController = Get.find();

  TextEditingController searchController = TextEditingController();

  bool isSearchByDate = false;
  bool isSelectedAllTransactions = false;
  List selectedProducts = [];
  late DateTime fromDate, endDate;

  @override
  void initState() {
    super.initState();

    // print('${widget.filterMap}');

    if (walletController.transactionHistoryFilter.value.products == null) {
      walletController.getTransactionHistoryFilterProducts({});
    }

    if (widget.filterMap != null) {
      if (widget.filterMap!['fromDate'] != null) {
        isSearchByDate = true;
      }
      fromDate = widget.filterMap!['fromDate'] != null
          ? DateTime.parse(widget.filterMap!['fromDate'])
          : DateTime.now().subtract(const Duration(days: 15));
      endDate = widget.filterMap!['endDate'] != null
          ? DateTime.parse(widget.filterMap!['endDate'])
          : DateTime.now();
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
          "Filter",
          style: kBlackLargeStyle,
        ),
        actions: [
          Padding(
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
                    'assets/icons/ic_filter_active.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GetX<WalletController>(
        init: walletController,
        builder: (controller) {
          print(controller.transactionHistoryFilter.value.status);
          print(controller.transactionHistoryFilter.value.products);

          if (controller.isFetchingTransactionHistoryFilterProducts.value) {
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
          if (controller.transactionHistoryFilter.value.products == null) {
            return Center(
              child: SizedBox(
                height: 35,
                child: Text(
                  controller.transactionHistoryFilter.value.message!,
                  style: kBlackSmallMediumStyle,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Text(
                'Choose From The Products Below:',
                style: kBlackMediumStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedProducts.contains(controller
                            .transactionHistoryFilter.value.products![index])) {
                          selectedProducts.remove(controller
                              .transactionHistoryFilter.value.products![index]);
                        } else {
                          selectedProducts.add(controller
                              .transactionHistoryFilter.value.products![index]);
                        }
                      });
                    },
                    child: Container(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo/parrotpos_logo.png',
                            width: 50,
                            height: 22,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.transactionHistoryFilter.value
                                      .products![index],
                                  style: kBlackMediumStyle,
                                ),
                                selectedProducts.contains(controller
                                        .transactionHistoryFilter
                                        .value
                                        .products![index])
                                    ? Image.asset(
                                        'assets/icons/earning_history/checkbox.png',
                                        width: 22,
                                        height: 22,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
                itemCount:
                    controller.transactionHistoryFilter.value.products!.length,
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelectedAllTransactions = !isSelectedAllTransactions;
                    if (isSelectedAllTransactions) {
                      selectedProducts.addAll(controller
                          .transactionHistoryFilter.value.products!
                          .toList());
                    } else {
                      selectedProducts = [];
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Select All Products Above',
                      textAlign: TextAlign.end,
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    isSelectedAllTransactions
                        ? SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                'assets/icons/earning_history/checkbox.png',
                                width: 22,
                                height: 22,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                'assets/icons/earning_history/checkbox_empty.png',
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(thickness: 0.30),
              // RadioListTile(
              //   value: true,
              //   groupValue: isSearchByDate,
              //   activeColor: kColorPrimaryDark,
              //   toggleable: true,
              //   onChanged: (value) {
              //     print(value);
              //     if (value == null) {
              //       setState(() {
              //         isSearchByDate = false;
              //       });
              //     } else {
              //       setState(() {
              //         isSearchByDate = true;
              //       });
              //     }
              //     print(isSearchByDate);
              //   },
              //   dense: true,
              //   contentPadding: const EdgeInsets.all(0),
              //   title: Text(
              //     'Search By Date',
              //     style: kBlackMediumStyle,
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.2,
                    child: Text(
                      'Start Date:',
                      textAlign: TextAlign.end,
                      style: kBlackMediumStyle,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime.now(),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          print('confirm $date');

                          setState(() {
                            fromDate = date;
                          });
                        },
                        currentTime: DateTime.now(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
                          Text(
                            DateFormat('dd').format(fromDate),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.black12,
                            width: 1,
                          ),
                          Text(
                            DateFormat('MM').format(fromDate),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.black12,
                            width: 1,
                          ),
                          Text(
                            DateFormat('yyyy').format(fromDate),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.2,
                    child: Text(
                      'End Date:',
                      style: kBlackMediumStyle,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: fromDate,
                        maxTime: DateTime.now(),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          print('confirm $date');

                          setState(() {
                            endDate = date;
                          });
                        },
                        currentTime: DateTime.now(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
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
                          Text(
                            DateFormat('dd').format(endDate),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.black12,
                            width: 1,
                          ),
                          Text(
                            DateFormat('MM').format(endDate),
                          ),
                          Container(
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.black12,
                            width: 1,
                          ),
                          Text(
                            DateFormat('yyyy').format(endDate),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              GradientButton(
                text: 'Apply Filter',
                width: true,
                onTap: () async {
                  Get.back(
                    result: {
                      "fromDate":
                          isSearchByDate ? fromDate.toIso8601String() : null,
                      "endDate":
                          isSearchByDate ? endDate.toIso8601String() : null,
                    },
                  );
                },
                widthSize: Get.width,
                buttonState: ButtonState.idle,
              ),
            ],
          );
        },
      ),
    );
  }
}
