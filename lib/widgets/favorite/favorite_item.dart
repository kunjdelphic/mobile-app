import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/bill_payment_controller.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/controllers/top_up_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';
import 'package:parrotpos/models/favorite/all_favorites.dart';
import 'package:parrotpos/models/favorite/outstanding_bill.dart';
import 'package:parrotpos/models/topup/recent_top_up.dart';
import 'package:parrotpos/screens/server_upgrade_custom_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_screen.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/outstanding_amt_na_dialog.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/styled_text.dart';

import '../../screens/user_profile/transaction_history/product_transaction_history_screen.dart';

class FavoriteItem extends StatefulWidget {
  final index;
  AllFavoritesData allFavoritesData;
  final onDelete;
  final onEdit;

  FavoriteItem({
    Key? key,
    required this.index,
    required this.allFavoritesData,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<FavoriteItem> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> with AutomaticKeepAliveClientMixin {
  Future<OutstandingBill?>? _futureOutstandingBill;
  final TopUpController topUpController = Get.find();
  OutstandingBill? outstandingBill;
  final FavoriteController favoriteController = Get.find();
  Future<BillPaymentAmounts?>? _futureBillPaymentAmts;
  String cashbackAmt = '0.00';
  final UserProfileController userProfileController = Get.find();
  final BillPaymentController billPaymentController = Get.find();
  WalletController walletController = Get.find();
  // BillPaymentAmounts? billPaymentAmounts;
  ButtonState btnState = ButtonState.idle;
  SharedPreferences? sharedPreferences;

  // late TopUpAmounts topUpAmounts;
  // Future<TopUpAmounts?>? _futureTopUpAmts;
  int dueAmtReloadCount = 0;
  final FocusNode favorite = FocusNode();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(favorite);
    });
    if (widget.allFavoritesData.hasOutstandingAmount!) {
      _futureOutstandingBill = getOutstandingBill({
        "product_id": "${widget.allFavoritesData.productId}",
        // "country": "MY",
        "account_number": widget.allFavoritesData.accountNumber
      });
    }
    print("this function is called");

    initialiseSP();
    // reloadProcceingStatus();
    super.initState();
  }

  void dispose() {
    favorite.dispose();
    super.dispose();
  }

  initialiseSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<OutstandingBill?> getOutstandingBill(Map map) async {
    if (map.isEmpty) {
      return null;
    }
    var res = await favoriteController.getOutstandingBill(map);
    print("----- RES IS 121212122 ${res.toJson()}");
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

  // Future<BillPaymentAmounts?> getBillPaymentAmounts(Map map) async {
  //   // if (map.isEmpty) {
  //   //   return null;
  //   // }
  //   // var res = await billPaymentController.getBillPaymentAmounts(map);
  //   // billPaymentAmounts = res;
  //   // if (res.status == 200) {
  //   //   //got it
  //   //   return res;
  //   // } else {
  //   //   //error
  //   //   errorSnackbar(title: 'Failed', subtitle: '${res.message}');
  //   //   return res;
  //   // }
  // }

  // Future<TopUpAmounts> getTopUpAmounts(Map map) async {
  //   // if (map.isEmpty) {
  //   //   return topUpAmounts;
  //   // }
  //   // var res = await topUpController.getTopUpAmounts(map);
  //   // topUpAmounts = res;
  //   // if (res.status == 200) {
  //   //   //got it
  //   //   return res;
  //   // } else {
  //   //   //error
  //   //   errorSnackbar(title: 'Failed', subtitle: '${res.message}');
  //   //   return res;
  //   // }
  // }

  /// processBillPayment
  // processBillPayment(String amount) async {
  //   processingDialog(title: 'Processing bill payment.. Please wait!', context: context);
  //
  //   setState(() {
  //     btnState = ButtonState.loading;
  //   });
  //
  //   String? res;
  //
  //   if (widget.allFavoritesData.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')) {
  //     //send phone no.
  //     res = await billPaymentController.initiateBillPayment({"amount": amount, "product_id": widget.allFavoritesData.productId, "account_number": widget.allFavoritesData.accountNumber!});
  //   } else {
  //     //send account no.
  //     res = await billPaymentController.initiateBillPayment({
  //       "amount": amount,
  //       "product_id": widget.allFavoritesData.productId,
  //       "account_number": widget.allFavoritesData.accountNumber,
  //       // "account_name": allFavoritesData..text.trim(),
  //     });
  //   }
  //
  //   setState(() {
  //     btnState = ButtonState.idle;
  //     widget.allFavoritesData.lastTransactionTimestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()).toString();
  //
  //     if (res!.isEmpty) {
  //       widget.allFavoritesData.lastTransactionStatus = 'PENDING';
  //     } else {
  //       widget.allFavoritesData.lastTransactionStatus = 'FAILED';
  //     }
  //   });
  //
  //   walletController.getTransactionHistory({});
  //
  //   walletController.getEarningHistory();
  //   walletController.getWalletBalance({});
  //   walletController.getMainWalletReload({});
  //   userProfileController.updateUserDetails();
  //
  //   favoriteController.getAllFavorites({});
  //   topUpController.getRecentTopUp({});
  //
  //   Get.back();
  //
  //   // while (widget.allFavoritesData.lastTransactionStatus == 'PENDING') {
  //   //   Future.delayed(const Duration(seconds: 5), () {});
  //   // }
  //   if (res!.isEmpty) {
  //     //done
  //
  //     showFavCompletedDialog(
  //       context: context,
  //     );
  //   } else {
  //     print("----- HEY HEY ROMIL ${res}");
  //
  //     if (res == "This Product is Currently Unavailable") {
  //       Get.back();
  //       favoriteCloseDialog(
  //           title: 'Payment for this product is temporarily unavailable',
  //           subtitle: "We are updating our system and are unsure how long it will take to fix.",
  //           image: 'assets/images/exclaim.png',
  //           buttonTitle: 'OK',
  //           context: context);
  //     } else if (res == "Server Maintenance InProgress") {
  //       Get.back();
  //       Get.to(() => const CustomServerUpgradeScreen());
  //     } else {
  //       Get.back();
  //       //error
  //       errorSnackbar(title: 'Failed', subtitle: res);
  //     }
  //   }
  // }

  checkReloadCount() async {
    dueAmtReloadCount++;

    var res = sharedPreferences!.getBool('outstanding_amt');
    if (res != null) {
      if (res) {
        print('DONT SHOW');
        //dont show
        // if (dueAmtReloadCount > 2) {
        //show warning
        // await showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const OutstandingAmtNaDialog();
        //   },
        // );
        // }
      } else {
        print('SHOW');

        //show
        if (dueAmtReloadCount > 2) {
          //show warning
          await showDialog(
            context: context,
            builder: (context) {
              return const OutstandingAmtNaDialog();
            },
          );
        }
      }
    } else {
      print('SHOW');

      //show
      if (dueAmtReloadCount > 2) {
        //show warning
        await showDialog(
          context: context,
          builder: (context) {
            return const OutstandingAmtNaDialog();
          },
        );
      }
    }
  }

  showBillPaymentSheet() async {
    // TextEditingController amountController = TextEditingController();
    // bool isExceed = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ShowBillPaymentCard(allFavoritesData: widget.allFavoritesData),

      /// old Code
      // builder: (context) {
      //   return StatefulBuilder(
      //     builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
      //       return SingleChildScrollView(
      //         child: AnimatedPadding(
      //           padding: MediaQuery.of(context).viewInsets,
      //           duration: const Duration(milliseconds: 100),
      //           curve: Curves.decelerate,
      //           child: GestureDetector(
      //             onTap: () => FocusScope.of(context).unfocus(),
      //             child: Container(
      //               decoration: const BoxDecoration(
      //                 borderRadius: BorderRadius.only(
      //                   topLeft: Radius.circular(25),
      //                   topRight: Radius.circular(25),
      //                 ),
      //                 color: kWhite,
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.black12,
      //                     spreadRadius: 7,
      //                     blurRadius: 10,
      //                   ),
      //                 ],
      //               ),
      //               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Center(
      //                     child: Container(
      //                       width: 60,
      //                       height: 1.5,
      //                       color: Colors.black26,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 25,
      //                   ),
      //                   Container(
      //                     width: Get.width,
      //                     padding: const EdgeInsets.all(15),
      //                     decoration: BoxDecoration(
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: Colors.black.withOpacity(0.2),
      //                           blurRadius: 6,
      //                           spreadRadius: 2,
      //                         ),
      //                       ],
      //                       color: kWhite,
      //                       // color: kWhite,
      //                       borderRadius: BorderRadius.circular(12),
      //                     ),
      //                     child: Column(
      //                       children: [
      //                         Row(
      //                           children: [
      //                             Container(
      //                               width: 50,
      //                               height: 50,
      //                               padding: const EdgeInsets.all(5),
      //                               decoration: BoxDecoration(
      //                                 // boxShadow: [
      //                                 //   BoxShadow(
      //                                 //     color: Colors.black.withOpacity(0.1),
      //                                 //     blurRadius: 5,
      //                                 //     spreadRadius: 1,
      //                                 //   ),
      //                                 // ],
      //                                 color: kWhite,
      //                                 // color: kWhite,
      //                                 borderRadius: BorderRadius.circular(100),
      //                               ),
      //                               child: CircleAvatar(
      //                                 backgroundColor: kWhite,
      //                                 child: Padding(
      //                                   padding: const EdgeInsets.all(3.0),
      //                                   child: Image.network(
      //                                     widget.allFavoritesData.productImage ?? '',
      //                                     errorBuilder: (context, error, stackTrace) => Image.asset(
      //                                       'assets/images/logo/parrot_logo.png',
      //                                       width: 30,
      //                                       height: 30,
      //                                     ),
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                             const SizedBox(
      //                               width: 10,
      //                             ),
      //                             Expanded(
      //                               child: Column(
      //                                 crossAxisAlignment: CrossAxisAlignment.start,
      //                                 mainAxisAlignment: MainAxisAlignment.center,
      //                                 children: [
      //                                   Text(
      //                                     '${widget.allFavoritesData.nickName}',
      //                                     style: kBlackMediumStyle,
      //                                     maxLines: 1,
      //                                     overflow: TextOverflow.ellipsis,
      //                                   ),
      //                                   Text(
      //                                     '${widget.allFavoritesData.productName}',
      //                                     style: kBlackExtraSmallLightMediumStyle,
      //                                     maxLines: 1,
      //                                     overflow: TextOverflow.ellipsis,
      //                                   ),
      //                                   Text(
      //                                     widget.allFavoritesData.accountNumber!,
      //                                     style: kBlackExtraSmallLightMediumStyle,
      //                                     maxLines: 1,
      //                                     overflow: TextOverflow.ellipsis,
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         const Divider(thickness: 0.30),
      //                         widget.allFavoritesData.hasOutstandingAmount!
      //                             ? FutureBuilder<OutstandingBill?>(
      //                                 future: _futureOutstandingBill,
      //                                 builder: (context, snapshot) {
      //                                   if (snapshot.connectionState == ConnectionState.waiting) {
      //                                     return Row(
      //                                       mainAxisAlignment: MainAxisAlignment.end,
      //                                       children: [
      //                                         Text(
      //                                           'Due: ',
      //                                           style: kBlackSmallLightMediumStyle,
      //                                         ),
      //                                         Container(
      //                                           height: 24,
      //                                           width: 40,
      //                                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      //                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
      //                                           child: const LoadingIndicator(
      //                                             indicatorType: Indicator.lineScalePulseOut,
      //                                             colors: [
      //                                               kWhite,
      //                                             ],
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   }
      //                                   if (snapshot.data == null) {
      //                                     return const SizedBox();
      //                                   }
      //                                   if (snapshot.data!.status != 200) {
      //                                     return Row(
      //                                       mainAxisAlignment: MainAxisAlignment.start,
      //                                       children: [
      //                                         Expanded(
      //                                           child: Text(
      //                                             'Due amount currently unavailable.',
      //                                             style: kBlackExtraSmallLightMediumStyle,
      //                                           ),
      //                                         ),
      //                                         Container(
      //                                           height: 24,
      //
      //                                           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      //                                           // decoration: BoxDecoration(
      //                                           //     borderRadius: BorderRadius.circular(5),
      //                                           //     color: kRedBtnColor1),
      //                                           child: Text(
      //                                             '',
      //                                             style: kWhiteSmallMediumStyle,
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   }
      //
      //                                   if (snapshot.data!.bill == null) {
      //                                     return Row(
      //                                       mainAxisAlignment: MainAxisAlignment.start,
      //                                       children: [
      //                                         Expanded(
      //                                           child: Text(
      //                                             'Due amount currently unavailable.',
      //                                             style: kBlackExtraSmallLightMediumStyle,
      //                                           ),
      //                                         ),
      //                                         Container(
      //                                           height: 24,
      //                                           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      //                                           // decoration: BoxDecoration(
      //                                           //     borderRadius: BorderRadius.circular(5),
      //                                           //     color: kRedBtnColor1),
      //                                           child: Text(
      //                                             '',
      //                                             style: kWhiteSmallMediumStyle,
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                   }
      //
      //                                   if (snapshot.data!.bill != null && outstandingBill != null) {
      //                                     // if (!snapshot.data!.bill!.outstandingAmount!
      //                                     //     .contains('-')) {
      //                                     //   //skip
      //                                     //   return Row(
      //                                     //     mainAxisAlignment:
      //                                     //         MainAxisAlignment.start,
      //                                     //     children: [
      //                                     //       Expanded(
      //                                     //         child: Text(
      //                                     //           'Due amount viewing option not available for this bill.',
      //                                     //           style:
      //                                     //               kBlackExtraSmallLightMediumStyle,
      //                                     //         ),
      //                                     //       ),
      //                                     //       Container(
      //                                     //         height: 24,
      //                                     //         padding: const EdgeInsets.symmetric(
      //                                     //             horizontal: 0, vertical: 3),
      //                                     //         // decoration: BoxDecoration(
      //                                     //         //     borderRadius: BorderRadius.circular(5),
      //                                     //         //     color: kRedBtnColor1),
      //                                     //         child: Text(
      //                                     //           '',
      //                                     //           style: kWhiteSmallMediumStyle,
      //                                     //         ),
      //                                     //       ),
      //                                     //     ],
      //                                     //   );
      //                                     // } else {
      //                                     return Row(
      //                                       mainAxisAlignment: MainAxisAlignment.end,
      //                                       children: [
      //                                         widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
      //                                             ? Expanded(
      //                                                 child: StyledText(
      //                                                   text: widget.allFavoritesData.lastTransactionStatus == 'SUCCESS'
      //                                                       ? 'Payment <success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
      //                                                       : 'Payment <fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
      //                                                   textAlign: TextAlign.center,
      //                                                   style: kBlackExtraSmallLightMediumStyle,
      //                                                   tags: {
      //                                                     'success': StyledTextActionTag(
      //                                                       (_, attrs) {},
      //                                                       style: kPrimaryExtraSmallDarkMediumStyle,
      //                                                     ),
      //                                                     'fail': StyledTextActionTag(
      //                                                       (_, attrs) {},
      //                                                       style: kRedExtraSmallDarkMediumStyle,
      //                                                     ),
      //                                                   },
      //                                                 ),
      //                                               )
      //                                             : const SizedBox(),
      //                                         const SizedBox(
      //                                           width: 10,
      //                                         ),
      //                                         Text(
      //                                           'Due: ',
      //                                           style: kBlackSmallLightMediumStyle,
      //                                         ),
      //                                         GestureDetector(
      //                                           onTap: () {
      //                                             _futureOutstandingBill = getOutstandingBill({
      //                                               "product_id": "${widget.allFavoritesData.productId}",
      //                                               // "country": "MY",
      //                                               "account_number": widget.allFavoritesData.accountNumber
      //                                             });
      //
      //                                             setState(() {});
      //                                           },
      //                                           child: Container(
      //                                             height: 24,
      //                                             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      //                                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
      //                                             child: Text(
      //                                               'RM ${snapshot.data!.bill!.outstandingAmount}',
      //                                               style: kWhiteSmallMediumStyle,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                       ],
      //                                     );
      //                                     // }
      //                                   }
      //                                   return Row(
      //                                     mainAxisAlignment: MainAxisAlignment.start,
      //                                     children: [
      //                                       Expanded(
      //                                         child: Text(
      //                                           'Due amount currently unavailable.',
      //                                           style: kBlackExtraSmallLightMediumStyle,
      //                                         ),
      //                                       ),
      //                                       Container(
      //                                         height: 24,
      //                                         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      //                                         // decoration: BoxDecoration(
      //                                         //     borderRadius: BorderRadius.circular(5),
      //                                         //     color: kRedBtnColor1),
      //                                         child: Text(
      //                                           '',
      //                                           style: kWhiteSmallMediumStyle,
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   );
      //                                 },
      //                               )
      //                             : Row(
      //                                 mainAxisAlignment: MainAxisAlignment.start,
      //                                 children: [
      //                                   widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
      //                                       ? StyledText(
      //                                           text: widget.allFavoritesData.lastTransactionStatus == 'SUCCESS'
      //                                               ? 'Payment <success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
      //                                               : 'Payment <fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
      //                                           textAlign: TextAlign.start,
      //                                           style: kBlackExtraSmallLightMediumStyle,
      //                                           tags: {
      //                                             'success': StyledTextActionTag(
      //                                               (_, attrs) {},
      //                                               style: kPrimaryExtraSmallDarkMediumStyle,
      //                                             ),
      //                                             'fail': StyledTextActionTag(
      //                                               (_, attrs) {},
      //                                               style: kRedExtraSmallDarkMediumStyle,
      //                                             ),
      //                                           },
      //                                         )
      //                                       : const SizedBox(),
      //                                 ],
      //                               ),
      //                       ],
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 25,
      //                   ),
      //                   Column(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Text(
      //                             'Payment Amount',
      //                             style: kBlackMediumStyle,
      //                           ),
      //                           Row(
      //                             children: [
      //                               Container(
      //                                 width: 22,
      //                                 height: 22,
      //                                 padding: const EdgeInsets.all(5),
      //                                 decoration: BoxDecoration(
      //                                   boxShadow: [
      //                                     BoxShadow(
      //                                       color: Colors.black.withOpacity(0.1),
      //                                       blurRadius: 5,
      //                                       spreadRadius: 1,
      //                                     ),
      //                                   ],
      //                                   color: kWhite,
      //                                   borderRadius: BorderRadius.circular(100),
      //                                 ),
      //                                 child: Center(
      //                                   child: Image.asset(
      //                                     'assets/icons/ic_cashback.png',
      //                                     width: 12,
      //                                     height: 12,
      //                                   ),
      //                                 ),
      //                               ),
      //                               const SizedBox(
      //                                 width: 6,
      //                               ),
      //                               Row(
      //                                 children: [
      //                                   Text(
      //                                     'Cash Back: ',
      //                                     style: kBlackSmallMediumStyle,
      //                                   ),
      //                                   Text(
      //                                     '${widget.allFavoritesData.currency} $cashbackAmt',
      //                                     style: kPrimarySmallDarkMediumStyle,
      //                                   ),
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         ],
      //                       ),
      //                       const SizedBox(
      //                         height: 20,
      //                       ),
      //                       Container(
      //                         decoration: BoxDecoration(
      //                           boxShadow: [
      //                             BoxShadow(
      //                               color: isExceed ? Colors.red : Colors.black.withOpacity(0.2),
      //                               blurRadius: 6,
      //                               spreadRadius: 2,
      //                             ),
      //                           ],
      //                           color: kWhite,
      //                           borderRadius: BorderRadius.circular(12),
      //                         ),
      //                         child: ClipRRect(
      //                           borderRadius: BorderRadius.circular(15),
      //                           child: Row(
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               Padding(
      //                                 padding: const EdgeInsets.only(left: 20),
      //                                 child: Text(
      //                                   'RM',
      //                                   style: kBlackMediumStyle,
      //                                 ),
      //                               ),
      //                               const SizedBox(
      //                                 width: 10,
      //                               ),
      //                               Container(
      //                                 height: 20,
      //                                 color: Colors.black12,
      //                                 width: 1,
      //                               ),
      //                               Expanded(
      //                                 child: TextFormField(
      //                                   focusNode: favorite,
      //                                   textAlignVertical: TextAlignVertical.center,
      //                                   controller: amountController,
      //                                   onChanged: (value) {
      //                                     setState(() {});
      //                                     setBottomSheetState(() {
      //                                       if (value.trim().isEmpty) {
      //                                         cashbackAmt = '0.00';
      //
      //                                         isExceed = false;
      //
      //                                         return;
      //                                       }
      //                                       if (widget.allFavoritesData.amountType == 'INTEGER' && amountController.text.trim().contains('.')) {
      //                                         Get.back();
      //
      //                                         decimalNotAllowedDialog(context: context);
      //                                         return;
      //                                       }
      //                                       //check min
      //                                       if (double.parse(value.trim()) < double.parse(widget.allFavoritesData.minimumAmount.toString())) {
      //                                         //make red
      //
      //                                         isExceed = true;
      //                                       }
      //                                       //check max
      //                                       if (double.parse(value.trim()) > double.parse(widget.allFavoritesData.maximumAmount.toString())) {
      //                                         //make red
      //
      //                                         isExceed = true;
      //                                       }
      //
      //                                       if (double.parse(value.trim()) <= double.parse(widget.allFavoritesData.maximumAmount.toString())) {
      //                                         for (var item in widget.allFavoritesData.amounts!) {
      //                                           if (double.parse(value.trim()) >= double.parse(item.minAmount.toString()) && double.parse(value.trim()) <= double.parse(item.maxAmount.toString())) {
      //                                             print('${item.cashbackAmount}');
      //                                             cashbackAmt = item.cashbackAmount.toString();
      //
      //                                             isExceed = false;
      //
      //                                             return;
      //                                           }
      //                                         }
      //                                       }
      //                                     });
      //
      //                                     // setState(() {
      //                                     //   if (double.parse(
      //                                     //               value.trim()) >=
      //                                     //           snapshot.data!.info!
      //                                     //               .minimumAmount &&
      //                                     //       double.parse(
      //                                     //               value.trim()) <=
      //                                     //           snapshot.data!.info!
      //                                     //               .maximumAmount) {
      //                                     //     for (var item in snapshot
      //                                     //         .data!.amounts!) {
      //                                     //       if (double.parse(
      //                                     //                   value.trim()) >=
      //                                     //               item.minAmount &&
      //                                     //           double.parse(
      //                                     //                   value.trim()) <=
      //                                     //               item.maxAmount) {
      //                                     //         cashbackAmt = item
      //                                     //             .cashbackAmount
      //                                     //             .toString();
      //                                     //         return;
      //                                     //       }
      //                                     //     }
      //                                     //   } else {
      //                                     //     errorSnackbar(
      //                                     //         title: 'Failed',
      //                                     //         subtitle:
      //                                     //             'You cannot exceed the max amount!');
      //                                     //   }
      //                                     // });
      //                                   },
      //                                   enableInteractiveSelection: true,
      //                                   style: kBlackMediumStyle,
      //                                   textInputAction: TextInputAction.done,
      //                                   keyboardType: TextInputType.number,
      //                                   decoration: InputDecoration(
      //                                     contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      //                                     helperStyle: kBlackSmallLightMediumStyle,
      //                                     errorStyle: kBlackSmallLightMediumStyle,
      //                                     hintStyle: kBlackSmallLightMediumStyle,
      //                                     // hintText: 'Min. 10 | Max. 10,000',
      //                                     labelStyle: kBlackSmallLightMediumStyle,
      //                                     fillColor: kWhite,
      //                                     filled: true,
      //                                     enabledBorder: InputBorder.none,
      //                                     errorBorder: InputBorder.none,
      //                                     focusedBorder: InputBorder.none,
      //                                     border: InputBorder.none,
      //                                     suffixIcon: Padding(
      //                                       padding: const EdgeInsets.only(top: 15, left: 20),
      //                                       child: Text(
      //                                         'Min. ${double.parse(widget.allFavoritesData.minimumAmount).toInt()} | Max. ${double.parse(widget.allFavoritesData.maximumAmount).toInt()}',
      //                                         style: isExceed ? kRedSmallLightMediumStyle : kBlackSmallLightMediumStyle,
      //                                       ),
      //                                     ),
      //                                     // suffixIcon: amountController.text.trim().isNotEmpty
      //                                     //     ? Row(
      //                                     //         mainAxisSize: MainAxisSize.min,
      //                                     //         children: [
      //                                     //           Padding(
      //                                     //             padding: const EdgeInsets.only(left: 20),
      //                                     //             child: Text(
      //                                     //               'Min. 10 | Max. 10,000',
      //                                     //               style: kBlackSmallLightMediumStyle,
      //                                     //             ),
      //                                     //           ),
      //                                     //           const SizedBox(
      //                                     //             width: 10,
      //                                     //           ),
      //                                     //           Container(
      //                                     //             height: 20,
      //                                     //             color: Colors.black12,
      //                                     //             width: 1,
      //                                     //           ),
      //                                     //           GestureDetector(
      //                                     //             onTap: () => setState(() {
      //                                     //               amountController.text = '';
      //                                     //             }),
      //                                     //             child: const Icon(
      //                                     //               Icons.close,
      //                                     //               color: Colors.black38,
      //                                     //             ),
      //                                     //           ),
      //                                     //         ],
      //                                     //       )
      //                                     //     : const SizedBox(),
      //                                   ),
      //                                 ),
      //                               ),
      //                               const SizedBox(
      //                                 width: 5,
      //                               ),
      //                               Container(
      //                                 height: 20,
      //                                 color: Colors.black12,
      //                                 width: 1,
      //                               ),
      //                               const SizedBox(
      //                                 width: 5,
      //                               ),
      //                               GestureDetector(
      //                                 onTap: () => setState(() {
      //                                   amountController.text = '';
      //                                 }),
      //                                 child: const Icon(
      //                                   Icons.close,
      //                                   color: Colors.black38,
      //                                   size: 18,
      //                                 ),
      //                               ),
      //                               const SizedBox(
      //                                 width: 10,
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   const SizedBox(
      //                     height: 25,
      //                   ),
      //                   Text(
      //                     'Payment Method:',
      //                     textAlign: TextAlign.start,
      //                     style: kBlackMediumStyle,
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   GetX<UserProfileController>(
      //                     init: userProfileController,
      //                     builder: (_) {
      //                       return Column(
      //                         children: [
      //                           Container(
      //                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //                             decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(15),
      //                               gradient: const LinearGradient(
      //                                 begin: Alignment.topCenter,
      //                                 end: Alignment.bottomCenter,
      //                                 colors: [
      //                                   kColorPrimary,
      //                                   kColorPrimaryDark,
      //                                 ],
      //                               ),
      //                             ),
      //                             child: Stack(
      //                               children: [
      //                                 Positioned(
      //                                   child: Image.asset(
      //                                     'assets/images/wallet/wallet_bg_shapes.png',
      //                                     width: Get.width * 0.3,
      //                                   ),
      //                                 ),
      //                                 Column(
      //                                   crossAxisAlignment: CrossAxisAlignment.start,
      //                                   mainAxisAlignment: MainAxisAlignment.start,
      //                                   children: [
      //                                     Row(
      //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                       crossAxisAlignment: CrossAxisAlignment.start,
      //                                       children: [
      //                                         Column(
      //                                           mainAxisAlignment: MainAxisAlignment.start,
      //                                           crossAxisAlignment: CrossAxisAlignment.start,
      //                                           children: [
      //                                             Text(
      //                                               'Main Wallet',
      //                                               style: kWhiteDarkMediumStyle,
      //                                             ),
      //                                             const SizedBox(
      //                                               height: 10,
      //                                             ),
      //                                             SvgPicture.asset(
      //                                               'assets/images/logo/logo_full.svg',
      //                                               width: Get.width * 0.2,
      //                                             ),
      //                                           ],
      //                                         ),
      //                                         Column(
      //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                           crossAxisAlignment: CrossAxisAlignment.end,
      //                                           children: [
      //                                             Text(
      //                                               'Balance',
      //                                               style: kWhiteDarkMediumStyle,
      //                                             ),
      //                                             const SizedBox(
      //                                               height: 10,
      //                                             ),
      //                                             Text(
      //                                               '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
      //                                               style: kWhiteDarkSuperLargeStyle,
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ],
      //                                     ),
      //                                     const SizedBox(
      //                                       height: 3,
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      //                           const SizedBox(
      //                             height: 25,
      //                           ),
      //                           GradientButton(
      //                             text: 'Pay Now',
      //                             width: false,
      //                             widthSize: Get.width * 0.7,
      //                             buttonState: ButtonState.idle,
      //                             onTap: () {
      //                               if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < double.parse(amountController.text.trim().toString())) {
      //                                 Get.back();
      //
      //                                 lowWalletBalanceDialog(
      //                                   image: 'assets/icons/ic_low_wallet_balance.png',
      //                                   context: context,
      //                                   onTap: () {
      //                                     Get.back();
      //                                     Get.to(() => const MainWalletReloadScreen());
      //                                   },
      //                                 );
      //                                 return;
      //                               } else if (widget.allFavoritesData.amountType == 'INTEGER' && amountController.text.trim().contains('.')) {
      //                                 Get.back();
      //
      //                                 decimalNotAllowedDialog(context: context);
      //                                 return;
      //                               }
      //                               if (double.parse(amountController.text.trim()) < double.parse(widget.allFavoritesData.minimumAmount.toString()) ||
      //                                   double.parse(amountController.text.trim()) > double.parse(widget.allFavoritesData.maximumAmount.toString())) {
      //                                 errorSnackbar(
      //                                     title: 'Failed', subtitle: 'Payment amount should be Min. ${widget.allFavoritesData.minimumAmount} | Max. ${widget.allFavoritesData.maximumAmount}');
      //                                 return;
      //                               }
      //                               Get.back();
      //
      //                               // favoriteClosDialog(
      //                               //     title: 'Payment for this product is temporarily unavailable',
      //                               //     subtitle: "We are updating our system and are unsure how long it will take to fix.",
      //                               //     image: 'assets/images/exclaim.png',
      //                               //     buttonTitle: 'ok',
      //                               //     context: context);
      //
      //                               processBillPayment(amountController.text.trim());
      //                             },
      //                           ),
      //                           const SizedBox(
      //                             height: 15,
      //                           ),
      //                         ],
      //                       );
      //                     },
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   );
      // },
    );
  }

  showTopupSheetRecent() async {
    int selectedAmt = -1;
    String? cashbackAmt;
    String? amount;
    if (widget.allFavoritesData.amount.toString().isNotEmpty) {
      amount = widget.allFavoritesData.amount.toString();
      cashbackAmt = widget.allFavoritesData.cashback.toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSheetRecent) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 7,
                  blurRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 60,
                    height: 1.5,
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                    color: kWhite,
                    // color: kWhite,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.1),
                            //     blurRadius: 5,
                            //     spreadRadius: 1,
                            //   ),
                            // ],
                            color: kWhite,
                            // color: kWhite,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CircleAvatar(
                            backgroundColor: kWhite,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Image.network(
                                widget.allFavoritesData.productImage ?? '',
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  'assets/images/logo/parrot_logo.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.allFavoritesData.nickName}',
                                style: kBlackMediumStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${widget.allFavoritesData.productName}',
                                style: kBlackExtraSmallLightMediumStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.allFavoritesData.accountNumber!,
                                style: kBlackExtraSmallLightMediumStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.30),
                    widget.allFavoritesData.hasOutstandingAmount!
                        ? FutureBuilder<OutstandingBill?>(
                            future: _futureOutstandingBill,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                      child: const LoadingIndicator(
                                        indicatorType: Indicator.lineScalePulseOut,
                                        colors: [
                                          kWhite,
                                        ],
                                      ),
                                    ),
                                  ],
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
                                        'Due amount currently unavailable. 44',
                                        style: kBlackExtraSmallLightMediumStyle,
                                      ),
                                    ),
                                    Container(
                                      height: 24,

                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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
                                        'Due amount currently unavailable.',
                                        style: kBlackExtraSmallLightMediumStyle,
                                      ),
                                    ),
                                    Container(
                                      height: 24,
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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

                              if (snapshot.data!.bill != null && outstandingBill != null) {
                                // if (!snapshot.data!.bill!.outstandingAmount!
                                //     .contains('-')) {
                                //   //skip
                                //   return Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.start,
                                //     children: [
                                //       Expanded(
                                //         child: Text(
                                //           'Due amount viewing option not available for this bill.',
                                //           style:f
                                //               kBlackExtraSmallLightMediumStyle,
                                //         ),
                                //       ),
                                //       Container(
                                //         height: 24,
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 0, vertical: 3),
                                //         // decoration: BoxDecoration(
                                //         //     borderRadius: BorderRadius.circular(5),
                                //         //     color: kRedBtnColor1),
                                //         child: Text(
                                //           '',
                                //           style: kWhiteSmallMediumStyle,
                                //         ),
                                //       ),
                                //     ],
                                //   );
                                // } else {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                        ? Expanded(
                                            child: StyledText(
                                              text: widget.allFavoritesData.lastTransactionStatus == 'SUCCESS'
                                                  ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                  : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                              textAlign: TextAlign.start,
                                              style: kBlackExtraSmallLightMediumStyle,
                                              tags: {
                                                'success': StyledTextActionTag(
                                                  (_, attrs) {},
                                                  style: kPrimaryExtraSmallDarkMediumStyle,
                                                ),
                                                'fail': StyledTextActionTag(
                                                  (_, attrs) {},
                                                  style: kRedExtraSmallDarkMediumStyle,
                                                ),
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Due: ',
                                      style: kBlackSmallLightMediumStyle,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _futureOutstandingBill = getOutstandingBill({
                                          "product_id": "${widget.allFavoritesData.productId}",
                                          // "country": "MY",
                                          "account_number": widget.allFavoritesData.accountNumber
                                        });
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 24,
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                        child: Text(
                                          'RM ${snapshot.data!.bill!.outstandingAmount}',
                                          style: kWhiteSmallMediumStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                // }
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Due amount currently unavailable.',
                                      style: kBlackExtraSmallLightMediumStyle,
                                    ),
                                  ),
                                  Container(
                                    height: 24,
                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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
                            },
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                  ? StyledText(
                                      text: widget.allFavoritesData.lastTransactionStatus == 'SUCCESS'
                                          ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                          : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                      textAlign: TextAlign.start,
                                      style: kBlackExtraSmallLightMediumStyle,
                                      tags: {
                                        'success': StyledTextActionTag(
                                          (_, attrs) {},
                                          style: kPrimaryExtraSmallDarkMediumStyle,
                                        ),
                                        'fail': StyledTextActionTag(
                                          (_, attrs) {},
                                          style: kRedExtraSmallDarkMediumStyle,
                                        ),
                                      },
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                  ]),
                ),
                const SizedBox(height: 25),
                // SizedBox(
                //   height: 100,
                //   // foregroundDecoration:
                //   //     phoneNoController.text.trim().isEmpty ||
                //   //             isChooseAmt
                //   //         ? const BoxDecoration(
                //   //             color: Colors.white60,
                //   //           )
                //   //         : const BoxDecoration(),
                //   child: FutureBuilder<TopUpAmounts?>(
                //     future: _futureTopUpAmts,
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return const Center(
                //           child: SizedBox(
                //             height: 25,
                //             child: LoadingIndicator(
                //               indicatorType: Indicator.lineScalePulseOut,
                //               colors: [
                //                 kAccentColor,
                //               ],
                //             ),
                //           ),
                //         );
                //       }
                //       if (snapshot.data == null) {
                //         return const SizedBox();
                //       }
                //       if (snapshot.data!.amounts!.isEmpty) {
                //         return Center(
                //           child: Text(
                //             'No Amounts Found!',
                //             style: kBlackMediumStyle,
                //           ),
                //         );
                //       }

                //       if (selectedAmt == -1) {
                //         if (widget.allFavoritesData.amount
                //             .toString()
                //             .isNotEmpty) {
                //           for (var i = 0;
                //               i < snapshot.data!.amounts!.length;
                //               i++) {
                //             if (snapshot.data!.amounts![i].amount ==
                //                 widget.allFavoritesData.amount) {
                //               selectedAmt = i;
                //               break;
                //             }
                //           }
                //         }
                //       }

                //       return Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text(
                //                 'Selected Amount:',
                //                 style: kBlackMediumStyle,
                //               ),
                //               const SizedBox(
                //                 width: 10,
                //               ),
                //               Expanded(
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.end,
                //                   children: [
                //                     Container(
                //                       width: 22,
                //                       height: 22,
                //                       padding: const EdgeInsets.all(5),
                //                       decoration: BoxDecoration(
                //                         boxShadow: [
                //                           BoxShadow(
                //                             color:
                //                                 Colors.black.withOpacity(0.1),
                //                             blurRadius: 5,
                //                             spreadRadius: 1,
                //                           ),
                //                         ],
                //                         color: kWhite,
                //                         // color: kWhite,
                //                         borderRadius:
                //                             BorderRadius.circular(100),
                //                       ),
                //                       child: Center(
                //                         child: Image.asset(
                //                           'assets/icons/ic_cashback.png',
                //                           width: 12,
                //                           height: 12,
                //                         ),
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       width: 10,
                //                     ),
                //                     Row(
                //                       children: [
                //                         Text(
                //                           'Cash Back: ',
                //                           style: kBlackSmallMediumStyle,
                //                         ),
                //                         Text(
                //                           selectedAmt == -1
                //                               ? 'RM 0.00'
                //                               : '${snapshot.data!.amounts![selectedAmt].currency} ${snapshot.data!.amounts![selectedAmt].cashbackAmount}',
                //                           style: kPrimarySmallDarkMediumStyle,
                //                         ),
                //                       ],
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //           const SizedBox(
                //             height: 15,
                //           ),
                //           SizedBox(
                //             height: 60,
                //             // width: double.infinity,
                //             child: ListView.separated(
                //               scrollDirection: Axis.horizontal,
                //               padding: const EdgeInsets.symmetric(
                //                   vertical: 7, horizontal: 10),
                //               itemBuilder: (context, index) {
                //                 return GestureDetector(
                //                   onTap: () {
                //                     setStateSheetRecent(() {
                //                       selectedAmt = index;
                //                       amount = snapshot
                //                           .data!.amounts![selectedAmt].amount
                //                           .toString();
                //                       cashbackAmt = snapshot.data!
                //                           .amounts![selectedAmt].cashbackAmount
                //                           .toString();
                //                     });
                //                   },
                //                   child: Container(
                //                     width: 90,
                //                     height: 40,
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 10, vertical: 5),
                //                     decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.circular(12),
                //                       color: kWhite,
                //                       border: selectedAmt == index
                //                           ? Border.all(
                //                               color: kColorPrimary,
                //                               width: 1.5,
                //                             )
                //                           : const Border(),
                //                       gradient: selectedAmt == index
                //                           ? const LinearGradient(
                //                               begin: Alignment.topCenter,
                //                               end: Alignment.bottomCenter,
                //                               colors: [
                //                                 kGreenBtnColor1,
                //                                 kGreenBtnColor2,
                //                               ],
                //                             )
                //                           : null,
                //                       boxShadow: [
                //                         BoxShadow(
                //                           color: selectedAmt == index
                //                               ? kColorPrimary.withOpacity(0.4)
                //                               : Colors.black.withOpacity(0.2),
                //                           blurRadius: 6,
                //                           spreadRadius: 2,
                //                         ),
                //                       ],
                //                     ),
                //                     child: Center(
                //                       child: Text(
                //                         '${topUpAmounts.amounts![index].currency} ${topUpAmounts.amounts![index].amount}',
                //                         style: selectedAmt == index
                //                             ? kWhiteDarkMediumStyle
                //                             : kBlackLightMediumStyle,
                //                       ),
                //                     ),
                //                   ),
                //                 );
                //               },
                //               separatorBuilder: (context, index) =>
                //                   const SizedBox(
                //                 width: 15,
                //               ),
                //               itemCount: snapshot.data!.amounts!.length,
                //             ),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Amount:',
                            style: kBlackMediumStyle,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    color: kWhite,
                                    // color: kWhite,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/ic_cashback.png',
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Cash Back: ',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                    Text(
                                      selectedAmt == -1 ? 'RM 0.00' : '${widget.allFavoritesData.amounts![selectedAmt].currency} ${widget.allFavoritesData.amounts![selectedAmt].cashbackAmount}',
                                      style: kPrimarySmallDarkMediumStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 60,
                        // width: double.infinity,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setStateSheetRecent(() {
                                  selectedAmt = index;
                                  amount = widget.allFavoritesData.amounts![selectedAmt].minAmount.toString();
                                  cashbackAmt = widget.allFavoritesData.amounts![selectedAmt].cashbackAmount.toString();
                                });
                              },
                              child: Container(
                                width: 90,
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: kWhite,
                                  border: selectedAmt == index
                                      ? Border.all(
                                          color: kColorPrimary,
                                          width: 1.5,
                                        )
                                      : const Border(),
                                  gradient: selectedAmt == index
                                      ? const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            kGreenBtnColor1,
                                            kGreenBtnColor2,
                                          ],
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: selectedAmt == index ? kColorPrimary.withOpacity(0.4) : Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.allFavoritesData.amounts![index].currency} ${widget.allFavoritesData.amounts![index].minAmount}',
                                    style: selectedAmt == index ? kWhiteDarkMediumStyle : kBlackLightMediumStyle,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 15,
                          ),
                          itemCount: widget.allFavoritesData.amounts!.length,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Payment Method:',
                  textAlign: TextAlign.start,
                  style: kBlackMediumStyle,
                ),
                const SizedBox(height: 20),
                GetX<UserProfileController>(
                  init: userProfileController,
                  builder: (_) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                kColorPrimary,
                                kColorPrimaryDark,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                child: Image.asset(
                                  'assets/images/wallet/wallet_bg_shapes.png',
                                  width: Get.width * 0.3,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Main Wallet',
                                            style: kWhiteDarkMediumStyle,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/logo/logo_full.svg',
                                            width: Get.width * 0.2,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Balance',
                                            style: kWhiteDarkMediumStyle,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
                                            style: kWhiteDarkSuperLargeStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
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
                          text: 'Top Up Now',
                          width: false,
                          widthSize: Get.width * 0.7,
                          buttonState: ButtonState.idle,
                          onTap: () {
                            if (selectedAmt == -1) {
                              errorSnackbar(title: 'Failed', subtitle: 'Please select the amount');
                              return;
                            }
                            Get.back();

                            if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < double.parse(widget.allFavoritesData.amounts![selectedAmt].minAmount.toString())) {
                              lowWalletBalanceDialog(
                                  onTap: () {
                                    Get.back();
                                    Get.to(() => const MainWalletReloadScreen());
                                  },
                                  image: 'assets/icons/ic_low_wallet_balance.png',
                                  context: context);
                            } else {
                              processTopupRecent(widget.allFavoritesData.amounts![selectedAmt].minAmount, widget.allFavoritesData.productId!, widget.allFavoritesData.accountNumber!);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  processTopupRecent(
    dynamic amt,
    String productId,
    String accountNo,
  ) async {
    processingDialog(title: 'Processing topup.. Please wait!', context: context);

    var res = await topUpController.initiateTopUp({"amount": amt, "product_id": productId, "account_number": accountNo});

    Get.back();
    widget.allFavoritesData.lastTransactionTimestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()).toString();
    if (res!.isEmpty) {
      widget.allFavoritesData.lastTransactionStatus = 'PENDING'; //PENDING SUCCESS
    } else {
      widget.allFavoritesData.lastTransactionStatus = 'FAILED';
    }

    if (res.isEmpty) {
      //done

      // walletController.getTransactionHistory({});
      // walletController.getEarningHistory();
      walletController.getWalletBalance({});
      walletController.getMainWalletReload({});
      userProfileController.updateUserDetails();

      favoriteController.getAllFavorites({});
      topUpController.getRecentTopUp({});

      showFavCompletedDialog(context: context);
    } else {
      if (res == "This Product is Currently Unavailable") {
        Get.back();
        favoriteCloseDialog(
            title: 'Payment for this product is temporarily unavailable',
            subtitle: "We are updating our system and are unsure how long it will take to fix.",
            image: 'assets/images/exclaim.png',
            buttonTitle: 'OK',
            context: context);
      } else if (res == "Server Maintenance InProgress") {
        Get.back();
        Get.to(() => const CustomServerUpgradeScreen());
      } else {
        errorSnackbar(title: 'Failed', subtitle: res);
      }
      //error
      // print(res.toString());
    }
  }

  String buildProcessingText() {
    return '<widget>';
  }

  String buildProcessingText2() {
    return '<widget>';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        if (widget.allFavoritesData.type == 'TOPUP') {
          // _futureTopUpAmts = getTopUpAmounts(
          //     {"product_id": "${widget.allFavoritesData.productId}"});
          showTopupSheetRecent();
        } else {
          // _futureBillPaymentAmts = getBillPaymentAmounts({
          //   "product_id": "${widget.allFavoritesData.productId}",
          //   "country": "MY",
          //   "account_number": widget.allFavoritesData.accountNumber
          // });
          showBillPaymentSheet();
        }
      },
      child: Slidable(
        key: widget.key,
        direction: Axis.horizontal,
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.45,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ProductTransactionHistoryScreen(
                            allFavoritesData: widget.allFavoritesData,
                          ));
                    },
                    child: Container(
                      width: Get.width * 0.39,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ],
                        color: const Color(0xffF2F1F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/favorite/transaction_history.png',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Transaction History',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kBlackExtraSmallMediumStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onEdit,
                        child: Container(
                          width: Get.width * 0.18,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 0,
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
                                height: 3,
                              ),
                              Text(
                                'Edit',
                                style: kBlackExtraSmallMediumStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      GestureDetector(
                        onTap: widget.onDelete,
                        child: Container(
                          width: Get.width * 0.18,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                spreadRadius: 0,
                              ),
                            ],
                            color: const Color(0xffF2F1F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/ic_remove.png',
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Remove',
                                style: kBlackExtraSmallMediumStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: Get.width,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                spreadRadius: 0,
              ),
            ],
            color: kWhite,
            borderRadius: BorderRadius.circular(12),
            // only(
            //   bottomLeft: Radius.circular(12),
            //   topLeft: Radius.circular(12),
            //   bottomRight: Radius.circular(12),
            //   topRight: Radius.circular(12),
            // ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CachedNetworkImage(
                            //   fit: BoxFit.contain,
                            //   width: 50,
                            //   height: 50,
                            //   imageUrl: "${widget.allFavoritesData.productImage}",
                            //   placeholder: (context, url) {
                            //     return Padding(
                            //       padding: const EdgeInsets.only(top: 35),
                            //       child: Text(
                            //         overflow: TextOverflow.ellipsis,
                            //         '${widget.allFavoritesData.nickName}',
                            //         textAlign: TextAlign.center,
                            //         style: kBlackExtraSmallLightMediumStyle.copyWith(
                            //           fontSize: 10.5,
                            //           fontWeight: FontWeight.w400,
                            //           color: Colors.black.withOpacity(0.3),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   errorWidget: (context, error, stackTrace) {
                            //     return Shimmer.fromColors(
                            //               baseColor: Colors.grey.shade200,
                            //               highlightColor: Colors.grey.shade50,
                            //               child: Container(
                            //                 height: 30,
                            //                 width: 30,
                            //                 margin: EdgeInsets.symmetric(horizontal: 5),
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: BorderRadius.circular(12),
                            //                   image: DecorationImage(
                            //                       image: Image.asset(
                            //                     'assets/images/logo/parrot_logo.png',
                            //                     fit: BoxFit.cover,
                            //                     color: Colors.grey,
                            //                     height: 30,
                            //                     width: 30,
                            //                   ).image),
                            //                 ),
                            //               ),
                            //             );
                            //   },
                            // ),

                            /// 1-10-24
                            CachedNetworkImage(
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                              imageUrl: '${widget.allFavoritesData.productImage}',
                              placeholder: (context, url) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.grey.shade50,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                          image: Image.asset(
                                        'assets/images/logo/parrot_logo.png',
                                        fit: BoxFit.cover,
                                        color: Colors.grey,
                                        height: 30,
                                        width: 30,
                                      ).image),
                                    ),
                                  ),
                                );
                                // return Image.asset(
                                //   'assets/images/logo/parrot_logo.png',
                                //   fit: BoxFit.contain,
                                //   height: 50,
                                //   width: 50,
                                // );
                              },
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/logo/parrot_logo.png',
                                  fit: BoxFit.contain,
                                );
                              },
                            ),

                            ///
                            // CachedNetworkImage(
                            //     imageUrl: widget.allFavoritesData.productImage.toString(),
                            //     errorWidget: (context, url, error) {
                            //       return Padding(
                            //         padding: const EdgeInsets.all(4.0),
                            //         // child: Image.asset("assets/images/logo/parrot_logo.png"),
                            //         child: Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white)),
                            //       );
                            //     },
                            //     placeholder: (c, s) {
                            //       return Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white));
                            //     })

                            // Image.network(
                            //   '${widget.allFavoritesData.productImage}',
                            //   fit: BoxFit.contain,
                            //   width: 50,
                            //   height: 50,
                            //   errorBuilder: (context, error, stackTrace) => Image.asset(
                            //     'assets/images/logo/parrot_logo.png',
                            //     fit: BoxFit.contain,
                            //     width: 50,
                            //     height: 50,
                            //   ),
                            // ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.allFavoritesData.nickName ?? 'NA',
                                    style: kBlackMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    '${widget.allFavoritesData.productName}',
                                    style: kBlackExtraSmallMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    widget.allFavoritesData.accountNumber != null
                                        ? widget.allFavoritesData.accountNumber!.contains('+6-')
                                            ? widget.allFavoritesData.accountNumber!.split('+6-')[1]
                                            : widget.allFavoritesData.accountNumber!
                                        : 'NA',
                                    style: kBlackExtraSmallMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 0.30,
                        ),
                        widget.allFavoritesData.hasOutstandingAmount!
                            ? FutureBuilder<OutstandingBill?>(
                                future: _futureOutstandingBill,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                            ? Obx(() {
                                                return Expanded(
                                                  child: StyledText(
                                                    text: favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'SUCCESS'
                                                        ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                        : favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                                            ? '<processing>Processing</processing> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                            : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                                    textAlign: TextAlign.start,
                                                    style: kBlackExtraSmallLightMediumStyle,
                                                    tags: {
                                                      'success': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kPrimaryExtraSmallDarkMediumStyle,
                                                      ),
                                                      'processing': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kYellowExtraSmallDarkMediumStyle,
                                                      ),
                                                      'fail': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kRedExtraSmallDarkMediumStyle,
                                                      ),
                                                    },
                                                  ),
                                                );
                                              })
                                            : const Expanded(
                                                child: SizedBox(),
                                              ),
                                        Container(
                                          height: 24,
                                          width: 40,
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                          child: const LoadingIndicator(
                                            indicatorType: Indicator.lineScalePulseOut,
                                            colors: [
                                              kWhite,
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  if (snapshot.data == null) {
                                    return const SizedBox();
                                  }
                                  if (snapshot.data!.status != 200) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                            ? Container(
                                                width: 60,
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.yellow.shade500,
                                                  highlightColor: Colors.yellow.shade50,
                                                  child: Text(
                                                    "Processing",
                                                    style: kYellowExtraSmallDarkMediumStyle,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                            ? Obx(() {
                                                return Expanded(
                                                  child: StyledText(
                                                    text: favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'SUCCESS'
                                                        ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                        : favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                                            // ? '<processing>Processing11111</processing> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                            ? '<processing>${buildProcessingText()}</processing> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                            : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                                    textAlign: TextAlign.start,
                                                    style: kBlackExtraSmallLightMediumStyle,
                                                    tags: {
                                                      'success': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kPrimaryExtraSmallDarkMediumStyle,
                                                      ),
                                                      'processing': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kBlackExtraSmallLightMediumStyle,
                                                      ),
                                                      'fail': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kRedExtraSmallDarkMediumStyle,
                                                      ),
                                                    },
                                                  ),
                                                );
                                              })
                                            : Expanded(
                                                child: Text(
                                                  'Due amount currently unavailable.',
                                                  style: kBlackExtraSmallLightMediumStyle,
                                                ),
                                              ),
                                        GestureDetector(
                                          onTap: () {
                                            _futureOutstandingBill = getOutstandingBill({
                                              "product_id": "${widget.allFavoritesData.productId}",
                                              // "country": "MY",
                                              "account_number": widget.allFavoritesData.accountNumber
                                            });

                                            checkReloadCount();
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 24,
                                            width: 50,
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                            child: const Icon(
                                              Icons.replay_outlined,
                                              color: kWhite,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  if (snapshot.data!.bill == null) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                            ? Obx(() {
                                                return Expanded(
                                                  child: StyledText(
                                                    text: favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'SUCCESS'
                                                        ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                        : favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                                            ? '<processing>Processing</processing> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                            : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                                    textAlign: TextAlign.start,
                                                    style: kBlackExtraSmallLightMediumStyle,
                                                    tags: {
                                                      'success': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kPrimaryExtraSmallDarkMediumStyle,
                                                      ),
                                                      'processing': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kYellowExtraSmallDarkMediumStyle,
                                                      ),
                                                      'fail': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kRedExtraSmallDarkMediumStyle,
                                                      ),
                                                    },
                                                  ),
                                                );
                                              })
                                            : Expanded(
                                                child: Text(
                                                  'Due amount currently unavailable.',
                                                  style: kBlackExtraSmallLightMediumStyle,
                                                ),
                                              ),
                                        GestureDetector(
                                          onTap: () {
                                            _futureOutstandingBill = getOutstandingBill({
                                              "product_id": "${widget.allFavoritesData.productId}",
                                              // "country": "MY",
                                              "account_number": widget.allFavoritesData.accountNumber
                                            });

                                            checkReloadCount();

                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 24,
                                            width: 50,
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                            child: const Icon(
                                              Icons.replay_outlined,
                                              color: kWhite,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  if (snapshot.data!.bill != null && outstandingBill != null) {
                                    // if (!snapshot.data!.bill!.outstandingAmount!
                                    //     .contains('-')) {
                                    //   //skip
                                    //   return Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     children: [
                                    //       Expanded(
                                    //         child: Text(
                                    //           'Due amount viewing option not available for this bill.',
                                    //           style:
                                    //               kBlackExtraSmallLightMediumStyle,
                                    //         ),
                                    //       ),
                                    //       Container(
                                    //         height: 24,
                                    //         padding: const EdgeInsets.symmetric(
                                    //             horizontal: 0, vertical: 3),
                                    //         // decoration: BoxDecoration(
                                    //         //     borderRadius: BorderRadius.circular(5),
                                    //         //     color: kRedBtnColor1),
                                    //         child: Text(
                                    //           '',
                                    //           style: kWhiteSmallMediumStyle,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   );
                                    // } else {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                            ? Obx(() {
                                                return Expanded(
                                                  child: StyledText(
                                                    text: favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'SUCCESS'
                                                        ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                        : favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                                            ? '<processing>Processing</processing> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                            : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                                    textAlign: TextAlign.start,
                                                    style: kBlackExtraSmallLightMediumStyle,
                                                    tags: {
                                                      'success': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kPrimaryExtraSmallDarkMediumStyle,
                                                      ),
                                                      'processing': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kYellowExtraSmallDarkMediumStyle,
                                                      ),
                                                      'fail': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kRedExtraSmallDarkMediumStyle,
                                                      ),
                                                    },
                                                  ),
                                                );
                                              })
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Due: ',
                                          style: kBlackSmallLightMediumStyle,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _futureOutstandingBill = getOutstandingBill({
                                              "product_id": "${widget.allFavoritesData.productId}",
                                              // "country": "MY",
                                              "account_number": widget.allFavoritesData.accountNumber
                                            });

                                            checkReloadCount();

                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 24,
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                            child: Text(
                                              'RM ${snapshot.data!.bill!.outstandingAmount}',
                                              style: kWhiteSmallMediumStyle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                    // }
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Due amount currently unavailable.',
                                          style: kBlackExtraSmallLightMediumStyle,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _futureOutstandingBill = getOutstandingBill({
                                            "product_id": "${widget.allFavoritesData.productId}",
                                            // "country": "MY",
                                            "account_number": widget.allFavoritesData.accountNumber
                                          });

                                          checkReloadCount();

                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 24,
                                          width: 50,
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                          child: const Icon(
                                            Icons.replay_outlined,
                                            color: kWhite,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                      ? Container(
                                          width: 60,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.yellow.shade500,
                                            highlightColor: Colors.yellow.shade50,
                                            child: Text(
                                              "Processing",
                                              style: kYellowExtraSmallDarkMediumStyle,
                                            ),
                                            // Container(
                                            //   height: 30,
                                            //   width: 30,
                                            //   margin: EdgeInsets.symmetric(horizontal: 5),
                                            //   decoration: BoxDecoration(
                                            //     borderRadius: BorderRadius.circular(12),
                                            //     image: DecorationImage(
                                            //         image: Image.asset(
                                            //           'assets/images/logo/parrot_logo.png',
                                            //           fit: BoxFit.cover,
                                            //           color: Colors.grey,
                                            //           height: 30,
                                            //           width: 30,
                                            //         ).image),
                                            //   ),
                                            // ),
                                          ),
                                          // AnimatedTextKit(
                                          //   totalRepeatCount: 20,
                                          //   isRepeatingAnimation: true,
                                          //   animatedTexts: [
                                          //     TyperAnimatedText(
                                          //       'Processing',
                                          //       textStyle: kYellowExtraSmallDarkMediumStyle,
                                          //     ),
                                          //   ],
                                          // ),
                                        )
                                      : Container(),
                                  widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                      ? Obx(() {
                                          return Expanded(
                                            child: StyledText(
                                              text: favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'SUCCESS' // ParrotPosssss
                                                  ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                  : favoriteController.allFavorites!.value.data![widget.index].lastTransactionStatus == 'PENDING'
                                                      ? '<processing>${buildProcessingText2()}</processing> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                      : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                              textAlign: TextAlign.start,
                                              style: kBlackExtraSmallLightMediumStyle,
                                              tags: {
                                                'success': StyledTextActionTag(
                                                  (_, attrs) {},
                                                  style: kPrimaryExtraSmallDarkMediumStyle,
                                                ),
                                                'processing': StyledTextActionTag(
                                                  (_, attrs) {},
                                                  style: kBlackExtraSmallLightMediumStyle,
                                                ),
                                                'fail': StyledTextActionTag(
                                                  (_, attrs) {},
                                                  style: kRedExtraSmallDarkMediumStyle,
                                                ),
                                              },
                                            ),
                                          );
                                        })
                                      : widget.allFavoritesData.type != 'TOPUP'
                                          ? Text(
                                              'Due amount view not available for this product.',
                                              style: kBlackExtraSmallLightMediumStyle,
                                            )
                                          : SizedBox(),

                                  // GestureDetector(
                                  //   onTap: () {
                                  //     _futureOutstandingBill = getOutstandingBill({
                                  //       "product_id": "${widget.allFavoritesData.productId}",
                                  //       // "country": "MY",
                                  //       "account_number": widget.allFavoritesData.accountNumber
                                  //     });
                                  //
                                  //     checkReloadCount();
                                  //     setState(() {});
                                  //   },
                                  //   child: Container(
                                  //     height: 24,
                                  //     width: 50,
                                  //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                  //     child: const Icon(
                                  //       Icons.replay_outlined,
                                  //       color: kWhite,
                                  //       size: 15,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 114,
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

class ShowBillPaymentCard extends StatefulWidget {
  final AllFavoritesData allFavoritesData;
  const ShowBillPaymentCard({
    super.key,
    required this.allFavoritesData,
  });

  @override
  State<ShowBillPaymentCard> createState() => _ShowBillPaymentCardState();
}

class _ShowBillPaymentCardState extends State<ShowBillPaymentCard> {
  TextEditingController amountController = TextEditingController();
  bool isExceed = false;
  final UserProfileController userProfileController = Get.find();
  final FavoriteController favoriteController = Get.find();
  Future<OutstandingBill?>? _futureOutstandingBill;
  String cashbackAmt = '0.00';
  OutstandingBill? outstandingBill;
  final BillPaymentController billPaymentController = Get.find();
  ButtonState btnState = ButtonState.idle;
  WalletController walletController = Get.find();
  final TopUpController topUpController = Get.find();

  Future<OutstandingBill?> getOutstandingBill(Map map) async {
    if (map.isEmpty) {
      return null;
    }
    var res = await favoriteController.getOutstandingBill(map);
    print("----- RES IS ${res.toJson()}");
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

  final FocusNode favorite = FocusNode();
  @override
  void dispose() {
    favorite.dispose();
    super.dispose();
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(favorite);
    });
    if (widget.allFavoritesData.hasOutstandingAmount!) {
      _futureOutstandingBill = getOutstandingBill({
        "product_id": "${widget.allFavoritesData.productId}",
        // "country": "MY",
        "account_number": widget.allFavoritesData.accountNumber
      });
    }
    print("this function is called");

    // reloadProcceingStatus();
    super.initState();
  }

  int dueAmtReloadCount = 0;
  SharedPreferences? sharedPreferences;
  checkReloadCount() async {
    dueAmtReloadCount++;

    var res = sharedPreferences!.getBool('outstanding_amt');
    if (res != null) {
      if (res) {
        print('DONT SHOW');
        //dont show
        // if (dueAmtReloadCount > 2) {
        //show warning
        // await showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const OutstandingAmtNaDialog();
        //   },
        // );
        // }
      } else {
        print('SHOW');

        //show
        if (dueAmtReloadCount > 2) {
          //show warning
          await showDialog(
            context: context,
            builder: (context) {
              return const OutstandingAmtNaDialog();
            },
          );
        }
      }
    } else {
      print('SHOW');

      //show
      if (dueAmtReloadCount > 2) {
        //show warning
        await showDialog(
          context: context,
          builder: (context) {
            return const OutstandingAmtNaDialog();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
        return SingleChildScrollView(
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 7,
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 1.5,
                        color: Colors.black26,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 2,
                          ),
                        ],
                        color: kWhite,
                        // color: kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.black.withOpacity(0.1),
                                  //     blurRadius: 5,
                                  //     spreadRadius: 1,
                                  //   ),
                                  // ],
                                  color: kWhite,
                                  // color: kWhite,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: kWhite,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    // child: CachedNetworkImage(
                                    //     imageUrl: widget.allFavoritesData.productImage.toString(),
                                    //     errorWidget: (context, url, error) {
                                    //       return Padding(
                                    //         padding: const EdgeInsets.all(4.0),
                                    //         // child: Image.asset("assets/images/logo/parrot_logo.png"),
                                    //         child: Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white)),
                                    //       );
                                    //     },
                                    //     placeholder: (c, s) {
                                    //       return Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white));
                                    //     })
                                    child: (widget.allFavoritesData.productImage?.isEmpty ?? true)
                                        ? Image.asset(
                                            'assets/images/logo/parrot_logo.png',
                                            width: 30,
                                            height: 30,
                                          )
                                        : Image.network(
                                            widget.allFavoritesData.productImage ?? '',
                                            errorBuilder: (context, error, stackTrace) => Image.asset(
                                              'assets/images/logo/parrot_logo.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${widget.allFavoritesData.nickName}',
                                      style: kBlackMediumStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${widget.allFavoritesData.productName}',
                                      style: kBlackExtraSmallLightMediumStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      widget.allFavoritesData.accountNumber!,
                                      style: kBlackExtraSmallLightMediumStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.30),
                          widget.allFavoritesData.hasOutstandingAmount!
                              ? FutureBuilder<OutstandingBill?>(
                                  future: _futureOutstandingBill,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                            child: const LoadingIndicator(
                                              indicatorType: Indicator.lineScalePulseOut,
                                              colors: [
                                                kWhite,
                                              ],
                                            ),
                                          ),
                                        ],
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
                                              'Due amount currently unavailable.',
                                              style: kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ),
                                          Container(
                                            height: 24,

                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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
                                              'Due amount currently unavailable.',
                                              style: kBlackExtraSmallLightMediumStyle,
                                            ),
                                          ),
                                          Container(
                                            height: 24,
                                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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

                                    if (snapshot.data!.bill != null && outstandingBill != null) {
                                      // if (!snapshot.data!.bill!.outstandingAmount!
                                      //     .contains('-')) {
                                      //   //skip
                                      //   return Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: [
                                      //       Expanded(
                                      //         child: Text(
                                      //           'Due amount viewing option not available for this bill.',
                                      //           style:
                                      //               kBlackExtraSmallLightMediumStyle,
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         height: 24,
                                      //         padding: const EdgeInsets.symmetric(
                                      //             horizontal: 0, vertical: 3),
                                      //         // decoration: BoxDecoration(
                                      //         //     borderRadius: BorderRadius.circular(5),
                                      //         //     color: kRedBtnColor1),
                                      //         child: Text(
                                      //           '',
                                      //           style: kWhiteSmallMediumStyle,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   );
                                      // } else {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                              ? Expanded(
                                                  child: StyledText(
                                                    text: widget.allFavoritesData.lastTransactionStatus == 'SUCCESS'
                                                        ? 'Payment <success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                        : 'Payment <fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                                    textAlign: TextAlign.center,
                                                    style: kBlackExtraSmallLightMediumStyle,
                                                    tags: {
                                                      'success': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kPrimaryExtraSmallDarkMediumStyle,
                                                      ),
                                                      'fail': StyledTextActionTag(
                                                        (_, attrs) {},
                                                        style: kRedExtraSmallDarkMediumStyle,
                                                      ),
                                                    },
                                                  ),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Due: ',
                                            style: kBlackSmallLightMediumStyle,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _futureOutstandingBill = getOutstandingBill({
                                                "product_id": "${widget.allFavoritesData.productId}",
                                                // "country": "MY",
                                                "account_number": widget.allFavoritesData.accountNumber
                                              });

                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 24,
                                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                              child: Text(
                                                'RM ${snapshot.data!.bill!.outstandingAmount}',
                                                style: kWhiteSmallMediumStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                      // }
                                    }
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Due amount currently unavailable.',
                                            style: kBlackExtraSmallLightMediumStyle,
                                          ),
                                        ),
                                        Container(
                                          height: 24,
                                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
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
                                  },
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.allFavoritesData.lastTransactionStatus!.isNotEmpty
                                        ? StyledText(
                                            text: widget.allFavoritesData.lastTransactionStatus == 'SUCCESS'
                                                ? '<success>Successful</success> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}'
                                                : '<fail>Failed</fail> on ${CommonTools().getDateAndTime(widget.allFavoritesData.lastTransactionTimestamp!)}',
                                            textAlign: TextAlign.start,
                                            style: kBlackExtraSmallLightMediumStyle,
                                            tags: {
                                              'success': StyledTextActionTag(
                                                (_, attrs) {},
                                                style: kPrimaryExtraSmallDarkMediumStyle,
                                              ),
                                              'fail': StyledTextActionTag(
                                                (_, attrs) {},
                                                style: kRedExtraSmallDarkMediumStyle,
                                              ),
                                            },
                                          )
                                        : SizedBox(),
                                    // Expanded(
                                    //         child: Text(
                                    //           'Due amount view not available for this product.',
                                    //           style: kBlackExtraSmallLightMediumStyle,
                                    //         ),
                                    //       ),
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     _futureOutstandingBill = getOutstandingBill({
                                    //       "product_id": "${widget.allFavoritesData.productId}",
                                    //       // "country": "MY",
                                    //       "account_number": widget.allFavoritesData.accountNumber
                                    //     });
                                    //
                                    //     checkReloadCount();
                                    //     setState(() {});
                                    //   },
                                    //   child: Container(
                                    //     height: 24,
                                    //     width: 50,
                                    //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                    //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: kRedBtnColor1),
                                    //     child: const Icon(
                                    //       Icons.replay_outlined,
                                    //       color: kWhite,
                                    //       size: 15,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Amount',
                              style: kBlackMediumStyle,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/ic_cashback.png',
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Cash Back: ',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                    Text(
                                      '${widget.allFavoritesData.currency} $cashbackAmt',
                                      style: kPrimarySmallDarkMediumStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: isExceed ? Colors.red : Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    'RM',
                                    style: kBlackMediumStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 20,
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    // inputFormatters: <TextInputFormatter>[
                                    //   FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                                    // ],
                                    focusNode: favorite,
                                    textAlignVertical: TextAlignVertical.center,
                                    controller: amountController,
                                    onChanged: (value) {
                                      setState(() {});
                                      setBottomSheetState(() {
                                        if (value.trim().isEmpty) {
                                          cashbackAmt = '0.00';

                                          isExceed = false;

                                          return;
                                        }
                                        if (widget.allFavoritesData.amountType == 'INTEGER' && amountController.text.trim().contains('.')) {
                                          // Get.back();

                                          decimalNotAllowedDialog(context: context);
                                          amountController.text = value.replaceAll('.', '');
                                          amountController.selection = TextSelection.fromPosition(
                                            TextPosition(offset: amountController.text.length),
                                          );
                                          return;
                                        }
                                        //check min
                                        if (double.parse(value.trim()) < double.parse(widget.allFavoritesData.minimumAmount.toString())) {
                                          //make red

                                          isExceed = true;
                                        }
                                        //check max
                                        if (double.parse(value.trim()) > double.parse(widget.allFavoritesData.maximumAmount.toString())) {
                                          //make red

                                          isExceed = true;
                                        }

                                        if (double.parse(value.trim()) <= double.parse(widget.allFavoritesData.maximumAmount.toString())) {
                                          for (var item in widget.allFavoritesData.amounts!) {
                                            if (double.parse(value.trim()) >= double.parse(item.minAmount.toString()) && double.parse(value.trim()) <= double.parse(item.maxAmount.toString())) {
                                              print('${item.cashbackAmount}');
                                              cashbackAmt = item.cashbackAmount.toString();

                                              isExceed = false;

                                              return;
                                            }
                                          }
                                        }
                                      });

                                      // setState(() {
                                      //   if (double.parse(
                                      //               value.trim()) >=
                                      //           snapshot.data!.info!
                                      //               .minimumAmount &&
                                      //       double.parse(
                                      //               value.trim()) <=
                                      //           snapshot.data!.info!
                                      //               .maximumAmount) {
                                      //     for (var item in snapshot
                                      //         .data!.amounts!) {
                                      //       if (double.parse(
                                      //                   value.trim()) >=
                                      //               item.minAmount &&
                                      //           double.parse(
                                      //                   value.trim()) <=
                                      //               item.maxAmount) {
                                      //         cashbackAmt = item
                                      //             .cashbackAmount
                                      //             .toString();
                                      //         return;
                                      //       }
                                      //     }
                                      //   } else {
                                      //     errorSnackbar(
                                      //         title: 'Failed',
                                      //         subtitle:
                                      //             'You cannot exceed the max amount!');
                                      //   }
                                      // });
                                    },
                                    enableInteractiveSelection: true,
                                    style: kBlackMediumStyle,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                      helperStyle: kBlackSmallLightMediumStyle,
                                      errorStyle: kBlackSmallLightMediumStyle,
                                      hintStyle: kBlackSmallLightMediumStyle,
                                      // hintText: 'Min. 10 | Max. 10,000',
                                      labelStyle: kBlackSmallLightMediumStyle,
                                      fillColor: kWhite,
                                      filled: true,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(top: 15, left: 20),
                                        child: Text(
                                          'Min. ${double.parse(widget.allFavoritesData.minimumAmount).toInt()} | Max. ${double.parse(widget.allFavoritesData.maximumAmount).toInt()}',
                                          style: isExceed ? kRedSmallLightMediumStyle : kBlackSmallLightMediumStyle,
                                        ),
                                      ),
                                      // suffixIcon: amountController.text.trim().isNotEmpty
                                      //     ? Row(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         children: [
                                      //           Padding(
                                      //             padding: const EdgeInsets.only(left: 20),
                                      //             child: Text(
                                      //               'Min. 10 | Max. 10,000',
                                      //               style: kBlackSmallLightMediumStyle,
                                      //             ),
                                      //           ),
                                      //           const SizedBox(
                                      //             width: 10,
                                      //           ),
                                      //           Container(
                                      //             height: 20,
                                      //             color: Colors.black12,
                                      //             width: 1,
                                      //           ),
                                      //           GestureDetector(
                                      //             onTap: () => setState(() {
                                      //               amountController.text = '';
                                      //             }),
                                      //             child: const Icon(
                                      //               Icons.close,
                                      //               color: Colors.black38,
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       )
                                      //     : const SizedBox(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  height: 20,
                                  color: Colors.black12,
                                  width: 1,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    amountController.text = '';
                                  }),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.black38,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Payment Method:',
                      textAlign: TextAlign.start,
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GetX<UserProfileController>(
                      init: userProfileController,
                      builder: (_) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    kColorPrimary,
                                    kColorPrimaryDark,
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Image.asset(
                                      'assets/images/wallet/wallet_bg_shapes.png',
                                      width: Get.width * 0.3,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Main Wallet',
                                                style: kWhiteDarkMediumStyle,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SvgPicture.asset(
                                                'assets/images/logo/logo_full.svg',
                                                width: Get.width * 0.2,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Balance',
                                                style: kWhiteDarkMediumStyle,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
                                                style: kWhiteDarkSuperLargeStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
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
                              text: 'Pay Now',
                              width: false,
                              widthSize: Get.width * 0.7,
                              buttonState: ButtonState.idle,
                              onTap: () {
                                setState(() {});
                                if (amountController.text.isEmpty) {
                                  isExceed = true;
                                  errorSnackbar(title: 'Failed', subtitle: 'Please Enter Amount');
                                }
                                if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < double.parse(amountController.text.toString())) {
                                  Get.back();

                                  lowWalletBalanceDialog(
                                    image: 'assets/icons/ic_low_wallet_balance.png',
                                    context: context,
                                    onTap: () {
                                      Get.back();
                                      Get.to(() => const MainWalletReloadScreen());
                                    },
                                  );
                                  return;
                                } else if (widget.allFavoritesData.amountType == 'INTEGER' && amountController.text.trim().contains('.')) {
                                  Get.back();

                                  decimalNotAllowedDialog(context: context);
                                  return;
                                }
                                if (double.parse(amountController.text.trim()) < double.parse(widget.allFavoritesData.minimumAmount.toString()) ||
                                    double.parse(amountController.text.trim()) > double.parse(widget.allFavoritesData.maximumAmount.toString())) {
                                  errorSnackbar(title: 'Failed', subtitle: 'Payment amount should be Min. ${widget.allFavoritesData.minimumAmount} | Max. ${widget.allFavoritesData.maximumAmount}');
                                  return;
                                }

                                // favoriteClosDialog(
                                //     title: 'Payment for this product is temporarily unavailable',
                                //     subtitle: "We are updating our system and are unsure how long it will take to fix.",
                                //     image: 'assets/images/exclaim.png',
                                //     buttonTitle: 'ok',
                                //     context: context);

                                processBillPayment(amountController.text.trim());
                                Get.back();
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  processBillPayment(String amount) async {
    processingDialog(title: 'Processing bill payment.. Please wait!', context: context);

    if (mounted) {
      setState(() {
        btnState = ButtonState.loading;
      });
    }

    String? res;

    if (widget.allFavoritesData.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')) {
      //send phone no.
      res = await billPaymentController.initiateBillPayment({"amount": amount, "product_id": widget.allFavoritesData.productId, "account_number": widget.allFavoritesData.accountNumber!});
    } else {
      //send account no.
      res = await billPaymentController.initiateBillPayment({
        "amount": amount,
        "product_id": widget.allFavoritesData.productId,
        "account_number": widget.allFavoritesData.accountNumber,
        // "account_name": allFavoritesData..text.trim(),
      });
    }

    if (mounted) {
      setState(() {
        btnState = ButtonState.idle;
        widget.allFavoritesData.lastTransactionTimestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now()).toString();

        if (res!.isEmpty) {
          widget.allFavoritesData.lastTransactionStatus = 'PENDING';
        } else {
          widget.allFavoritesData.lastTransactionStatus = 'FAILED';
        }
      });
    }

    walletController.getTransactionHistory({});

    walletController.getEarningHistory();
    walletController.getWalletBalance({});
    walletController.getMainWalletReload({});
    userProfileController.updateUserDetails();

    favoriteController.getAllFavorites({});
    topUpController.getRecentTopUp({});

    Get.back();

    // while (widget.allFavoritesData.lastTransactionStatus == 'PENDING') {
    //   Future.delayed(const Duration(seconds: 5), () {});
    // }
    if (res!.isEmpty) {
      //done

      showFavCompletedDialog(
        context: context,
      );
    } else {
      print("----- HEY HEY ROMIL ${res}");

      if (res == "This Product is Currently Unavailable") {
        Get.back();
        favoriteCloseDialog(
            title: 'Payment for this product is temporarily unavailable',
            subtitle: "We are updating our system and are unsure how long it will take to fix.",
            image: 'assets/images/exclaim.png',
            buttonTitle: 'OK',
            context: context);
      } else if (res == "Server Maintenance InProgress") {
        Get.back();
        Get.to(() => const CustomServerUpgradeScreen());
      } else {
        Get.back();
        //error
        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }
}
