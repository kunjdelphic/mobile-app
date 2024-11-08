import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/models/wallet/wallet_balance.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class WalletTransactionItem extends StatelessWidget {
  final WalletTransaction walletTransaction;
  const WalletTransactionItem({
    Key? key,
    required this.walletTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        color: kWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
            child: const Icon(
              Icons.account_balance_wallet,
              color: kColorPrimary,
              size: 15,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DateFormat('dd.MM.yyyy | hh:mm:ss')
                          .format(DateTime.parse(walletTransaction.timestamp!)),
                      style: kBlackExtraSmallLightMediumStyle,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${walletTransaction.status}',
                      style: kPrimaryExtraSmallMediumStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      walletTransaction.transType == 'RELOAD_WALLET'
                          ? 'Main Wallet Reload'
                          : walletTransaction.transType ?? '',
                      style: kBlackMediumStyle,
                    ),
                    Text(
                      '${walletTransaction.type == 'CREDIT' ? '+' : '-'} ${walletTransaction.currency} ${walletTransaction.amount}',
                      style: kPrimaryLargeStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${walletTransaction.others!.fpxBankName}',
                      style: kBlackExtraSmallLightMediumStyle,
                    ),
                    Image.network(
                      walletTransaction.others!.logo ?? '',
                      color: kColorPrimary,
                      width: Get.width * 0.1,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
