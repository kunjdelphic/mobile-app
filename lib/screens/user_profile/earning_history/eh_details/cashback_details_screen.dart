import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class CashbackDetailsScreen extends StatefulWidget {
  final EarningHistoryData earningHistoryData;

  const CashbackDetailsScreen({Key? key, required this.earningHistoryData}) : super(key: key);

  @override
  _CashbackDetailsScreenState createState() => _CashbackDetailsScreenState();
}

class _CashbackDetailsScreenState extends State<CashbackDetailsScreen> {
  @override
  void initState() {
    // log("+-+-+-+-+-+-+-+-+-+-+-+-+-+- ${widget.earningHistoryData.others!.toJson()}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("+-+-+-+-+-+-+-+-+-+-+-+-+-+- ${widget.earningHistoryData.others!.toJson()}");
    print("+-+-+-+-+-+-+-+-+-+-+-+-+-+- ${widget.earningHistoryData.transType}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Cashback",
          style: kBlackLargeStyle,
        ),
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(5),
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
                  child: Center(
                    child: Image.asset(
                      'assets/icons/earning_history/ic_cashback.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Text(
                  '${widget.earningHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.earningHistoryData.currency} ${widget.earningHistoryData.amount}',
                  style: kPrimaryDarkSuperLargeStyle,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          // Text(
          //   'Transaction Fees',
          //   style: kBlackSmallLightMediumStyle,
          // ),
          //           Text(
          //             'RM 0.60',
          //             style: kBlackDarkMediumStyle,
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: kBlackSmallLightMediumStyle,
                    ),
                    Text(
                      widget.earningHistoryData.status == 'SUCCESS'
                          ? 'Successful'
                          : widget.earningHistoryData.status == 'PENDING'
                              ? 'Processing'
                              : 'Failed',
                      style: widget.earningHistoryData.status == 'SUCCESS'
                          ? kPrimaryDarkMediumStyle
                          : widget.earningHistoryData.status == 'PENDING'
                              ? kPrimary2DarkMediumStyle
                              : kRedDarkMediumStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Remark:',
                        style: kBlackSmallLightMediumStyle,
                      ),
                      Text(
                        '${widget.earningHistoryData.remarks!.isNotEmpty ? widget.earningHistoryData.remarks : 'N/A'}',
                        textAlign: TextAlign.end,
                        style: kBlackDarkMediumStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            color: Color(0xffF2F1F6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Text(
                'Payment Details',
                style: kBlackSmallMediumStyle,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
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
                      'assets/icons/earning_history/txn_fee_refresh_wallet.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Text(
                  '${widget.earningHistoryData.currency} ${widget.earningHistoryData.others!.transactionAmount}',
                  style: kPrimaryDarkSuperLargeStyle,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.others!.productName}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.network(
                      widget.earningHistoryData.others!.productLogo,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      width: 50,
                      height: 30,
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.earningHistoryData.transType == "BILL_PAYMENT_CASHBACK" ? 'Account Number:' : "Phone Number",
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.others!.accountNumber}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction ID:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.transactionId}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date & Time:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          CommonTools().getDateAndTime(widget.earningHistoryData.timestamp!),
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                widget.earningHistoryData.others!.nickName != null
                    ? widget.earningHistoryData.others!.nickName.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Favorite Bill Payment to:',
                                style: kBlackSmallLightMediumStyle,
                              ),
                              Text(
                                '${widget.earningHistoryData.others!.nickName}',
                                style: kBlackDarkMediumStyle,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          )
                        : const SizedBox(
                            height: 25,
                          )
                    : const SizedBox(
                        height: 25,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                widget.earningHistoryData.others!.paymentType == 'SELF' ? 'assets/icons/earning_history/ic_self_payment_dark.png' : 'assets/icons/earning_history/ic_self_payment.png',
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Self Payment',
                                style: widget.earningHistoryData.others!.paymentType == 'SELF' ? kBlackSmallMediumStyle : kBlackSmallLightMediumStyle,
                              ),
                            ],
                          ),
                          Container(
                            height: 13,
                            color: Colors.black38,
                            width: 1.5,
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                widget.earningHistoryData.others!.paymentType == 'RECURRING'
                                    ? 'assets/icons/earning_history/ic_recurring_payment_dark.png'
                                    : 'assets/icons/earning_history/ic_recurring_payment.png',
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Recurring Payment',
                                style: widget.earningHistoryData.others!.paymentType == 'RECURRING' ? kBlackSmallMediumStyle : kBlackSmallLightMediumStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      'assets/icons/earning_history/ic_cashback_bill_payment.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GradientButton(
              text: 'Back',
              width: true,
              onTap: () {
                Get.back();
              },
              widthSize: Get.width * 0.9,
              buttonState: ButtonState.idle,
            ),
          ),
        ],
      ),
    );
  }
}
