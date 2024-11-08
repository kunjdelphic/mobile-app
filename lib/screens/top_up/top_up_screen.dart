import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/top_up_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/topup/recent_top_up.dart';
import 'package:parrotpos/models/topup/top_up_amounts.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/transaction_history_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/send_money/contacts_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:parrotpos/widgets/top_up/recent_top_up_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/progress_button.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> with TickerProviderStateMixin {
  final UserProfileController userProfileController = Get.find();
  final TopUpController topUpController = Get.find();
  WalletController walletController = Get.find();

  String? amount, countryCode;
  TextEditingController phoneNoController = TextEditingController();

  ButtonState btnState = ButtonState.idle;
  int selectedTab = 0;
  int selectedNetworkType = -1;
  int selectedAmt = -1;
  String? cashbackAmt;
  // Contact? contact;
  bool isSentMoney = false;
  // Future<TopUpAmounts?>? _futureTopUpAmts;
  // late Future<TopUpAmounts?> _futureTopUpRecentAmts;
  Map filterMap = {};
  // late TopUpAmounts topUpAmounts;
  TopUpAmounts? recentTopUpAmounts;
  bool isSelectNetworkType = false;
  bool isInsertNo = false;
  bool isInvalidNo = false;
  bool isChooseAmt = false;

  @override
  void initState() {
    super.initState();

    topUpController.getRecentTopUp({});
    topUpController.getTopUpProducts({
      "country": "MY",
    });

    // _futureTopUpAmts = getTopUpAmounts({});
  }

  // Future<TopUpAmounts> getTopUpAmounts(Map map) async {
  //   if (map.isEmpty) {
  //     return topUpAmounts;
  //   }
  //   var res = await topUpController.getTopUpAmounts(map);
  //   topUpAmounts = res;
  //   if (res.status == 200) {
  //     //got it
  //     return res;
  //   } else {
  //     //error
  //     errorSnackbar(title: 'Failed', subtitle: '${res.message}');
  //     return res;
  //   }
  // }

  Future<TopUpAmounts?> getTopUpRecentAmounts(Map map) async {
    var res = await topUpController.getTopUpAmounts(map);

    if (res.status == 200) {
      //got it
      return res;
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: '${res.message}');
      return res;
    }
  }

  showTopupSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
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
                                  child: Image.network(
                                    topUpController.topUpProducts.value.products![selectedNetworkType].logo ?? '',
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
                                    '${topUpController.topUpProducts.value.products![selectedNetworkType].name}',
                                    style: kBlackSmallMediumStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    phoneNoController.text.trim(),
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
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
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
                                  width: 15,
                                  height: 15,
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
                                  style: kBlackSmallLightMediumStyle,
                                ),
                                Text(
                                  '${topUpController.topUpProducts.value.products![selectedNetworkType].currency} $cashbackAmt',
                                  style: kPrimarySmallDarkMediumStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Selected Amount:',
                    textAlign: TextAlign.start,
                    style: kBlackMediumStyle,
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         width: 22,
                  //         height: 22,
                  //         padding: const EdgeInsets.all(5),
                  //         decoration: BoxDecoration(
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.black.withOpacity(0.1),
                  //               blurRadius: 5,
                  //               spreadRadius: 1,
                  //             ),
                  //           ],
                  //           color: kWhite,
                  //           // color: kWhite,
                  //           borderRadius: BorderRadius.circular(100),
                  //         ),
                  //         child: Center(
                  //           child: Image.asset(
                  //             'assets/icons/ic_cashback.png',
                  //             width: 12,
                  //             height: 12,
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         width: 10,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             'Cash Back: ',
                  //             style: kBlackMediumStyle,
                  //           ),
                  //           Text(
                  //             selectedAmt == -1
                  //                 ? 'RM 0.00'
                  //                 : '${topUpController.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].currency} ${topUpController.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].cashbackAmount}',
                  //             style: kPrimaryDarkMediumStyle,
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 60,
                    // width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setBottomSheetState(() {
                              selectedAmt = index;
                            });

                            setState(() {
                              selectedAmt = index;
                              amount = topUpController.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].amount.toString();
                              cashbackAmt = topUpController.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].cashbackAmount.toString();

                              isChooseAmt = false;
                            });
                          },
                          child: Container(
                            width: 90,
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kWhite,
                              border: selectedAmt == index
                                  ? Border.all(
                                      color: kColorPrimary,
                                      width: 1.5,
                                    )
                                  : const Border(),
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
                                '${topUpController.topUpProducts.value.products![selectedNetworkType].amounts![index].currency} ${topUpController.topUpProducts.value.products![selectedNetworkType].amounts![index].amount}',
                                style: selectedAmt == index ? kBlackMediumStyle : kBlackLightMediumStyle,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 15,
                      ),
                      itemCount: topUpController.topUpProducts.value.products![selectedNetworkType].amounts!.length,
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // SizedBox(
                  //   height: 65,
                  //   // width: double.infinity,
                  //   child: ListView.separated(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 7, horizontal: 5),
                  //     itemBuilder: (context, index) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           setBottomSheetState(() {
                  //             selectedAmt = index;
                  //           });

                  //           setState(() {
                  //             selectedAmt = index;
                  //             amount = topUpAmounts.amounts![selectedAmt].amount
                  //                 .toString();
                  //             cashbackAmt = topUpAmounts
                  //                 .amounts![selectedAmt].cashbackAmount
                  //                 .toString();

                  //             isChooseAmt = false;
                  //           });
                  //         },
                  //         child: Container(
                  //           width: 90,
                  //           height: 40,
                  //           padding: const EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 5),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(12),
                  //             color: kWhite,
                  //             border: selectedAmt == index
                  //                 ? Border.all(
                  //                     color: kColorPrimary,
                  //                     width: 1.5,
                  //                   )
                  //                 : const Border(),
                  //             gradient: selectedAmt == index
                  //                 ? const LinearGradient(
                  //                     begin: Alignment.topCenter,
                  //                     end: Alignment.bottomCenter,
                  //                     colors: [
                  //                       kGreenBtnColor1,
                  //                       kGreenBtnColor2,
                  //                     ],
                  //                   )
                  //                 : null,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: selectedAmt == index
                  //                     ? kColorPrimary.withOpacity(0.4)
                  //                     : Colors.black.withOpacity(0.2),
                  //                 blurRadius: 6,
                  //                 spreadRadius: 2,
                  //               ),
                  //             ],
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               '${topUpAmounts.amounts![index].currency} ${topUpAmounts.amounts![index].amount}',
                  //               style: selectedAmt == index
                  //                   ? kWhiteDarkMediumStyle
                  //                   : kBlackLightMediumStyle,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     separatorBuilder: (context, index) => const SizedBox(
                  //       width: 15,
                  //     ),
                  //     itemCount: topUpAmounts.amounts!.length,
                  //   ),
                  // ),
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
                            text: 'Top Up Now',
                            width: false,
                            widthSize: Get.width * 0.7,
                            buttonState: ButtonState.idle,
                            onTap: () {
                              Get.back();

                              if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < double.parse(amount.toString())) {
                                lowWalletBalanceDialog(
                                  image: 'assets/icons/ic_low_wallet_balance.png',
                                  context: context,
                                  onTap: () {
                                    Get.back();
                                    Get.to(() => const MainWalletReloadScreen());
                                  },
                                );
                                return;
                              } else {
                                processTopup();
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
            );
          },
        );
      },
    );
  }

  showTopupSheetRecent(RecentTopUpData recentTopUpData, int amountIndex) async {
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
                                child: Image.network(
                                  recentTopUpData.others!.productLogo ?? '',
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
                                  '${recentTopUpData.others!.productName}',
                                  style: kBlackSmallMediumStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  recentTopUpData.others!.accountNumber,
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
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
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
                                width: 15,
                                height: 15,
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
                                style: kBlackSmallLightMediumStyle,
                              ),
                              Text(
                                '${recentTopUpAmounts!.amounts![amountIndex].currency} ${recentTopUpAmounts!.amounts![amountIndex].cashbackAmount}',
                                style: kPrimarySmallDarkMediumStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Selected Amount:',
                  style: kBlackMediumStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 65,
                  // width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setStateSheetRecent(() {
                            amountIndex = index;
                          });
                        },
                        child: Container(
                          width: 90,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhite,
                            gradient: amountIndex == index
                                ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      kGreenBtnColor1,
                                      kGreenBtnColor2,
                                    ],
                                  )
                                : null,
                            border: amountIndex == index
                                ? Border.all(
                                    color: kColorPrimary,
                                    width: 1.5,
                                  )
                                : const Border(),
                            boxShadow: [
                              BoxShadow(
                                color: amountIndex == index ? kColorPrimary.withOpacity(0.4) : Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${recentTopUpAmounts!.amounts![index].currency} ${recentTopUpAmounts!.amounts![index].amount}',
                              style: amountIndex == index ? kWhiteMediumStyle : kBlackLightMediumStyle,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 15,
                    ),
                    itemCount: recentTopUpAmounts!.amounts!.length,
                  ),
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
                          text: 'Top Up Now',
                          width: false,
                          widthSize: Get.width * 0.7,
                          buttonState: ButtonState.idle,
                          onTap: () {
                            Get.back();

                            if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < double.parse(amount.toString())) {
                              lowWalletBalanceDialog(image: 'assets/icons/ic_low_wallet_balance.png', context: context);
                            } else {
                              processTopupRecent(recentTopUpAmounts!.amounts![amountIndex].amount, recentTopUpData.others!.productId, recentTopUpData.others!.accountNumber);
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

    if (res!.isEmpty) {
      //done
      showCompletedTopupDialog(
        context: context,
        onTap: () {
          Get.back();
          walletController.getTransactionHistory({});
          Get.to(() => const TransactionHistoryScreen());
        },
        onTapFav: () {},
        onClose: () {
          Get.back();
          Get.back();
        },
      );
      topUpController.getRecentTopUp({});

      userProfileController.getUserDetails();
    } else {
      if (res != 'Server Maintenance InProgress') {
        print(res.toString());

        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }

  processTopup() async {
    setState(() {
      btnState = ButtonState.loading;
    });

    var res = await topUpController.initiateTopUp(
      {
        "amount": amount,
        "product_id": topUpController.topUpProducts.value.products![selectedNetworkType].productId,
        "account_number": phoneNoController.text.trim(),
      },
    );

    setState(() {
      btnState = ButtonState.idle;
    });

    if (res!.isEmpty) {
      //done
      walletController.getTransactionHistory({});
      walletController.getEarningHistory();
      walletController.getWalletBalance({});
      walletController.getMainWalletReload({});
      userProfileController.updateUserDetails();

      showCompletedTopupDialog(
          context: context,
          onTap: () {
            Get.back();

            Get.to(() => const TransactionHistoryScreen());
          },
          onClose: () {
            Get.back();
            Get.back();
          },
          onTapFav: () {});

      userProfileController.getUserDetails();
    } else {
      if (res != 'Server Maintenance InProgress') {
        // print(res.toString());

        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }

  // void _showPermissionDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Permission Required'),
  //       content: Text('Contact access is needed to continue. Please go to settings and allow contact access.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.of(context).pop();
  //             if (await Permission.contacts.isPermanentlyDenied) {
  //               openAppSettings(); // Navigate to app settings
  //             } else {
  //               Permission.contacts.request(); // Request permission again
  //             }
  //           },
  //           child: Text('Go to Settings'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // final FlutterContactPicker _contactPicker = new FlutterContactPicker();
  // RxList<Contact> contacts = <Contact>[].obs;
  // // String? _contactNumber;
  //
  // Future<void> checkContactPermission(BuildContext context) async {
  //   PermissionStatus status = await Permission.contacts.request();
  //
  //   if (status.isGranted) {
  //     await _pickContact();
  //   } else /* (status.isDenied || status.isPermanentlyDenied)*/ {
  //     contactPermissionDialog(context: context);
  //   }
  // }
  //
  // Future<void> _pickContact() async {
  //   try {
  //     Contact? contact = await _contactPicker.selectContact();
  //     contacts?.value = contact == null ? [] : [contact];
  //     print("ContactNumber +++++++++++ ${contacts}");
  //     // Contact? contact = await _contactPicker.selectContact();
  //     // setState(() {
  //     //   _contactNumber = "${contact?.phoneNumbers?.isNotEmpty == true ? contact?.phoneNumbers : "No number available"}";
  //     // });
  //   } catch (e) {
  //     errorSnackbar(title: 'Failed', subtitle: 'Failed to pick contact');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Top Up",
          style: kBlackLargeStyle,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: selectedTab == 0
                              ? [
                                  kColorPrimary,
                                  kColorPrimaryDark,
                                ]
                              : [
                                  const Color(0xffEDEDED),
                                  const Color(0xffEDEDED),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            selectedTab == 0 ? 'assets/icons/ic_topup.png' : 'assets/icons/ic_topup_dark.png',
                            height: 18,
                            width: 18,
                          ),
                          const Spacer(),
                          Text(
                            'Prepaid',
                            overflow: TextOverflow.ellipsis,
                            style: selectedTab == 0 ? kWhiteMediumStyle : kBlackLightMediumStyle,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = 1;

                        topUpController.getRecentTopUp({});
                      });
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: selectedTab == 1
                              ? [
                                  kColorPrimary,
                                  kColorPrimaryDark,
                                ]
                              : [
                                  const Color(0xffEDEDED),
                                  const Color(0xffEDEDED),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            selectedTab == 1 ? 'assets/icons/ic_topup.png' : 'assets/icons/ic_topup_dark.png',
                            height: 18,
                            width: 18,
                          ),
                          const Spacer(),
                          Text(
                            'Recent',
                            overflow: TextOverflow.ellipsis,
                            style: selectedTab == 1 ? kWhiteMediumStyle : kBlackLightMediumStyle,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            thickness: 0.30,
            height: 0,
          ),
          selectedTab == 0
              ? Expanded(
                  child: GetX<TopUpController>(
                    init: topUpController,
                    builder: (controller) {
                      if (controller.isFetchingTopUpProducts.value && controller.topUpProducts.value.products == null) {
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
                      if (controller.topUpProducts.value.status != 200) {
                        return Center(
                          child: SizedBox(
                            height: 35,
                            child: Text(
                              '${controller.topUpProducts.value.message}',
                              style: kBlackSmallMediumStyle,
                            ),
                          ),
                        );
                      }
                      return ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Select Your Network Type:',
                              style: isSelectNetworkType ? kRedMediumStyle : kBlackMediumStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 80,
                            // width: double.infinity,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      selectedNetworkType = index;
                                      isSelectNetworkType = false;
                                      amount = null;
                                      selectedAmt = -1;
                                      isChooseAmt = false;
                                    });
                                    // _futureTopUpAmts = getTopUpAmounts({
                                    //   "product_id":
                                    //       "${controller.topUpProducts.value.products![index].productId}"
                                    // });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: Get.width * 0.25,
                                        height: 42,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: kWhite,
                                          border: selectedNetworkType == index
                                              ? Border.all(
                                                  color: kColorPrimary,
                                                  width: 1.5,
                                                )
                                              : const Border(),
                                          boxShadow: [
                                            BoxShadow(
                                              color: selectedNetworkType == index ? kColorPrimary.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: controller.topUpProducts.value.products?[index].logo?.isNotEmpty ?? false
                                            ? CachedNetworkImage(
                                                imageUrl: controller.topUpProducts.value.products![index].logo ?? '',
                                                placeholder: (context, url) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(top: 20),
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      '${controller.topUpProducts.value.products![index].name}',
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
                                                fit: BoxFit.cover,
                                                width: Get.width,
                                              )
                                            // Image.network(
                                            //         '${controller.topUpProducts.value.products![index].logo}',
                                            //         fit: BoxFit.scaleDown,
                                            //         width: 70,
                                            //         height: 38,
                                            //         errorBuilder: (context, error, stackTrace) => Image.asset(
                                            //           'assets/images/logo/parrot_logo.png',
                                            //           fit: BoxFit.scaleDown,
                                            //           width: 70,
                                            //           height: 38,
                                            //         ),
                                            //       )
                                            : Text(
                                                '${controller.topUpProducts.value.products![index].name}',
                                                overflow: TextOverflow.ellipsis,
                                                style: kBlackExtraSmallLightMediumStyle,
                                              ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        selectedNetworkType == index ? '${controller.topUpProducts.value.products![index].name}' : '',
                                        style: kBlackExtraSmallLightMediumStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const SizedBox(
                                width: 15,
                              ),
                              itemCount: controller.topUpProducts.value.products!.length,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Insert Your Phone Number:',
                              style: kBlackMediumStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder(
                              stream: userProfileController.contacts.stream,
                              builder: (context, snapshot) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // contact = await Get.to(() => const ContactsScreen());
                                          userProfileController.checkContactPermission(context).then((value) {
                                            // checkContactPermission(context).then((value) {
                                            setState(() {});

                                            // if (_contacts != null) {
                                            if (userProfileController.contacts.isNotEmpty ?? false) {
                                              // String coNo = _contacts!.phones!.first.value!.trim();
                                              String coNo = "${userProfileController.contacts.first.phoneNumbers}";
                                              coNo = coNo.replaceAll('-', '').toString();
                                              coNo = coNo.replaceAll(' ', '').toString();
                                              coNo = coNo.replaceAll('(', '').toString();
                                              coNo = coNo.replaceAll(')', '').toString();
                                              coNo = coNo.replaceAll('[', '').toString();
                                              coNo = coNo.replaceAll(']', '').toString();
                                              coNo = coNo.replaceAll('+6', '').toString();

                                              if (coNo.startsWith('+6')) {
                                                coNo = coNo.substring(2);
                                              }

                                              phoneNoController.text = coNo;
                                              setState(() {});

                                              if ((coNo.trim().length < 10 || coNo.trim().length > 11) || !coNo.trim().startsWith('01')) {
                                                //invalid no
                                                print('INVALID NO');
                                                setState(() {
                                                  isInvalidNo = true;
                                                  isInsertNo = false;
                                                });

                                                return;
                                              }

                                              if (isInsertNo || isInvalidNo) {
                                                setState(() {
                                                  isInsertNo = false;
                                                  isInvalidNo = false;
                                                });
                                              }
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 45,
                                          height: 47,
                                          padding: const EdgeInsets.all(5),
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
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/images/wallet/phonebook.png',
                                              width: 22,
                                              height: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
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
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: TextFormField(
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                  ],
                                                  controller: phoneNoController,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  validator: (value) {
                                                    if (value!.trim().isEmpty) {
                                                      return 'Phone number is required';
                                                    }
                                                    if (!value.trim().startsWith('01')) {
                                                      return 'Phone number is invalid';
                                                    }
                                                    if (value.trim().length < 10 || value.trim().length > 11) {
                                                      return 'Phone number is invalid';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (isInsertNo) {
                                                        isInsertNo = false;
                                                      }
                                                      if (isInvalidNo) {
                                                        isInvalidNo = false;
                                                      }
                                                    });
                                                  },
                                                  enableInteractiveSelection: true,
                                                  style: kBlackMediumStyle,
                                                  textInputAction: TextInputAction.done,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                                    helperStyle: kBlackSmallLightMediumStyle,
                                                    errorStyle: kBlackSmallLightMediumStyle,
                                                    hintStyle: kBlackSmallLightMediumStyle,
                                                    hintText: 'Eg: 0123456789',
                                                    labelStyle: kBlackSmallLightMediumStyle,
                                                    fillColor: kWhite,
                                                    filled: true,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedBorder: InputBorder.none,
                                                    border: InputBorder.none,
                                                    suffixIcon: phoneNoController.text.trim().isNotEmpty
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                phoneNoController.text = '';
                                                              });
                                                              FocusScope.of(context).unfocus();
                                                            },
                                                            child: const Icon(
                                                              Icons.close,
                                                              color: Colors.black38,
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10, right: 5),
                                              child: Text(
                                                isInsertNo
                                                    ? 'Enter Phone Number'
                                                    : isInvalidNo
                                                        ? 'Invalid Phone Number'
                                                        : '',
                                                style: kRedSmallMediumStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          selectedNetworkType == -1
                              ? const SizedBox(
                                  height: 150,
                                )
                              : SizedBox(
                                  height: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          'Choose your amount:',
                                          style: isChooseAmt ? kRedMediumStyle : kBlackMediumStyle,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
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
                                                  style: kBlackMediumStyle,
                                                ),
                                                Text(
                                                  selectedAmt == -1
                                                      ? 'RM 0.00'
                                                      : '${controller.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].currency} ${controller.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].cashbackAmount}',
                                                  style: kPrimaryDarkMediumStyle,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        // width: double.infinity,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedAmt = index;
                                                  amount = controller.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].amount.toString();
                                                  cashbackAmt = controller.topUpProducts.value.products![selectedNetworkType].amounts![selectedAmt].cashbackAmount.toString();

                                                  isChooseAmt = false;
                                                });
                                              },
                                              child: Container(
                                                width: 90,
                                                height: 40,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite,
                                                  border: selectedAmt == index
                                                      ? Border.all(
                                                          color: kColorPrimary,
                                                          width: 1.5,
                                                        )
                                                      : const Border(),
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
                                                    '${controller.topUpProducts.value.products![selectedNetworkType].amounts![index].currency} ${controller.topUpProducts.value.products![selectedNetworkType].amounts![index].amount}',
                                                    style: selectedAmt == index ? kBlackMediumStyle : kBlackLightMediumStyle,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) => const SizedBox(
                                            width: 15,
                                          ),
                                          itemCount: controller.topUpProducts.value.products![selectedNetworkType].amounts!.length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          // Container(
                          //   height: 150,
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
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return const Center(
                          //           child: SizedBox(
                          //             height: 25,
                          //             child: LoadingIndicator(
                          //               indicatorType:
                          //                   Indicator.lineScalePulseOut,
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

                          //       return Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 15),
                          //             child: Text(
                          //               'Choose your amount:',
                          //               style: isChooseAmt
                          //                   ? kRedMediumStyle
                          //                   : kBlackMediumStyle,
                          //             ),
                          //           ),
                          //           const SizedBox(
                          //             height: 20,
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 15),
                          //             child: Row(
                          //               children: [
                          //                 Container(
                          //                   width: 22,
                          //                   height: 22,
                          //                   padding: const EdgeInsets.all(5),
                          //                   decoration: BoxDecoration(
                          //                     boxShadow: [
                          //                       BoxShadow(
                          //                         color: Colors.black
                          //                             .withOpacity(0.1),
                          //                         blurRadius: 5,
                          //                         spreadRadius: 1,
                          //                       ),
                          //                     ],
                          //                     color: kWhite,
                          //                     // color: kWhite,
                          //                     borderRadius:
                          //                         BorderRadius.circular(100),
                          //                   ),
                          //                   child: Center(
                          //                     child: Image.asset(
                          //                       'assets/icons/ic_cashback.png',
                          //                       width: 12,
                          //                       height: 12,
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 const SizedBox(
                          //                   width: 10,
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     Text(
                          //                       'Cash Back: ',
                          //                       style: kBlackMediumStyle,
                          //                     ),
                          //                     Text(
                          //                       selectedAmt == -1
                          //                           ? 'RM 0.00'
                          //                           : '${snapshot.data!.amounts![selectedAmt].currency} ${snapshot.data!.amounts![selectedAmt].cashbackAmount}',
                          //                       style: kPrimaryDarkMediumStyle,
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ],
                          //             ),
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
                          //                   vertical: 7, horizontal: 20),
                          //               itemBuilder: (context, index) {
                          //                 return GestureDetector(
                          //                   onTap: () {
                          //                     setState(() {
                          //                       selectedAmt = index;
                          //                       amount = snapshot
                          //                           .data!
                          //                           .amounts![selectedAmt]
                          //                           .amount
                          //                           .toString();
                          //                       cashbackAmt = snapshot
                          //                           .data!
                          //                           .amounts![selectedAmt]
                          //                           .cashbackAmount
                          //                           .toString();

                          //                       isChooseAmt = false;
                          //                     });
                          //                   },
                          //                   child: Container(
                          //                     width: 90,
                          //                     height: 40,
                          //                     padding:
                          //                         const EdgeInsets.symmetric(
                          //                             horizontal: 10,
                          //                             vertical: 5),
                          //                     decoration: BoxDecoration(
                          //                       borderRadius:
                          //                           BorderRadius.circular(10),
                          //                       color: kWhite,
                          //                       border: selectedAmt == index
                          //                           ? Border.all(
                          //                               color: kColorPrimary,
                          //                               width: 1.5,
                          //                             )
                          //                           : const Border(),
                          //                       boxShadow: [
                          //                         BoxShadow(
                          //                           color: selectedAmt == index
                          //                               ? kColorPrimary
                          //                                   .withOpacity(0.4)
                          //                               : Colors.black
                          //                                   .withOpacity(0.2),
                          //                           blurRadius: 6,
                          //                           spreadRadius: 2,
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     child: Center(
                          //                       child: Text(
                          //                         '${snapshot.data!.amounts![index].currency} ${snapshot.data!.amounts![index].amount}',
                          //                         style: selectedAmt == index
                          //                             ? kBlackMediumStyle
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
                          //               itemCount:
                          //                   snapshot.data!.amounts!.length,
                          //             ),
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GradientButton(
                              text: 'Continue',
                              width: false,
                              widthSize: Get.width,
                              buttonState: btnState,
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                if (selectedNetworkType == -1) {
                                  setState(() {
                                    isSelectNetworkType = true;
                                  });
                                  // errorSnackbar(
                                  //     title: 'Failed',
                                  //     subtitle: 'Enter phone number to proceed!');
                                  return;
                                } else if (phoneNoController.text.trim().isEmpty) {
                                  setState(() {
                                    isInsertNo = true;
                                  });
                                  // errorSnackbar(
                                  //     title: 'Failed',
                                  //     subtitle: 'Enter phone number to proceed!');
                                  return;
                                } else if (phoneNoController.text.trim().length < 10 || phoneNoController.text.trim().length > 11 || !phoneNoController.text.trim().startsWith('01')) {
                                  setState(() {
                                    isInvalidNo = true;
                                  });
                                  // errorSnackbar(
                                  //     title: 'Failed',
                                  //     subtitle: 'Phone number is invalid!');
                                  return;
                                }

                                if (amount == null) {
                                  setState(() {
                                    isChooseAmt = true;
                                  });
                                  // errorSnackbar(
                                  //     title: 'Failed',
                                  //     subtitle: 'Select amount and network!');
                                } else {
                                  showTopupSheet();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Expanded(
                  child: GetX<TopUpController>(
                    init: topUpController,
                    builder: (controller) {
                      if (controller.isFetchingRecentTopUp.value || controller.recentTopUp.value.data == null) {
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
                      if (controller.recentTopUp.value.status != 200) {
                        return Center(
                          child: SizedBox(
                            height: 35,
                            child: Text(
                              controller.recentTopUp.value.message!,
                              style: kBlackSmallMediumStyle,
                            ),
                          ),
                        );
                      }
                      if (controller.recentTopUp.value.data!.isEmpty) {
                        return Center(
                          child: SizedBox(
                            height: 35,
                            child: Text(
                              'No recent top up found!',
                              style: kBlackSmallMediumStyle,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              processingDialog(title: 'Fetching data..Please wait!', context: context);

                              recentTopUpAmounts = await getTopUpRecentAmounts({"product_id": "${controller.recentTopUp.value.data![index].others!.productId}"});

                              Get.back();

                              if (recentTopUpAmounts == null) {
                                errorSnackbar(title: 'Failed', subtitle: 'Unable to fetch topup details!');
                                return;
                              }

                              int amountIndex = 0;

                              for (var i = 0; i < recentTopUpAmounts!.amounts!.length; i++) {
                                if (double.parse(recentTopUpAmounts!.amounts![i].amount.toString()).toStringAsFixed(2) == controller.recentTopUp.value.data![index].amount.toString()) {
                                  amountIndex = i;
                                  break;
                                }
                              }

                              showTopupSheetRecent(
                                controller.recentTopUp.value.data![index],
                                amountIndex,
                              );
                            },
                            child: RecentTopUpItem(
                              recentTopUpData: controller.recentTopUp.value.data![index],
                              onDelete: () async {
                                await deleteDialog(
                                  title: 'Are you sure you wish to remove ${controller.recentTopUp.value.data![index].others!.productName} from the recent list?',
                                  buttonTitle: 'Yes',
                                  buttonTitle2: 'No',
                                  image: 'assets/icons/ic_remove.png',
                                  context: context,
                                  onTapYes: () async {
                                    Get.back();

                                    processingDialog(title: 'Removing recent topup...\nPlease wait', context: context);

                                    var res = await TopUpController().removeRecentTopUp({"transaction_id": "${controller.recentTopUp.value.data![index].transactionId}"});

                                    Get.back();
                                    if (res!.isEmpty) {
                                      //added
                                      topUpController.getRecentTopUp({});
                                    } else {
                                      errorSnackbar(title: 'Failed', subtitle: res);
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        itemCount: controller.recentTopUp.value.data!.length,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
