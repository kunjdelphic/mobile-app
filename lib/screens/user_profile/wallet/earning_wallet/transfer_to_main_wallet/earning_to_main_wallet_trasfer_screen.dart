import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../../../widgets/buttons/gradient_button.dart';
import '../../../../../widgets/dialogs/common_dialogs.dart';
import '../../../../../widgets/dialogs/snackbars.dart';

class EarningToMainWalletTransferScreen extends StatefulWidget {
  const EarningToMainWalletTransferScreen({Key? key}) : super(key: key);

  @override
  _EarningToMainWalletTransferScreenState createState() => _EarningToMainWalletTransferScreenState();
}

class _EarningToMainWalletTransferScreenState extends State<EarningToMainWalletTransferScreen> {
  final WalletController walletController = Get.find();
  UserProfileController userProfileController = Get.find();
  TextEditingController amountController = TextEditingController();
  bool isExceed = false;

  showBillPaymentSheet() async {
    ButtonState btnState = ButtonState.idle;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
            return SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: GetX<WalletController>(
                    init: walletController,
                    builder: (controller) {
                      if (controller.isFetchingEarningWallet.value) {
                        return const Center(
                          child: SizedBox(
                            height: 25,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineScalePulseOut,
                              colors: [
                                kAccentColor,
                              ],
                            ),
                          ),
                        );
                      }
                      if (controller.earningWallet.value.data == null) {
                        return Center(
                          child: SizedBox(
                            height: 35,
                            child: Text(
                              controller.earningWallet.value.message!,
                              style: kBlackSmallMediumStyle,
                            ),
                          ),
                        );
                      }
                      return Container(
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: kWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
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
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Image.asset(
                                          'assets/icons/earning_wallet/transfer_amount.png',
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'ADD TO MAIN WALLET',
                                      style: kBlackMediumStyle,
                                    ),
                                  ),
                                  Text(
                                    '${controller.mainWalletReload.value.userDetails!.currency} ${amountController.text}',
                                    style: kBlackDarkSuperLargeStyle,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    kBlueBtnColor1,
                                    kBlueBtnColor2,
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
                                                'Earning Wallet',
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
                                                'RM ${controller.earningWallet.value.data?.earningWalletAmount}',
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
                              text: 'Add Now',
                              width: false,
                              widthSize: Get.width * 0.7,
                              buttonState: btnState,
                              onTap: () async {
                                setBottomSheetState(() {
                                  btnState = ButtonState.loading;
                                });

                                var res = await walletController.transferToMainWallet({
                                  "amount": amountController.text.trim(),
                                });

                                setBottomSheetState(() {
                                  btnState = ButtonState.idle;
                                });

                                if (res!.isEmpty) {
                                  //done

                                  Get.back();

                                  await showTransferToMainCompletedDialog(context: context);

                                  userProfileController.getUserDetails();
                                  walletController.getTransactionHistory({}, refreshing: true);
                                  walletController.getEarningHistory();
                                  walletController.getMainWalletReload({});
                                  walletController.getEarningWallet({});

                                  setState(() {
                                    amountController.text = '';
                                  });
                                } else {
                                  //error
                                  errorSnackbar(title: 'Failed', subtitle: res);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
          "Earning Wallet",
          style: kBlackLargeStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.info_outline,
                color: Colors.black54,
              ))
        ],
      ),
      body: GetX<WalletController>(
        init: walletController,
        builder: (controller) {
          if (controller.isFetchingEarningWallet.value) {
            return const Center(
              child: SizedBox(
                height: 25,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOut,
                  colors: [
                    kAccentColor,
                  ],
                ),
              ),
            );
          }
          if (controller.earningWallet.value.data == null) {
            return Center(
              child: SizedBox(
                height: 35,
                child: Text(
                  controller.earningWallet.value.message!,
                  style: kBlackSmallMediumStyle,
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => const WalletScreen());
                  },
                  child: Container(
                    // height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kBlueBtnColor1,
                          kBlueBtnColor2,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
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
                                      'Earning Wallet',
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: kWhiteDarkMediumStyle,
                                    ),
                                    Text(
                                      '${controller.mainWalletReload.value.userDetails!.currency} ${controller.earningWallet.value.data!.earningWalletAmount}',
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
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  // height: 250,
                  width: Get.width * 0.9,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
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
                            'assets/icons/ref_earnings.png',
                            height: 32,
                            width: 32,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Cashbacks & Referral Earnings',
                              style: kBlackSmallLightMediumStyle,
                            ),
                            const Divider(thickness: 0.30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${controller.mainWalletReload.value.userDetails!.currency} ${controller.earningWallet.value.data?.totalCashbackAndReferralEarning}',
                                  style: kBlackDarkSuperLargeStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  // height: 250,
                  width: Get.width * 0.9,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
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
                            'assets/icons/earning_wallet/money_received.png',
                            height: 26,
                            width: 26,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Money Received',
                              style: kBlackSmallLightMediumStyle,
                            ),
                            const Divider(thickness: 0.30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${controller.mainWalletReload.value.userDetails!.currency} ${controller.earningWallet.value.data?.totalMoneyReceived}',
                                  style: kBlackDarkSuperLargeStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  // height: 250,
                  width: Get.width * 0.9,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Image.asset(
                              'assets/icons/earning_wallet/transfer_amount.png',
                              height: 35,
                              width: 35,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transferable Amount to Main Wallet',
                              style: kBlackSmallLightMediumStyle,
                            ),
                            const Divider(thickness: 0.30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${controller.mainWalletReload.value.userDetails!.currency} ${controller.earningWallet.value.data?.transferableAmountToMainWallet}',
                                  style: kPrimaryDarkSuperLargeStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
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
                      Text(
                        'Enter the amount',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GetX<UserProfileController>(
                        init: userProfileController,
                        builder: (_) {
                          return Container(
                            // height: 250,
                            width: Get.width * 0.9,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'RM',
                                      style: kBlackMediumStyle,
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
                                        textAlignVertical: TextAlignVertical.center,
                                        controller: amountController,
                                        onChanged: (value) {
                                          if (value.trim().isEmpty) {
                                            setState(() {
                                              isExceed = false;
                                            });
                                          } else {
                                            if (double.parse(value.trim().toString()) > double.parse(controller.earningWallet.value.data!.transferableAmountToMainWallet.toString())) {
                                              setState(() {
                                                isExceed = true;
                                              });
                                            } else {
                                              setState(() {
                                                isExceed = false;
                                              });
                                            }
                                          }
                                        },
                                        enableInteractiveSelection: true,
                                        style: kBlackMediumStyle,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: "Enter amount here",
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                          helperStyle: kBlackSmallLightMediumStyle,
                                          errorStyle: kBlackSmallLightMediumStyle,
                                          hintStyle: kBlackSmallLightMediumStyle,

                                          labelStyle: kBlackSmallLightMediumStyle,
                                          fillColor: kWhite,
                                          filled: true,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          border: InputBorder.none,
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
                                        isExceed = false;
                                      }),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.black38,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 0.30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Transferable Amount to Main Wallet:',
                                        style: isExceed ? kRedExtraSmallMediumStyle : kBlackExtraSmallMediumStyle,
                                      ),
                                    ),
                                    Text(
                                      '${controller.mainWalletReload.value.userDetails!.currency} ${controller.earningWallet.value.data?.transferableAmountToMainWallet}',
                                      textAlign: TextAlign.end,
                                      style: isExceed ? kRedDarkSuperLargeStyle : kBlackDarkSuperLargeStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (amountController.text.trim().isNotEmpty && !isExceed) {
                                      //proceed
                                      showBillPaymentSheet();
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          kBlueBtnColor1,
                                          kBlueBtnColor2,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add,
                                          color: kWhite,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Add to Main Wallet',
                                          style: kWhiteMediumStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
