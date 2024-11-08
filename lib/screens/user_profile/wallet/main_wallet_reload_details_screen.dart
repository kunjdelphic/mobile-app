import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class MainWalletReloadDetailsScreen extends StatefulWidget {
  const MainWalletReloadDetailsScreen({Key? key}) : super(key: key);

  @override
  _MainWalletReloadDetailsScreenState createState() =>
      _MainWalletReloadDetailsScreenState();
}

class _MainWalletReloadDetailsScreenState
    extends State<MainWalletReloadDetailsScreen> {
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
                      // 'assets/icons/wallet.png',
                      'assets/icons/earning_history/ic_txnfee.png',

                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                Text(
                  '+ RM 30.00',
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
                      'RM 0.60',
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
                      'Successful',
                      style: kPrimaryDarkMediumStyle,
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
                        'N/A',
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
            color: const Color(0xffF2F1F6),
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
                          'CIMB Bank',
                          style: kBlackDarkMediumStyle,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/images/logo/parrotpos_logo.png',
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
                          '6241896481',
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
                          '6241896481',
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
                          '10.10.21 | 12:00 PM',
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
                Text(
                  '*  If your earning wallet balance is lower than negative RM0.60, then RM 1.50 will be charged directly in your bank account while reload to main wallet.',
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
