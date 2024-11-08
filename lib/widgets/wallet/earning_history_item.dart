import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/cashback_details_screen.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/earning_to_main_wallet_details_screen.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/received_money_details_screen.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/referral_earnings_details_screen.dart';
import 'package:parrotpos/screens/user_profile/earning_history/eh_details/transaction_fees_details_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class EarningHistoryItem extends StatefulWidget {
  final EarningHistoryData earningHistoryData;
  const EarningHistoryItem({
    Key? key,
    required this.earningHistoryData,
  }) : super(key: key);

  @override
  _EarningHistoryItemState createState() => _EarningHistoryItemState();
}

class _EarningHistoryItemState extends State<EarningHistoryItem> {
  String icLogo = '';
  String title = '';
  String subTitle = '';

  @override
  void initState() {
    super.initState();

    switch (widget.earningHistoryData.transType) {
      case 'EARNING_TO_MAIN_TRANSACTION_FEES':
        icLogo = 'assets/icons/earning_history/ic_txnfee.png';
        title = 'EARNING_TO_MAIN_TRANSACTION_FEES';
        // subTitle = 'EARNING_TO_MAIN_TRANSACTION_FEES\n';
        break;
      case 'RECEIVED_MONEY':
        icLogo = 'assets/icons/earning_history/ic_received_money.png';
        title = 'Received Money';
        subTitle = '${widget.earningHistoryData.others!.senderName}\n${widget.earningHistoryData.others!.senderPhoneNumber}';
        break;
      case 'EARNING_TO_MAIN_TRANSFER':
        icLogo = 'assets/icons/earning_history/ic_txnfee.png';
        title = 'Earning To Main Wallet';
        subTitle =
            'Wallet Transfer: ${widget.earningHistoryData.currency} ${widget.earningHistoryData.amount}\nTransaction Charge: ${widget.earningHistoryData.currency} ${widget.earningHistoryData.others!.deductFromTransactionFees}';
        break;
      case 'BILL_PAYMENT_CASHBACK':
        icLogo = 'assets/icons/earning_history/ic_cashback.png';
        title = 'Cashback';
        subTitle = '${widget.earningHistoryData.others!.productName}\n${widget.earningHistoryData.others!.accountNumber}';
        break;
      case 'RELOAD_WALLET_FEES':
        icLogo = 'assets/icons/earning_history/ic_txnfee.png';
        title = 'Transaction Fees';
        subTitle = 'Main Wallet Reload\n';
        break;
      case 'TOPUP_CASHBACK':
        icLogo = 'assets/icons/earning_history/ic_cashback.png';
        title = 'Cashback';
        subTitle = '${widget.earningHistoryData.others!.productName}\n${widget.earningHistoryData.others!.accountNumber}';
        break;
      case 'REFERRAL_EARNING':
        icLogo = 'assets/icons/earning_history/ic_referral_earning.png';
        title = 'Referral Earnings';
        subTitle = 'Total Referrals: ${widget.earningHistoryData.others!.referralCount}\n';
        break;
      default:
        icLogo = 'assets/icons/earning_history/ic_cashback.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.earningHistoryData.transType) {
          case 'EARNING_TO_MAIN_TRANSACTION_FEES':
            break;
          case 'RECEIVED_MONEY':
            Get.to(() => ReceivedMoneyDetailsScreen(
                  earningHistoryData: widget.earningHistoryData,
                ));
            break;
          case 'EARNING_TO_MAIN_TRANSFER':
            Get.to(() => EarningsToMainWalletDetailsScreen(
                  earningHistoryData: widget.earningHistoryData,
                ));
            break;
          case 'BILL_PAYMENT_CASHBACK':
            Get.to(() => CashbackDetailsScreen(
                  earningHistoryData: widget.earningHistoryData,
                ));
            break;
          case 'RELOAD_WALLET_FEES':
            Get.to(() => TransactionFeesDetailsScreen(
                  earningHistoryData: widget.earningHistoryData,
                ));
            break;
          case 'TOPUP_CASHBACK':
            Get.to(() => CashbackDetailsScreen(
                  earningHistoryData: widget.earningHistoryData,
                ));
            break;
          case 'REFERRAL_EARNING':
            Get.to(() => ReferralEarningsDetailsScreen(
                  earningHistoryData: widget.earningHistoryData,
                ));
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 0,
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
              width: 28,
              height: 28,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
                color: const Color(0xffF6F6F6),
                // color: kWhite,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                icLogo,
                // width: 18,
                // height: 18,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              widget.earningHistoryData.transType == 'REFERRAL_EARNING'
                                  ? '${CommonTools().getDate(widget.earningHistoryData.timestamp!)}'
                                  : '${CommonTools().getDateAndTime(widget.earningHistoryData.timestamp!)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kBlackExtraSmallLightMediumStyle,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            widget.earningHistoryData.transType == 'EARNING_TO_MAIN_TRANSFER'
                                ? Expanded(
                                    child: Text(
                                      widget.earningHistoryData.status == 'SUCCESS'
                                          ? 'Successful'
                                          : widget.earningHistoryData.status == 'PENDING'
                                              ? 'Processing'
                                              : 'Failed',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: widget.earningHistoryData.status == 'SUCCESS'
                                          ? kPrimaryExtraSmallMediumStyle
                                          : widget.earningHistoryData.status == 'PENDING'
                                              ? kPrimary2ExtraSmallLightMediumStyle
                                              : kRedExtraSmallMediumStyle,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/earning_history/ic_blue_wallet.png',
                            width: 13,
                            height: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${widget.earningHistoryData.currency} ${widget.earningHistoryData.cashbackWalletAmount}',
                            style: widget.earningHistoryData.cashbackWalletAmount.toString().contains('-') ? kRedMediumStyle : kBlackDarkMediumStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: kBlackMediumStyle,
                        ),
                      ),
                      Text(
                        widget.earningHistoryData.transType == 'EARNING_TO_MAIN_TRANSFER'
                            ? '${widget.earningHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.earningHistoryData.currency} ${widget.earningHistoryData.others!.totalDeduction}'
                            : '${widget.earningHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.earningHistoryData.currency} ${widget.earningHistoryData.amount}',
                        style: kPrimaryDarkExtraLargeStyle,
                      ),
                    ],
                  ),
                  Text(
                    subTitle,
                    style: kBlackExtraSmallLightMediumStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
