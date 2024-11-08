import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/th_details/prepaid_postpaid_receipt_details_screen.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/th_details/referral_earnings_details_screen.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/th_details/send_money_details_screen.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/th_details/tx_earning_to_main_wallet_details_screen.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/th_details/tx_main_wallet_reload_details_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_details_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/tags/styled_text_tag_action.dart';
import 'package:styled_text/widgets/styled_text.dart';

class TransactionHistoryItem extends StatefulWidget {
  final TransactionHistoryData transactionHistoryData;

  const TransactionHistoryItem({
    Key? key,
    required this.transactionHistoryData,
  }) : super(key: key);

  @override
  _TransactionHistoryItemState createState() => _TransactionHistoryItemState();
}

class _TransactionHistoryItemState extends State<TransactionHistoryItem> {
  String icLogo = '';
  String title = '';
  String subTitle = '';
  String logoUrl = '';

  @override
  Widget build(BuildContext context) {
    print("---- --- --- --- -- -- -- -- -${widget.transactionHistoryData.transType}");

    switch (widget.transactionHistoryData.transType) {
      case 'TOPUP':
        icLogo = widget.transactionHistoryData.status == 'SUCCESS'
            ? 'assets/icons/transaction_history/ic_prepaid_success.png'
            : widget.transactionHistoryData.status == 'FAILED'
                ? 'assets/icons/transaction_history/ic_prepaid_failed.png'
                : 'assets/icons/transaction_history/ic_prepaid_processing.png';
        title = '${widget.transactionHistoryData.others!.productName}';
        subTitle = '${widget.transactionHistoryData.others!.accountNumber.toString().replaceAll('-', '').replaceAll('+6', '')}\n';
        logoUrl = widget.transactionHistoryData.others?.productLogo ?? '';
        break;
      case 'SEND_MONEY':
        icLogo = widget.transactionHistoryData.status == 'SUCCESS' ? 'assets/icons/transaction_history/ic_send_money_success.png' : 'assets/icons/transaction_history/ic_send_money_failed.png';
        title = 'Send Money';
        subTitle = '${widget.transactionHistoryData.others!.receiverName}\n${widget.transactionHistoryData.others!.receiverPhoneNumber}';

        break;
      case 'EARNING_TO_MAIN_TRANSFER':
        icLogo = widget.transactionHistoryData.status == 'SUCCESS' ? 'assets/icons/transaction_history/ic_wallet_success.png' : 'assets/icons/transaction_history/ic_wallet_failed.png';
        title = 'Earning To Main Wallet';
        subTitle = 'Wallet Transfer\n';

        break;
      case 'BILL_PAYMENT':
        icLogo = widget.transactionHistoryData.status == 'SUCCESS'
            ? 'assets/icons/transaction_history/ic_prepaid_success.png'
            : widget.transactionHistoryData.status == 'FAILED'
                ? 'assets/icons/transaction_history/ic_prepaid_failed.png'
                : 'assets/icons/transaction_history/ic_prepaid_processing.png';
        title = '${widget.transactionHistoryData.others!.productName}';
        subTitle = '${widget.transactionHistoryData.others!.accountNumber.toString().replaceAll('-', '').replaceAll('+6', '')}\n';
        logoUrl = widget.transactionHistoryData.others?.productLogo ?? '';

        break;
      case 'RELOAD_WALLET':
        icLogo = widget.transactionHistoryData.status == 'SUCCESS' || widget.transactionHistoryData.status == 'PENDING'
            ? 'assets/icons/transaction_history/ic_wallet_success.png'
            : 'assets/icons/transaction_history/ic_wallet_failed.png';
        title = widget.transactionHistoryData.status == 'SUCCESS' || widget.transactionHistoryData.status == 'PENDING' ? 'Main Wallet Reload' : 'Failed Wallet Reload';
        subTitle = '${widget.transactionHistoryData.others!.bankName}\n${widget.transactionHistoryData.transactionId}';
        logoUrl = widget.transactionHistoryData.others!.bankLogo ?? '';

        break;

      default:
        icLogo = 'assets/icons/earning_history/ic_cashback.png';
    }

    String buildProcessingText() {
      return '<widget>';
    }

    return GestureDetector(
      onTap: () {
        switch (widget.transactionHistoryData.transType) {
          case 'TOPUP':
            Get.to(() => PrepaidPostpaidReceiptDetailsScreen(
                  transactionHistoryData: widget.transactionHistoryData,
                ));
            break;
          case 'SEND_MONEY':
            Get.to(() => SendMoneyDetailsScreen(
                  transactionHistoryData: widget.transactionHistoryData,
                ));
            break;
          case 'EARNING_TO_MAIN_TRANSFER':
            Get.to(() => TxEarningToMainWalletDetailsScreen(
                  transactionHistoryData: widget.transactionHistoryData,
                ));
            break;
          case 'BILL_PAYMENT':
            Get.to(() => PrepaidPostpaidReceiptDetailsScreen(
                  transactionHistoryData: widget.transactionHistoryData,
                ));
            break;
          case 'RELOAD_WALLET':
            Get.to(() => TxMainWalletReloadDetailsScreen(
                  transactionHistoryData: widget.transactionHistoryData,
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
              padding: const EdgeInsets.all(7),
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
                              CommonTools().getDateAndTime(widget.transactionHistoryData.timestamp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: kBlackExtraSmallLightMediumStyle,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            widget.transactionHistoryData.status == 'PENDING'
                                ? Expanded(
                                    child: Container(
                                      width: 60,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.yellow.shade500,
                                        highlightColor: Colors.yellow.shade50,
                                        child: Text(
                                          "Processing",
                                          style: kYellowExtraSmallDarkMediumStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: StyledText(
                                text: widget.transactionHistoryData.status == 'SUCCESS'
                                    ? '<success>Successful</success>'
                                    : widget.transactionHistoryData.status == 'PENDING'
                                        ? '<processing>${buildProcessingText()}</processing>'
                                        : '<fail>Failed</fail>',
                                textAlign: TextAlign.start,
                                style: kBlackExtraSmallLightMediumStyle,
                                overflow: TextOverflow.ellipsis,
                                tags: {
                                  'success': StyledTextActionTag(
                                    (_, attrs) {},
                                    style: kGreenExtraSmallMediumStyle,
                                  ),
                                  'processing': StyledTextActionTag(
                                    (_, attrs) {},
                                    style: kYellowExtraSmallMediumStyle,
                                  ),
                                  'fail': StyledTextActionTag(
                                    (_, attrs) {},
                                    style: kRedExtraSmallMediumStyle,
                                  ),
                                },
                              ),
                              // Text(
                              //   widget.transactionHistoryData.status == 'SUCCESS'
                              //       ? 'Successful'
                              //       : widget.transactionHistoryData.status == 'PENDING'
                              //           ? 'Processing' //'${buildProcessingText()}'
                              //           : 'Failed',
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: widget.transactionHistoryData.status == 'SUCCESS'
                              //       ? kGreenExtraSmallMediumStyle
                              //       : widget.transactionHistoryData.status == 'PENDING'
                              //           ? kYellowExtraSmallMediumStyle
                              //           : kRedExtraSmallMediumStyle,
                              // ),
                            ),
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
                            '${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.mainWalletAmount}',
                            style: kBlackDarkMediumStyle,
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kBlackMediumStyle,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${widget.transactionHistoryData.type == 'DEBIT' ? '-' : '+'}  ${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.amount}',
                        style: widget.transactionHistoryData.type == 'DEBIT' ? kRedExtraLargeStyle : kPrimaryDarkExtraLargeStyle,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subTitle,
                        style: kBlackExtraSmallLightMediumStyle,
                      ),
                      Image.network(
                        logoUrl,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        width: 40,
                        height: 20,
                      ),
                    ],
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
