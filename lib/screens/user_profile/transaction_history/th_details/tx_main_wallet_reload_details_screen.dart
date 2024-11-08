import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class TxMainWalletReloadDetailsScreen extends StatefulWidget {
  final TransactionHistoryData transactionHistoryData;
  const TxMainWalletReloadDetailsScreen({Key? key, required this.transactionHistoryData}) : super(key: key);

  @override
  _TxMainWalletReloadDetailsScreenState createState() => _TxMainWalletReloadDetailsScreenState();
}

class _TxMainWalletReloadDetailsScreenState extends State<TxMainWalletReloadDetailsScreen> {
  WalletController walletController = Get.find();

  @override
  void initState() {
    super.initState();

    getNote();
  }

  Future<String> getNote() async {
    print('CALLED >>>>>> ');
    String res = await walletController.getMainWalletReloadNote();
    return res;
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
          "Main Wallet Reload",
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
                    color: const Color(0xffF6F6F6),
                    // color: kWhite,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.transactionHistoryData.status == 'SUCCESS' || widget.transactionHistoryData.status == 'PENDING'
                          ? 'assets/icons/transaction_history/ic_wallet_success.png'
                          : 'assets/icons/transaction_history/ic_wallet_failed.png',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Transaction Fees',
                      style: kBlackSmallLightMediumStyle,
                    ),
                    Text(
                      '${widget.transactionHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.others!.negativeWalletCharge}',
                      style: kBlackDarkMediumStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
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
                          'Main Wallet Reload',
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
                          '${widget.transactionHistoryData.others!.bankName}',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.network(
                      widget.transactionHistoryData.others!.bankLogo,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(),
                      width: 60,
                    )
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
                          widget.transactionHistoryData.others!.name.isEmpty ? 'N/A' : widget.transactionHistoryData.others!.name,
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
                          widget.transactionHistoryData.transactionId,
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
                  height: 25,
                ),
                FutureBuilder(
                  future: getNote(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) {
                      return Text(
                        '...',
                        style: kBlackExtraSmallMediumStyle,
                      );
                    }
                    return Text(
                      '${snapshot.data}',
                      style: kBlackExtraSmallMediumStyle,
                    );
                  },
                ),
                // Text(
                //   '* Transaction Fees will be charged from your earning wallet when every time you reload your "Main Wallet".',
                //   style: kBlackExtraSmallMediumStyle,
                // ),
                // Text(
                //   '*  If your earning wallet balance is lower than negative RM0.60, then RM 1.50 will be charged directly in your bank account while reload to main wallet.',
                //   style: kBlackExtraSmallMediumStyle,
                // ),
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
