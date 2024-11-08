import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/bill_payment_controller.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/controllers/top_up_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';
import 'package:parrotpos/models/favorite/all_recurring.dart';

import 'package:parrotpos/models/favorite/outstanding_bill.dart';
import 'package:parrotpos/models/topup/top_up_amounts.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class RecurringItem extends StatefulWidget {
  final AllRecurringData recurringData;
  final onDelete;
  final onEdit;

  const RecurringItem({
    Key? key,
    required this.recurringData,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<RecurringItem> createState() => _RecurringItemState();
}

class _RecurringItemState extends State<RecurringItem>
    with AutomaticKeepAliveClientMixin {
  Future<OutstandingBill?>? _futureOutstandingBill;
  final TopUpController topUpController = Get.find();
  OutstandingBill? outstandingBill;
  final FavoriteController favoriteController = Get.find();
  Future<BillPaymentAmounts?>? _futureBillPaymentAmts;
  String cashbackAmt = '0.00';
  final UserProfileController userProfileController = Get.find();
  final BillPaymentController billPaymentController = Get.find();
  WalletController walletController = Get.find();
  BillPaymentAmounts? billPaymentAmounts;
  ButtonState btnState = ButtonState.idle;

  late TopUpAmounts topUpAmounts;
  Future<TopUpAmounts?>? _futureTopUpAmts;

  @override
  void initState() {
    if (widget.recurringData.showOutstandingAmount!) {
      _futureOutstandingBill = getOutstandingBill({
        "product_id": "${widget.recurringData.productId}",
        // "country": "MY",
        "account_number": widget.recurringData.accountNumber
      });
    }

    super.initState();
  }

  Future<OutstandingBill?> getOutstandingBill(Map map) async {
    if (map.isEmpty) {
      return null;
    }
    var res = await favoriteController.getOutstandingBill(map);
    if (res.status == 200) {
      outstandingBill = res;
      //got it
      return res;
    } else {
      //error
      // errorSnackbar(title: 'Failed', subtitle: '${res.message}');
      return res;
    }
  }

  Future<BillPaymentAmounts?> getBillPaymentAmounts(Map map) async {
    if (map.isEmpty) {
      return null;
    }
    var res = await billPaymentController.getBillPaymentAmounts(map);
    billPaymentAmounts = res;
    if (res.status == 200) {
      //got it
      return res;
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: '${res.message}');
      return res;
    }
  }

  Future<TopUpAmounts> getTopUpAmounts(Map map) async {
    if (map.isEmpty) {
      return topUpAmounts;
    }
    var res = await topUpController.getTopUpAmounts(map);
    topUpAmounts = res;
    if (res.status == 200) {
      //got it
      return res;
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: '${res.message}');
      return res;
    }
  }

  processBillPayment(String amount) async {
    // setState(() {
    //   btnState = ButtonState.loading;
    // });

    // var res;

    // if (widget.recurringData.fieldsRequired!
    //     .any((element) => element.type == 'PHONE_NUMBER')) {
    //   //send phone no.
    //   res = await billPaymentController.initiateBillPayment({
    //     "amount": amount,
    //     "product_id": widget.recurringData.productId,
    //     "account_number": "+6-${widget.recurringData.accountNumber!}"
    //   });
    // } else {
    //   //send account no.
    //   res = await billPaymentController.initiateBillPayment({
    //     "amount": amount,
    //     "product_id": widget.recurringData.productId,
    //     "account_number": widget.recurringData.accountNumber,
    //     // "account_name": recurringData..text.trim(),
    //   });
    // }

    // setState(() {
    //   btnState = ButtonState.idle;
    // });

    // if (res!.isEmpty) {
    //   //done
    //   walletController.getTransactionHistory({});

    //   showFavCompletedDialog(
    //     context: context,
    //   );
    // } else {
    //   //error
    //   errorSnackbar(title: 'Failed', subtitle: res);
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GestureDetector(
      onTap: () {},
      child: Slidable(
        key: widget.key,
        direction: Axis.horizontal,
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: widget.onEdit,
                    child: Container(
                      width: Get.width * 0.2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                        color: const Color(0xffF2F1F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/favorite/edit_fav.png',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Edit',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kBlackExtraSmallMediumStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height:Get.width * 0.02 ,),
                  GestureDetector(
                    onTap: widget.onDelete,
                    child: Container(
                      width: Get.width * 0.2,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                        color: kRedBtnColor1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/ic_remove_white.png',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Remove',
                            style: kWhiteExtraSmallMediumStyle,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: Get.width,
          // padding: const EdgeInsets.all(8),
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
              bottomLeft: Radius.circular(12),
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            '${widget.recurringData.productImage}',
                            fit: BoxFit.contain,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/logo/parrot_logo.png',
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.recurringData.nickName ?? 'NA',
                                  style: kBlackMediumStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  '${widget.recurringData.productName}',
                                  style: kBlackExtraSmallMediumStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  widget.recurringData.accountNumber ?? 'NA',
                                  style: kBlackExtraSmallMediumStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/icons/favorite/ic_recurring.png',
                                width: 15,
                                height: 15,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Next Payment',
                                style: kBlackExtraSmallMediumStyle,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                widget.recurringData.recurringType == 'Monthly'
                                    ? widget.recurringData.recurringDay >
                                            DateTime.now().day
                                        ? '${widget.recurringData.recurringDay}.${DateFormat('MM.yyyy').format(DateTime.now())}'
                                        : '${widget.recurringData.recurringDay}.${DateFormat('MM.yyyy').format(DateTime.now().add(const Duration(days: 30)))}'
                                    : Config().weekdays[
                                        widget.recurringData.recurringDay],
                                style: kBlackExtraSmallMediumStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(thickness: 0.30),
                      widget.recurringData.showOutstandingAmount!
                          ? FutureBuilder<OutstandingBill?>(
                              future: _futureOutstandingBill,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Due: ',
                                        style: kBlackSmallLightMediumStyle,
                                      ),
                                      Container(
                                        height: 24,
                                        width: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: kRedBtnColor1),
                                        child: const LoadingIndicator(
                                          indicatorType:
                                              Indicator.lineScalePulseOut,
                                          colors: [
                                            kWhite,
                                          ],
                                        ),
                                      ),
                                    ],
                                  );

                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: SizedBox(
                                        height: 25,
                                        child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.lineScalePulseOut,
                                          colors: [
                                            kAccentColor,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.data == null) {
                                  return const SizedBox();
                                }
                                if (snapshot.data!.status != 200) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Due amount viewing option not available for this bill.',
                                          style:
                                              kBlackExtraSmallLightMediumStyle,
                                        ),
                                      ),
                                      Container(
                                        height: 24,

                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(5),
                                        //     color: kRedBtnColor1),
                                        child: Text(
                                          '',
                                          style: kWhiteSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                if (snapshot.data!.bill == null) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Due amount viewing option not available for this bill.',
                                          style:
                                              kBlackExtraSmallLightMediumStyle,
                                        ),
                                      ),
                                      Container(
                                        height: 24,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(5),
                                        //     color: kRedBtnColor1),
                                        child: Text(
                                          '',
                                          style: kWhiteSmallMediumStyle,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                if (snapshot.data!.bill != null &&
                                    outstandingBill == null) {
                                  if (snapshot.data!.bill!.outstandingAmount!
                                      .contains('-')) {
                                    //skip
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Due amount viewing option not available for this bill.',
                                            style:
                                                kBlackExtraSmallLightMediumStyle,
                                          ),
                                        ),
                                        Container(
                                          height: 24,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 3),
                                          // decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.circular(5),
                                          //     color: kRedBtnColor1),
                                          child: Text(
                                            '',
                                            style: kWhiteSmallMediumStyle,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Due: ',
                                          style: kBlackSmallLightMediumStyle,
                                        ),
                                        Container(
                                          height: 24,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: kRedBtnColor1),
                                          child: Text(
                                            'RM ${snapshot.data!.bill!.outstandingAmount}',
                                            style: kWhiteSmallMediumStyle,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Due amount viewing option not available for this bill.',
                                        style: kBlackExtraSmallLightMediumStyle,
                                      ),
                                    ),
                                    Container(
                                      height: 24,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 3),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(5),
                                      //     color: kRedBtnColor1),
                                      child: Text(
                                        '',
                                        style: kWhiteSmallMediumStyle,
                                      ),
                                    ),
                                  ],
                                );
                              })
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '',
                                  style: kBlackSmallLightMediumStyle,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(5),
                                  //     color: kRedBtnColor1),
                                  child: Text(
                                    '',
                                    style: kWhiteSmallMediumStyle,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 130,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Color(0xffF2F1F6),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.black26,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
