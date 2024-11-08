import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/screens/user_profile/wallet/all_bank_list_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/transfer_to_main_wallet/earning_to_main_wallet_trasfer_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/wallet_reloade_info_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/wallet/user_bank_list_item.dart';

import '../../../widgets/buttons/gradient_button.dart';
import 'earning_wallet/wallet_activation/ew_1_screen.dart';

class MainWalletReloadScreen extends StatefulWidget {
  const MainWalletReloadScreen({Key? key}) : super(key: key);

  @override
  _MainWalletReloadScreenState createState() => _MainWalletReloadScreenState();
}

class _MainWalletReloadScreenState extends State<MainWalletReloadScreen> {
  final WalletController walletController = Get.find();
  UserProfileController userProfileController = Get.find();

  @override
  void initState() {
    super.initState();

    walletController.getMainWalletReload({});
    // walletController.getEarningWallet({});

    // if (walletController.mainWalletReload.value.userDetails == null) {}
  }

  String selectedPaymentMethod = 'E-wallet';
  String selectedWallet = 'TouchNGo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Main Wallet Reload ",
          style: kBlackLargeStyle,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => WalletReloadInfo());
              },
              icon: const Icon(
                Icons.info_outline,
                color: Colors.black54,
              ))
        ],
      ),
      body: GetX<WalletController>(
        init: walletController,
        builder: (controller) {
          print("+-+-+-+-+-+-+-+-+-+-+-+-+- ${controller.mainWalletReload.value.minReloadAmount}");
          if (controller.isFetching.value || controller.mainWalletReload.value.userDetails!.mainWalletAmount == null) {
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
          if (controller.mainWalletReload.value.status != 200) {
            return Center(
              child: SizedBox(
                height: 35,
                child: Text(
                  controller.mainWalletReload.value.message!,
                  style: kBlackSmallMediumStyle,
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => const WalletScreen());
                  },
                  child: Container(
                    // height: 250,
                    // margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kColorPrimary,
                          kColorPrimaryDark,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Balance',
                                      style: kWhiteDarkMediumStyle,
                                    ),
                                    Text(
                                      '${controller.mainWalletReload.value.userDetails!.currency} ${controller.mainWalletReload.value.userDetails!.mainWalletAmount}',
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
                CommonShadeContainer(
                  title: 'Add from online banking',
                ),
                // Container(
                //   color: const Color(0xffF2F1F6),
                //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   child: Center(
                //     child: Text(
                //       'Main Wallet Reload Options:',
                //       style: kBlackSmallMediumStyle,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Text(
                    //     '1: Add From Online Banking',
                    //     style: kBlackMediumStyle,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    controller.mainWalletReload.value.banks!.isNotEmpty
                        ? SizedBox(
                            height: 200,
                            width: Get.width,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                itemBuilder: (context, index) => index == controller.mainWalletReload.value.banks!.length
                                    ? GestureDetector(
                                        onTap: () async {
                                          var res = await Get.to(() => const AllBankListScreen());
                                          if (res != null) {
                                            if (res) {
                                              //added new bank
                                              // walletController.getAllUserBankList({});
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: Get.width * 0.7,
                                          // height: 140,
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: kWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 6,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 45,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  gradient: const LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      kBlueBtnColor1,
                                                      kBlueBtnColor2,
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: kWhite,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    'Add Banks Shortcut',
                                                    style: kBlackSmallLightMediumStyle,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : UserBankListItem(
                                        minReloadAmount: controller.mainWalletReload.value.minReloadAmount,
                                        userBank: controller.mainWalletReload.value.banks![index],
                                        mainWalletUserDetails: controller.mainWalletReload.value.userDetails!,
                                      ),
                                separatorBuilder: (context, index) => const SizedBox(
                                      width: 15,
                                    ),
                                itemCount: controller.mainWalletReload.value.banks!.length + 1),
                          )
                        : GestureDetector(
                            onTap: () async {
                              var res = await Get.to(() => const AllBankListScreen());
                              if (res != null) {
                                if (res) {
                                  //added new bank
                                  // walletController.getAllUserBankList({});
                                }
                              }
                            },
                            child: Center(
                              child: Container(
                                // height: 250,
                                width: Get.width * 0.9,
                                height: 180,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff0E76BC),
                                              Color(0xff283891),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: kWhite,
                                          size: 20,
                                        ),
                                      ),
                                      // const CircleAvatar(
                                      //   backgroundColor: kAccentColor,
                                      //   radius: 18,
                                      //   child: Icon(
                                      //     Icons.add,
                                      //     color: kWhite,
                                      //     size: 20,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Add Banks Shortcut',
                                        style: kBlackSmallLightMediumStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    const CommonShadeContainer(
                      title: 'Add From Earning Wallet',
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: GetX<UserProfileController>(
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
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Earning Wallet',
                                            style: kBlackDarkMediumStyle,
                                          ),
                                          Text(
                                            'Referral Earnings | T&C Apply',
                                            style: kBlackExtraSmallLightMediumStyle,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Balance',
                                            style: kBlackDarkMediumStyle,
                                          ),
                                          Text(
                                            controller.earningWallet.value.data == null
                                                ? ''
                                                : '${controller.mainWalletReload.value.userDetails!.currency} ${(double.parse(controller.earningWallet.value.data!.totalMoneyReceived.toString()) + double.parse(controller.earningWallet.value.data!.totalCashbackAndReferralEarning.toString())).toStringAsFixed(2)}',
                                            style: kBlackDarkSuperLargeStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // WhiteBluBtn(
                                //   width: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
                                //   onTap: () {},
                                //   text: "+ Add to Main Wallet",
                                //   style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                                //     fontSize: 16,
                                //     color: Colors.white,
                                //   ),
                                //   widthSize: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
                                // ),

                                _.userProfile.value.data!.accountStatus != 'APPROVED'
                                    ? WhiteBluBtn(
                                        width: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
                                        onTap: () {
                                          Get.to(() => const EarningToMainWalletTransferScreen());
                                        },
                                        text: "+ Add to Main Wallet",
                                        style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        widthSize: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
                                      )
                                    : _.userProfile.value.data!.accountStatus == 'NOT_APPROVED' || _.userProfile.value.data!.accountStatus == 'RESUBMIT'
                                        ? GestureDetector(
                                            onTap: () async {
                                              await Get.to(() => const EW1Screen());
                                              userProfileController.getUserDetails();
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.15),
                                                        blurRadius: 10,
                                                        spreadRadius: 1,
                                                      ),
                                                    ],
                                                    color: kRedBtnColor1,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  width: Get.width * 0.9,
                                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Activate Earning Wallet',
                                                        style: kWhiteMediumStyle,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        'Verification\nPending',
                                                        style: kWhiteExtraSmallMediumStyle,
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: kWhite,
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: const Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Colors.black45,
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color: kWhite,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: kColorPrimary.withOpacity(0.3),
                                                          blurRadius: 3,
                                                          spreadRadius: 0.5,
                                                        )
                                                      ],
                                                    ),
                                                    width: 14,
                                                    height: 14,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.error,
                                                        color: kRedBtnColor1,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : _.userProfile.value.data!.accountStatus == 'PENDING'
                                            ? GestureDetector(
                                                onTap: () {
                                                  // Get.to(() => const EW1Screen());
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.15),
                                                            blurRadius: 10,
                                                            spreadRadius: 1,
                                                          ),
                                                        ],
                                                        color: const Color(0xffFFD958),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      width: Get.width * 0.9,
                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Verification in Process…',
                                                            style: kBlackMediumStyle,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Spacer(),
                                                          Text(
                                                            'Verification\nPending',
                                                            style: kBlackExtraSmallMediumStyle,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                              color: kWhite,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: const Icon(
                                                              Icons.arrow_forward_ios,
                                                              color: Colors.black45,
                                                              size: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: kWhite,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: kColorPrimary.withOpacity(0.3),
                                                              blurRadius: 3,
                                                              spreadRadius: 0.5,
                                                            )
                                                          ],
                                                        ),
                                                        width: 14,
                                                        height: 14,
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.error,
                                                            color: kRedBtnColor1,
                                                            size: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    const CommonShadeContainer(
                      title: 'Other method to reload your Main Wallet',
                    ),
                    const SizedBox(height: 18),
                    Container(
                      // height: 250,
                      width: Get.width * 0.9,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1.3,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              minLeadingWidth: 0,
                              leading: Container(
                                height: 40,
                                width: 40,
                                child: Image.asset("assets/images/debit_card.png", fit: BoxFit.cover),
                              ),
                              title: Text(
                                'Debit/Credit Card',
                                style: kBlackExtraSmallMediumStyle.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                              trailing: Radio<String>(
                                activeColor: Color(0xff79B32B),
                                value: 'Debit/Credit Card',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  selectedPaymentMethod = 'Debit/Credit Card';
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 6),
                          // E-wallet option with Radio button on the right
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1.3,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              minLeadingWidth: 0,
                              leading: Container(
                                height: 40,
                                width: 40,
                                child: Image.asset("assets/images/e_wallet.png", fit: BoxFit.cover),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    'E-wallet',
                                    style: kBlackExtraSmallMediumStyle.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (selectedPaymentMethod == 'E-wallet')
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: kWhiteExtraSmallMediumStyle.copyWith(fontSize: 8, color: Color(0xFF518919)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Radio<String>(
                                activeColor: Color(0xff79B32B),
                                value: 'E-wallet',
                                groupValue: selectedPaymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  selectedPaymentMethod = 'E-wallet';
                                });
                              },
                            ),
                          ),
                          if (selectedPaymentMethod == 'E-wallet') ...[
                            SizedBox(height: 16),

                            // E-wallet selection grid
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildWalletOption('Shopee Pay', 'assets/images/sPay.png'),
                                _buildWalletOption('Grab Pay', 'assets/images/grab_pay.png'),
                                _buildWalletOption('TouchNGo', 'assets/images/touchngo_pay.png'),
                              ],
                            ),
                          ],
                          SizedBox(height: 36),

                          Container(
                            height: 80,
                            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffFDEFEF),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      child: Image.asset(
                                        "assets/images/warning.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Cards & E-Wallet Service Fee",
                                      style: kBlackMedium.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  "Using this payment method will incur a service charge of 1% to 2%. After deducting the service fee, the remaining balance will be credited to your Main Wallet. Note: The FPX payment method does not charge any additional fees",
                                  style: kBlackMedium,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 17),
                    WhiteBluBtn(
                      width: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
                      onTap: () {},
                      text: "Proceed to Payment",
                      style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      widthSize: MediaQuery.of(context).size.width - (Get.mediaQuery.size.width * 0.06),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       const Divider(thickness: 0.30),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       Text(
                    //         '2: Add From Earning Wallet',
                    //         style: kBlackMediumStyle,
                    //       ),
                    //       const SizedBox(
                    //         height: 15,
                    //       ),
                    //       GetX<UserProfileController>(
                    //         init: userProfileController,
                    //         builder: (_) {
                    //           return Container(
                    //             // height: 250,
                    //             width: Get.width * 0.9,
                    //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(12),
                    //               color: kWhite,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   color: Colors.black.withOpacity(0.15),
                    //                   blurRadius: 10,
                    //                   spreadRadius: 1,
                    //                 ),
                    //               ],
                    //             ),
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Row(
                    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                    //                   children: [
                    //                     Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           'Earning Wallet',
                    //                           style: kBlackDarkMediumStyle,
                    //                         ),
                    //                         Text(
                    //                           'Referral Earnings | T&C Apply',
                    //                           style: kBlackExtraSmallLightMediumStyle,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.end,
                    //                       children: [
                    //                         Text(
                    //                           'Balance',
                    //                           style: kBlackDarkMediumStyle,
                    //                         ),
                    //                         Text(
                    //                           controller.earningWallet.value.data == null
                    //                               ? ''
                    //                               : '${controller.mainWalletReload.value.userDetails!.currency} ${(double.parse(controller.earningWallet.value.data!.totalMoneyReceived.toString()) + double.parse(controller.earningWallet.value.data!.totalCashbackAndReferralEarning.toString())).toStringAsFixed(2)}',
                    //                           style: kBlackDarkSuperLargeStyle,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 _.userProfile.value.data!.accountStatus == 'APPROVED'
                    //                     ? GestureDetector(
                    //                         onTap: () async {
                    //                           Get.to(() => const EarningToMainWalletTransferScreen());
                    //                         },
                    //                         child: Container(
                    //                           height: 45,
                    //                           decoration: BoxDecoration(
                    //                             gradient: const LinearGradient(
                    //                               colors: [
                    //                                 kBlueBtnColor1,
                    //                                 kBlueBtnColor2,
                    //                               ],
                    //                               begin: Alignment.topCenter,
                    //                               end: Alignment.bottomCenter,
                    //                             ),
                    //                             boxShadow: [
                    //                               BoxShadow(
                    //                                 color: Colors.black.withOpacity(0.1),
                    //                                 spreadRadius: 2,
                    //                                 blurRadius: 5,
                    //                                 offset: const Offset(0, 4),
                    //                               ),
                    //                             ],
                    //                             borderRadius: BorderRadius.circular(10),
                    //                           ),
                    //                           child: Row(
                    //                             mainAxisAlignment: MainAxisAlignment.center,
                    //                             children: [
                    //                               const Icon(
                    //                                 Icons.add,
                    //                                 color: kWhite,
                    //                                 size: 20,
                    //                               ),
                    //                               const SizedBox(
                    //                                 width: 10,
                    //                               ),
                    //                               Text(
                    //                                 'Add to Main Wallet',
                    //                                 style: kWhiteMediumStyle,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       )
                    //                     : _.userProfile.value.data!.accountStatus == 'NOT_APPROVED' || _.userProfile.value.data!.accountStatus == 'RESUBMIT'
                    //                         ? GestureDetector(
                    //                             onTap: () async {
                    //                               await Get.to(() => const EW1Screen());
                    //                               userProfileController.getUserDetails();
                    //                             },
                    //                             child: Stack(
                    //                               children: [
                    //                                 Container(
                    //                                   decoration: BoxDecoration(
                    //                                     boxShadow: [
                    //                                       BoxShadow(
                    //                                         color: Colors.black.withOpacity(0.15),
                    //                                         blurRadius: 10,
                    //                                         spreadRadius: 1,
                    //                                       ),
                    //                                     ],
                    //                                     color: kRedBtnColor1,
                    //                                     borderRadius: BorderRadius.circular(10),
                    //                                   ),
                    //                                   width: Get.width * 0.9,
                    //                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    //                                   child: Row(
                    //                                     children: [
                    //                                       Text(
                    //                                         'Activate Earning Wallet',
                    //                                         style: kWhiteMediumStyle,
                    //                                       ),
                    //                                       const SizedBox(
                    //                                         width: 10,
                    //                                       ),
                    //                                       const Spacer(),
                    //                                       Text(
                    //                                         'Verification\nPending',
                    //                                         style: kWhiteExtraSmallMediumStyle,
                    //                                       ),
                    //                                       const SizedBox(
                    //                                         width: 6,
                    //                                       ),
                    //                                       Container(
                    //                                         padding: const EdgeInsets.all(10),
                    //                                         decoration: BoxDecoration(
                    //                                           color: kWhite,
                    //                                           borderRadius: BorderRadius.circular(10),
                    //                                         ),
                    //                                         child: const Icon(
                    //                                           Icons.arrow_forward_ios,
                    //                                           color: Colors.black45,
                    //                                           size: 15,
                    //                                         ),
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 ),
                    //                                 Positioned(
                    //                                   right: 0,
                    //                                   top: 0,
                    //                                   child: Container(
                    //                                     decoration: BoxDecoration(
                    //                                       borderRadius: BorderRadius.circular(100),
                    //                                       color: kWhite,
                    //                                       boxShadow: [
                    //                                         BoxShadow(
                    //                                           color: kColorPrimary.withOpacity(0.3),
                    //                                           blurRadius: 3,
                    //                                           spreadRadius: 0.5,
                    //                                         )
                    //                                       ],
                    //                                     ),
                    //                                     width: 14,
                    //                                     height: 14,
                    //                                     child: const Center(
                    //                                       child: Icon(
                    //                                         Icons.error,
                    //                                         color: kRedBtnColor1,
                    //                                         size: 14,
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           )
                    //                         : _.userProfile.value.data!.accountStatus == 'PENDING'
                    //                             ? GestureDetector(
                    //                                 onTap: () {
                    //                                   // Get.to(() => const EW1Screen());
                    //                                 },
                    //                                 child: Stack(
                    //                                   children: [
                    //                                     Container(
                    //                                       decoration: BoxDecoration(
                    //                                         boxShadow: [
                    //                                           BoxShadow(
                    //                                             color: Colors.black.withOpacity(0.15),
                    //                                             blurRadius: 10,
                    //                                             spreadRadius: 1,
                    //                                           ),
                    //                                         ],
                    //                                         color: const Color(0xffFFD958),
                    //                                         borderRadius: BorderRadius.circular(10),
                    //                                       ),
                    //                                       width: Get.width * 0.9,
                    //                                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    //                                       child: Row(
                    //                                         children: [
                    //                                           Text(
                    //                                             'Verification in Process…',
                    //                                             style: kBlackMediumStyle,
                    //                                           ),
                    //                                           const SizedBox(
                    //                                             width: 10,
                    //                                           ),
                    //                                           const Spacer(),
                    //                                           Text(
                    //                                             'Verification\nPending',
                    //                                             style: kBlackExtraSmallMediumStyle,
                    //                                           ),
                    //                                           const SizedBox(
                    //                                             width: 6,
                    //                                           ),
                    //                                           Container(
                    //                                             padding: const EdgeInsets.all(10),
                    //                                             decoration: BoxDecoration(
                    //                                               color: kWhite,
                    //                                               borderRadius: BorderRadius.circular(10),
                    //                                             ),
                    //                                             child: const Icon(
                    //                                               Icons.arrow_forward_ios,
                    //                                               color: Colors.black45,
                    //                                               size: 15,
                    //                                             ),
                    //                                           ),
                    //                                         ],
                    //                                       ),
                    //                                     ),
                    //                                     Positioned(
                    //                                       right: 0,
                    //                                       top: 0,
                    //                                       child: Container(
                    //                                         decoration: BoxDecoration(
                    //                                           borderRadius: BorderRadius.circular(100),
                    //                                           color: kWhite,
                    //                                           boxShadow: [
                    //                                             BoxShadow(
                    //                                               color: kColorPrimary.withOpacity(0.3),
                    //                                               blurRadius: 3,
                    //                                               spreadRadius: 0.5,
                    //                                             )
                    //                                           ],
                    //                                         ),
                    //                                         width: 14,
                    //                                         height: 14,
                    //                                         child: const Center(
                    //                                           child: Icon(
                    //                                             Icons.error,
                    //                                             color: kRedBtnColor1,
                    //                                             size: 14,
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               )
                    //                             : const SizedBox(),
                    //               ],
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWalletOption(String name, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWallet = name;
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedWallet == name ? Colors.green : Colors.grey,
            width: 1.3,
          ),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Image.asset(assetPath, width: 50, height: 50),
            SizedBox(height: 8),
            Text(name),
          ],
        ),
      ),
    );
  }
}

class CommonShadeContainer extends StatelessWidget {
  final String title;

  const CommonShadeContainer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFCFDCEB),
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              "${title}",
              style: kBlackDarkSuperLargeStyle.copyWith(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            height: 27,
            width: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0E76BC),
                  Color(0xFF283891),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
