import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/main_wallet_reload.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_web_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/reload_failed_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';

import '../../screens/notification/server_maintainance_screen.dart';

class UserBankListItem extends StatefulWidget {
  final UserBank userBank;
  final int? minReloadAmount;
  final MainWalletUserDetails mainWalletUserDetails;
  const UserBankListItem({
    Key? key,
    required this.userBank,
    required this.mainWalletUserDetails,
    required this.minReloadAmount,
  }) : super(key: key);

  @override
  State<UserBankListItem> createState() => _UserBankListItemState();
}

class _UserBankListItemState extends State<UserBankListItem> with SingleTickerProviderStateMixin {
  TextEditingController amountController = TextEditingController();
  WalletController walletController = Get.find();
  UserProfileController userProfileController = Get.find();
  bool isRemoving = false;
  bool isAdding = false;
  bool isExceed = false;

  late AnimationController _controller;
  Animation<double>? _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);
  }

  void _shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  removeBank() async {
    var dialogRes = await deleteDialog(
      title: 'Are you sure to delete\n${widget.userBank.name} shortcut',
      buttonTitle: 'Yes',
      buttonTitle2: 'No',
      image: 'assets/icons/change_phone_dl.png',
      context: context,
      onTapNo: () {
        Get.back();
      },
      onTapYes: () async {
        Get.back();
        setState(() {
          isRemoving = true;
        });
        var res = await walletController.removeBankFromUserList({
          'fpx_bank_id': widget.userBank.fpxBankId,
        });

        setState(() {
          isRemoving = false;
        });

        if (res!.isEmpty) {
          //added

          List<UserBank> bankList = walletController.mainWalletReload.value.banks!;
          bankList.remove(widget.userBank);

          walletController.mainWalletReload.update((val) {
            val!.banks = bankList;
          });
          // walletController.getMainWalletReload({});
        } else {
          errorSnackbar(title: 'Failed', subtitle: res);
        }
      },
    );
  }

  addAmountToWallet() async {
    if (amountController.text.trim().isEmpty) {
      errorSnackbar(title: 'Failed', subtitle: 'Please specify the amount!');
      _shake();
      return;
    }
    if (int.parse(amountController.text.trim()) < double.parse(widget.minReloadAmount.toString())) {
      errorSnackbar(title: 'Failed', subtitle: 'Minimum amount of ${widget.mainWalletUserDetails.currency} ${widget.minReloadAmount} is required!');
      _shake();
      return;
    }
    setState(() {
      isAdding = true;
    });
    var res = await walletController.addAmountToMainWallet({
      "fpx_bank_id": widget.userBank.fpxBankId,
      "amount": int.parse(amountController.text.trim()),
    });
    log(res.toString());
    setState(() {
      isAdding = false;
    });

    if (res['status'] == 200) {
      //bill generated

      var result = await Get.to(() => MainWalletReloadWebScreen(url: res['bill']['others']['service_provider']['bill_url']));
      if (result != null) {
        if (result) {
          // userProfileController.userProfile.update((val) {
          //   val!.data!.mainWalletBalance +=
          //       100;
          // });
          // walletController.mainWalletReload.update((val) {
          //   int a =
          //   int.parse(val!.userDetails!.mainWalletAmount.toString()) ;
          //   a+= int.parse(amountController.text.trim());
          //   val.userDetails!.mainWalletAmount = a;

          // });
          userProfileController.updateUserDetails();

          walletController.updateMainWalletReload({});
          walletController.getWalletBalance({});
          UserProfileController().getUserDetails();
          walletController.getEarningWallet({});
          walletController.getEarningHistory();
          walletController.getTransactionHistory(
            {},
          );

          //successful
          taskCompletedDialog(title: 'Reload Successful.', buttonTitle: 'Close', image: 'assets/images/tick.png', context: context);
        } else {
          Get.to(() => const ServerMaintenanceScreen(screenName: "Reload Wallet"));
        }
      } else {
        errorSnackbar(title: 'Failed', subtitle: 'Reload cancelled by user!');
      }

      // walletController.mainWalletReload.update((val) {
      //   val!.banks = bankList;
      // });
      // await taskCompletedDialog(
      //     title: 'Reload Successful.',
      //     buttonTitle: 'Close',
      //     image: 'assets/images/tick.png',
      //     context: context);

      // walletController.getMainWalletReload({});
    } else {
      //failed
      Get.to(() => const ServerMaintenanceScreen(screenName: "Reload Wallet"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      // height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        // fit: StackFit.expand,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                    decoration: BoxDecoration(
                      color: CommonTools().getColor(widget.userBank.bgColor!),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CachedNetworkImage(
                      imageUrl: widget.userBank.logo ?? '',
                      placeholder: (context, url) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            '${widget.userBank.name ?? ''}',
                            style: kBlackExtraSmallLightMediumStyle,
                          ),
                        );
                      },
                      errorWidget: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/logo/parrot_logo.png',
                          fit: BoxFit.contain,
                        );
                      },
                      fit: BoxFit.contain,
                      width: 160,
                      height: 35,
                    )

                    ///1-10-24
                    // Image.network(
                    //   widget.userBank.logo ?? '',
                    //   width: 160,
                    //   height: 35,
                    //   fit: BoxFit.contain,
                    //   errorBuilder: (context, error, stackTrace) => Center(
                    //     child: Text(
                    //       '${widget.userBank.name}',
                    //       style: GoogleFonts.poppins(
                    //         fontSize: 12.0,
                    //         fontWeight: FontWeight.w500,
                    //         color: CommonTools().getColor(widget.userBank.fontColor!),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // height: 35,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    Config().currencyCode,
                                    style: kBlackDarkSuperLargeStyle.copyWith(fontSize: 25),
                                  ),
                                  // Container(
                                  //   margin: const EdgeInsets.symmetric(
                                  //       horizontal: 5),
                                  //   height: 20,
                                  //   color: Colors.black45,
                                  //   width: 0.5,
                                  // ),
                                  Expanded(
                                    child: SizedBox(
                                      // width: 140,
                                      // height: 36,
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: amountController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp('[0-9 .]')),
                                        ],
                                        onChanged: (value) {
                                          if (value.trim().isEmpty) {
                                            setState(() {
                                              isExceed = false;
                                            });
                                          } else {
                                            if (double.parse(value.trim().toString()) < double.parse(widget.minReloadAmount.toString())) {
                                              setState(() {
                                                isExceed = true;
                                                _shake();
                                              });
                                            } else {
                                              setState(() {
                                                isExceed = false;
                                              });
                                            }
                                          }
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(0),
                                        ),
                                        style: kBlackSuperLargeStyle,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(endIndent: 10, height: 4),
                            const SizedBox(height: 5),
                            AnimatedBuilder(
                              animation: _animation!,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset((_animation?.value ?? 0) - 5, 0),
                                  child: child,
                                );
                              },
                              child: Text(
                                'Minimum Amount: ${widget.mainWalletUserDetails.currency} ${widget.minReloadAmount}.00',
                                // 'Minimum Amount: ${widget.userBank}',
                                textAlign: TextAlign.start,
                                style: isExceed ? kRedExtraSmallLightMediumStyle.copyWith(fontWeight: FontWeight.w700) : kBlackExtraSmallLightMediumStyle.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       addAmountToWallet();
                    //     },
                    //     child: Container(
                    //       margin: const EdgeInsets.only(bottom: 5, right: 5),
                    //       decoration: BoxDecoration(
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black.withOpacity(0.15),
                    //             blurRadius: 4,
                    //             spreadRadius: 1,
                    //           ),
                    //         ],
                    //         color: const Color(0xffF6F6F6),
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    //       child: isAdding
                    //           ? const SizedBox(
                    //               height: 22,
                    //               child: Center(
                    //                 child: LoadingIndicator(
                    //                   indicatorType: Indicator.lineScalePulseOut,
                    //                   colors: [
                    //                     kAccentColor,
                    //                   ],
                    //                 ),
                    //               ),
                    //             )
                    //           : Row(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 const SizedBox(),
                    //                 Text(
                    //                   'Add',
                    //                   style: kBlackMediumStyle.copyWith(fontWeight: FontWeight.bold),
                    //                 ),
                    //                 const Icon(
                    //                   Icons.arrow_forward_ios,
                    //                   color: Colors.black45,
                    //                   size: 15,
                    //                 ),
                    //               ],
                    //             ),
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        // color: Colors.white.withOpacity(0.5),
                        child: Ink(
                          height: 35,
                          // margin: const EdgeInsets.only(bottom: 5, right: 5),
                          // decoration: BoxDecoration(
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.black.withOpacity(0.15),
                          //       offset: Offset(0.0, 0.1),
                          //       blurRadius: 4,
                          //       spreadRadius: 1,
                          //     ),
                          //   ],
                          //   // color: Colors.white.withOpacity(0.5), //Color(0xffF6F6F6),
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                          // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            // splashColor: Colors.grey,
                            onTap: () async {
                              await Future.delayed(const Duration(milliseconds: 300));
                              addAmountToWallet();
                            },
                            child: isAdding
                                ? const SizedBox(
                                    height: 20,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 6),
                                        child: LoadingIndicator(
                                          indicatorType: Indicator.lineScalePulseOut,
                                          colors: [
                                            kAccentColor,
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    // margin: const EdgeInsets.only(bottom: 5, right: 5),
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          offset: Offset(0.0, 0.1),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      color: Colors.white.withOpacity(0.7), //Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(),
                                        Text(
                                          'Add',
                                          style: kBlackMediumStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black45,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
          isRemoving
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    padding: const EdgeInsets.all(2),
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
                    child: const Center(
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineScalePulseOut,
                        colors: [
                          kAccentColor,
                        ],
                      ),
                    ),
                  ),
                )
              : Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => removeBank(),
                    child: Container(
                      // margin: const EdgeInsets.all(4),
                      width: 15,
                      height: 15,
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
                        Icons.close,
                        color: Colors.black45,
                        size: 10,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
// GestureDetector(
// onTap: () {
// addAmountToWallet();
// },
// child: Container(
// margin: const EdgeInsets.only(bottom: 5, right: 5),
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(
// color: Colors.black.withOpacity(0.15),
// blurRadius: 4,
// spreadRadius: 1,
// ),
// ],
// color: const Color(0xffF6F6F6),
// borderRadius: BorderRadius.circular(8),
// ),
// padding: const EdgeInsets.symmetric(
// horizontal: 15, vertical: 6),
// child: isAdding
// ? const SizedBox(
// height: 22,
// child: Center(
// child: LoadingIndicator(
// indicatorType:
// Indicator.lineScalePulseOut,
// colors: [
// kAccentColor,
// ],
// ),
// ),
// )
//     : Row(
// mainAxisSize: MainAxisSize.max,
// mainAxisAlignment:
// MainAxisAlignment.spaceBetween,
// children: [
// const SizedBox(),
// Text(
// 'Add',
// style: kBlackMediumStyle.copyWith(
// fontWeight: FontWeight.bold),
// ),
// const Icon(
// Icons.arrow_forward_ios,
// color: Colors.black45,
// size: 15,
// ),
// ],
// ),
// ),
