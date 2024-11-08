import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as example;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
//     as example;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class EarningHistoryFilterScreen extends StatefulWidget {
  final Map? filterMap;
  const EarningHistoryFilterScreen({
    Key? key,
    required this.filterMap,
  }) : super(key: key);

  @override
  _EarningHistoryFilterScreenState createState() =>
      _EarningHistoryFilterScreenState();
}

class _EarningHistoryFilterScreenState
    extends State<EarningHistoryFilterScreen> {
  // ReferralController referralController = Get.find();
  // UserProfileController userProfileController = Get.find();
  List keywords = [];
  TextEditingController searchController = TextEditingController();

  bool isSearchByDate = false;
  bool isSelectedAllTransactions = false;
  bool isReferralEarnings = false,
      isCashback = false,
      isReceivedMoney = false,
      isTransactionFees = false,
      isEarningToMainWallet = false;
  late DateTime fromDate, endDate;

  @override
  void initState() {
    super.initState();

    // print('${widget.filterMap}');

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            'Choose From The Transactions Below:',
            style: kBlackMediumStyle,
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isReferralEarnings = !isReferralEarnings;
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
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
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Referral Earnings',
                          style: kBlackMediumStyle,
                        ),
                        isReferralEarnings
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
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isCashback = !isCashback;
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      color: Color(0xffF6F6F6),
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
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cashback',
                          style: kBlackMediumStyle,
                        ),
                        isCashback
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
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isReceivedMoney = !isReceivedMoney;
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      color: Color(0xffF6F6F6),
                      // color: kWhite,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/icons/earning_history/ic_received_money.png',
                      // width: 18,
                      // height: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Received Money',
                          style: kBlackMediumStyle,
                        ),
                        isReceivedMoney
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
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isTransactionFees = !isTransactionFees;
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      color: Color(0xffF6F6F6),
                      // color: kWhite,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/icons/earning_history/ic_txnfee.png',
                      // width: 18,
                      // height: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction Fees',
                          style: kBlackMediumStyle,
                        ),
                        isTransactionFees
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
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isEarningToMainWallet = !isEarningToMainWallet;
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      color: Color(0xffF6F6F6),
                      // color: kWhite,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      'assets/icons/earning_history/ic_txnfee.png',
                      // width: 18,
                      // height: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Earning To Main Wallet',
                          style: kBlackMediumStyle,
                        ),
                        isEarningToMainWallet
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
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isSelectedAllTransactions = !isSelectedAllTransactions;
                if (isSelectedAllTransactions) {
                  isReferralEarnings = true;
                  isCashback = true;
                  isReceivedMoney = true;
                  isTransactionFees = true;
                  isEarningToMainWallet = true;
                } else {
                  isReferralEarnings = false;
                  isCashback = false;
                  isReceivedMoney = false;
                  isTransactionFees = false;
                  isEarningToMainWallet = false;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Select All Transactions Above',
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
                  example.DatePicker.showDatePicker(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  example.DatePicker.showDatePicker(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  "endDate": isSearchByDate ? endDate.toIso8601String() : null,
                },
              );
            },
            widthSize: Get.width,
            buttonState: ButtonState.idle,
          ),
        ],
      ),
    );
  }
}
