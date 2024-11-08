import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class TransactionFeesDetailsScreen extends StatefulWidget {
  final EarningHistoryData earningHistoryData;
  const TransactionFeesDetailsScreen({
    Key? key,
    required this.earningHistoryData,
  }) : super(key: key);

  @override
  _TransactionFeesDetailsScreenState createState() => _TransactionFeesDetailsScreenState();
}

class _TransactionFeesDetailsScreenState extends State<TransactionFeesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Transaction Fees",
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
                      'assets/icons/earning_history/ic_txnfee.png',
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
                        widget.earningHistoryData.remarks ?? 'N/A',
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
                    color: Color(0xffF6F6F6),
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
                  '${widget.earningHistoryData.currency} ${widget.earningHistoryData.mainWalletAmount}',
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
                          'Main Wallet Reload',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Detail:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          'Transaction Fees',
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
                          'Bank Details',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.others!.bankName}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.network(
                      widget.earningHistoryData.others!.bankLogo!,
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
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.others!.name}',
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
                  height: 25,
                ),
                Text(
                  '* Transaction Fees will be charged from your earning wallet when every time you reload your "Main Wallet".',
                  style: kBlackExtraSmallMediumStyle,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
