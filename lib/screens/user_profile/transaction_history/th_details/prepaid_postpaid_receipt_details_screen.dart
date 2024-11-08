import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/th_details/prepaid_postpaid_receipt_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class PrepaidPostpaidReceiptDetailsScreen extends StatefulWidget {
  TransactionHistoryData transactionHistoryData;
  PrepaidPostpaidReceiptDetailsScreen({
    Key? key,
    required this.transactionHistoryData,
  }) : super(key: key);

  @override
  _PrepaidPostpaidReceiptDetailsScreenState createState() => _PrepaidPostpaidReceiptDetailsScreenState();
}

class _PrepaidPostpaidReceiptDetailsScreenState extends State<PrepaidPostpaidReceiptDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    print("/*//*/*/*/*/*/*/*/*/ ${widget.transactionHistoryData.others!.accountNumber.toString().replaceAll('-', '').replaceAll('+6', '')}");
    log("/*//*/*/*/*/*/*/*/*/ ${widget.transactionHistoryData.toJson()}");
    print("/*//*/*/*/*/*/*/*/*/ ${widget.transactionHistoryData.others!.phoneNumber.toString().replaceAll('-', '').replaceAll('+6', '')}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Receipt",
          style: kBlackLargeStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ], color: kWhite, borderRadius: BorderRadius.circular(12)),
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
                      widget.transactionHistoryData.status == 'SUCCESS'
                          ? 'assets/icons/transaction_history/ic_prepaid_success.png'
                          : widget.transactionHistoryData.status == 'FAILED'
                              ? 'assets/icons/transaction_history/ic_prepaid_failed.png'
                              : 'assets/icons/transaction_history/ic_prepaid_processing.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.amount}',
                      style: kPrimaryDarkSuperLargeStyle,
                    ),
                    widget.transactionHistoryData.status != 'FAILED'
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/icons/earning_history/ic_cashback.png',
                                    height: 16,
                                    width: 16,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '+ ${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.others!.cashbackAmount}',
                                    style: kBlackMediumStyle,
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
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
                      widget.transactionHistoryData.status == 'SUCCESS'
                          ? 'Successful'
                          : widget.transactionHistoryData.status == 'PENDING'
                              ? 'Processing'
                              : 'Failed',
                      style: widget.transactionHistoryData.status == 'SUCCESS'
                          ? kGreenMediumStyle
                          : widget.transactionHistoryData.status == 'PENDING'
                              ? kYellowMediumStyle
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
                        widget.transactionHistoryData.remarks ?? 'N/A',
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
                          '${widget.transactionHistoryData.others!.productName}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.network(
                      widget.transactionHistoryData.others!.productLogo!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      width: 50,
                      height: 30,
                    ),
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
                          widget.transactionHistoryData.transType == "BILL_PAYMENT" ? 'Account Number:' : "Phone Number",
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          widget.transactionHistoryData.others!.accountNumber.isEmpty ? 'N/A' : widget.transactionHistoryData.others!.accountNumber.toString().replaceAll('-', '').replaceAll('+6', ''),
                          style: kBlackDarkMediumStyle,
                        )
                        // : Text(
                        //     widget.transactionHistoryData.others!.phoneNumber.isEmpty
                        //         ? 'N/A'
                        //         : widget.transactionHistoryData.others!.phoneNumber.toString().replaceAll('-', '').replaceAll('+6', ''),
                        //     style: kBlackDarkMediumStyle,
                        //   )
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
                          '${widget.transactionHistoryData.transactionId}',
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
                          CommonTools().getDateAndTime(widget.transactionHistoryData.timestamp!),
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                widget.transactionHistoryData.others!.nickName != null
                    ? widget.transactionHistoryData.others!.nickName.isNotEmpty
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
                                '${widget.transactionHistoryData.others!.nickName}',
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
                                widget.transactionHistoryData.others!.paymentType == 'SELF'
                                    ? 'assets/icons/earning_history/ic_self_payment_dark.png'
                                    : 'assets/icons/earning_history/ic_self_payment.png',
                                width: 16,
                                height: 16,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                'Self Payment',
                                style: widget.transactionHistoryData.others!.paymentType == 'SELF' ? kBlackSmallMediumStyle : kBlackSmallLightMediumStyle,
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
                                widget.transactionHistoryData.others!.paymentType == 'RECURRING'
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
                                style: widget.transactionHistoryData.others!.paymentType == 'RECURRING' ? kBlackSmallMediumStyle : kBlackSmallLightMediumStyle,
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
                      'assets/icons/transaction_history/ic_receipt_payment.png',
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
              text: 'Share',
              width: true,
              onTap: () {
                Get.to(() => PrepaidPostpaidReceiptScreen(
                      transactionHistoryData: widget.transactionHistoryData,
                    ));
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
