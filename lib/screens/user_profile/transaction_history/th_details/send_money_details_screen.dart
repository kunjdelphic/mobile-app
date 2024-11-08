import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class SendMoneyDetailsScreen extends StatefulWidget {
  TransactionHistoryData transactionHistoryData;

  SendMoneyDetailsScreen({
    Key? key,
    required this.transactionHistoryData,
  }) : super(key: key);

  @override
  _SendMoneyDetailsScreenState createState() => _SendMoneyDetailsScreenState();
}

class _SendMoneyDetailsScreenState extends State<SendMoneyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Send Money",
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
                    color: const Color(0xffF6F6F6),
                    // color: kWhite,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.transactionHistoryData.status == 'SUCCESS'
                          ? 'assets/icons/transaction_history/ic_send_money_success.png'
                          : 'assets/icons/transaction_history/ic_send_money_failed.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Text(
                  '${widget.transactionHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.amount}',
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
                      widget.transactionHistoryData.status == 'SUCCESS'
                          ? 'Successful'
                          : widget.transactionHistoryData.status == 'PENDING'
                              ? 'Processing'
                              : 'Failed',
                      style: widget.transactionHistoryData.status == 'SUCCESS'
                          ? kPrimaryDarkMediumStyle
                          : widget.transactionHistoryData.status == 'PENDING'
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          'Send Money',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       'Detail:',
                    //       style: kBlackSmallLightMediumStyle,
                    //     ),
                    //     Text(
                    //       'Transaction Fees',
                    //       style: kBlackDarkMediumStyle,
                    //     ),
                    //   ],
                    // ),
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
                          'Sent Money To:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.transactionHistoryData.others!.receiverName}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // Image.asset(
                    //   'assets/images/logo/parrotpos_logo.png',
                    //   width: 60,
                    // )
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
                          'Phone Number:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.transactionHistoryData.others!.receiverPhoneNumber}',
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
                          CommonTools().getDateAndTime(
                              widget.transactionHistoryData.timestamp),
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          GradientButton(
            text: 'Back',
            width: true,
            onTap: () {
              Get.back();
            },
            widthSize: Get.width * 0.9,
            buttonState: ButtonState.idle,
          ),
        ],
      ),
    );
  }
}
