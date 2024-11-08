import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class EarningsToMainWalletDetailsScreen extends StatefulWidget {
  final EarningHistoryData earningHistoryData;

  const EarningsToMainWalletDetailsScreen({
    Key? key,
    required this.earningHistoryData,
  }) : super(key: key);

  @override
  _EarningsToMainWalletDetailsScreenState createState() =>
      _EarningsToMainWalletDetailsScreenState();
}

class _EarningsToMainWalletDetailsScreenState
    extends State<EarningsToMainWalletDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Earning to Main Wallet",
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
                      'assets/icons/transaction_history/ic_wallet_success.png',
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
                          'Earning To Main Wallet',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Transferred Amount:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${widget.earningHistoryData.amount}',
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
                          'Detail:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          'Wallet Transfer',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Transaction Charge:',
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          '${widget.earningHistoryData.currency} ${widget.earningHistoryData.others!.deductFromTransactionFees}',
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
                          CommonTools().getDateAndTime(
                              widget.earningHistoryData.timestamp!),
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
                  '* Earning wallet to Main Wallet transaction charge subject to change without prior notice.',
                  style: kBlackExtraSmallMediumStyle,
                ),
                Text(
                  '*  This charge will be incurred every time user transfer money from Earning Wallet to Main Wallet.',
                  style: kBlackExtraSmallMediumStyle,
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
