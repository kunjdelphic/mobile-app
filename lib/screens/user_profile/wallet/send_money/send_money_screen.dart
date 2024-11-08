import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/send_money_recent_list.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/wallet_activation/ew_1_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/send_money/contacts_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

import 'all_recently_sent_screen.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({Key? key}) : super(key: key);

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final WalletController walletController = Get.find();
  final UserProfileController userProfileController = Get.find();
  // final WalletController walletController = Get.put(WalletController());
  // final UserProfileController userProfileController =
  //     Get.put(UserProfileController());

  String? phoneNo, amount, countryCode;
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState btnState = ButtonState.idle;
  SendMoneyRecentListData? selectedUserData;
  Contact? contact;
  bool isSentMoney = false;

  @override
  void initState() {
    super.initState();

    walletController.getSendMoneyRecentList({});
    walletController.getMainWalletReload({});
  }

  sendMoney() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        btnState = ButtonState.loading;
      });

      countryCode ??= Config().countryCode;

      print({
        "amount": amount,
        "phone_number": phoneNo,
        "country_code": countryCode,
      });

      var res = await walletController.sendMoney({
        "amount": amount,
        "phone_number": phoneNo,
        "country_code": countryCode,
      });

      setState(() {
        btnState = ButtonState.idle;
      });

      if (res!.isEmpty) {
        //sent
        walletController.updateWalletBalance({});
        walletController.updateMainWalletReload({});
        userProfileController.getUserDetails();

        setState(() {
          isSentMoney = true;
        });
      } else {
        if (res != 'Server Maintenance InProgress') {
          errorSnackbar(title: 'Failed', subtitle: res);
        }
      }
    }
  }

  showSendSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: kDarkWhite,
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 1.5,
                  color: Colors.black26,
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(
              //       icon: const Icon(
              //         Icons.close,
              //       ),
              //       onPressed: () {
              //         Get.back();
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: Get.width,
                padding: const EdgeInsets.all(15),
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Stack(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
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
                            child: CircleAvatar(
                              backgroundColor: kWhite,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.network(
                                  selectedUserData?.profileImage ?? '',
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/logo/parrot_logo.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              padding: const EdgeInsets.all(4),
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
                                  'assets/icons/send_money.png',
                                ),
                              ),
                            ),
                          ),
                        ],
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
                            'SEND MONEY',
                            style: kBlackSmallMediumStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            selectedUserData?.name ?? 'NA',
                            style: kBlackExtraSmallLightMediumStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${phoneNo}',
                            style: kBlackExtraSmallLightMediumStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      selectedUserData != null
                          ? '${selectedUserData!.currency} ${double.parse(amount!).toStringAsFixed(2)}'
                          : '${Config().currencyCode} ${double.parse(amount!).toStringAsFixed(2)}',
                      style: kPrimaryDarkExtraLargeStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Payment Method',
                textAlign: TextAlign.start,
                style: kBlackMediumStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              GetX<WalletController>(
                init: walletController,
                builder: (controller) {
                  if (controller.isFetching.value ||
                      controller.mainWalletReload.value.userDetails!
                              .mainWalletAmount ==
                          null) {
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
                    onTap: () {
                      // Get.to(() => const WalletScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
                text: 'Send Now',
                width: true,
                widthSize: Get.width * 0.7,
                buttonState: btnState,
                onTap: () {
                  Get.back();
                  sendMoney();
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
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
          "Send Money",
          style: kBlackLargeStyle,
        ),
      ),
      body: isSentMoney
          ? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Center(
                  child: Text(
                    'Money Sent !',
                    style: kBlackSuperLargeStyle,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/wallet/sent_money.png',
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Center(
                    child: Text(
                      'Your money has been sent successfully.',
                      textAlign: TextAlign.center,
                      style: kBlackLargeStyle,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                        color: Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: Get.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/add_to_favorite.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Add This To Favorites',
                            style: kBlackMediumStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GradientButton(
                  text: 'Close',
                  width: true,
                  widthSize: Get.width * 0.85,
                  buttonState: ButtonState.idle,
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            )
          : GetX<UserProfileController>(
              init: userProfileController,
              initState: (_) {},
              builder: (_) {
                return _.userProfile.value.data?.accountStatus == 'RESUBMIT' ||
                        _.userProfile.value.data?.accountStatus == 'PENDING' ||
                        _.userProfile.value.data?.accountStatus ==
                            'NOT_APPROVED'
                    ? ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        children: [
                          Center(
                            child: Text(
                              'Activate Earning Wallet',
                              style: kRedSuperLargeStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            'assets/images/wallet/send_money_ew_activate.png',
                            width: Get.width * 0.6,
                            height: Get.width * 0.6,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Center(
                              child: Text(
                                'Before making this transaction, please activate your earning wallet.',
                                textAlign: TextAlign.center,
                                style: kBlackMediumStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GradientButton(
                            text: 'Activate Now',
                            width: true,
                            widthSize: Get.width * 0.85,
                            buttonState: ButtonState.idle,
                            onTap: () async {
                              if (_.userProfile.value.data?.accountStatus ==
                                  'PENDING') {
                                errorSnackbar(
                                    title: 'Failed',
                                    subtitle: 'Verification in progress!');
                              } else {
                                await Get.to(() => const EW1Screen());
                                userProfileController.getUserDetails();
                              }
                            },
                          ),
                        ],
                      )
                    : GetX<WalletController>(
                        init: walletController,
                        builder: (controller) {
                          print('HERE');
                          print(
                              'RES :: ${controller.isFetchingRecentList.value} ,,,,, ${controller.sendMoneyRecentList.value.data}');
                          if (controller.isFetchingRecentList.value ||
                              controller.sendMoneyRecentList.value.data ==
                                  null) {
                            return const Center(
                              child: SizedBox(
                                height: 25,
                                child: LoadingIndicator(
                                  indicatorType:
                                      Indicator.lineScalePulseOutRapid,
                                  colors: [
                                    kAccentColor,
                                  ],
                                ),
                              ),
                            );
                          }
                          if (controller.sendMoneyRecentList.value.status !=
                              200) {
                            return Center(
                              child: SizedBox(
                                height: 35,
                                child: Text(
                                  controller.sendMoneyRecentList.value.message!,
                                  style: kBlackSmallMediumStyle,
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Form(
                              key: _formKey,
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                children: [
                                  controller.sendMoneyRecentList.value.data!
                                          .isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Recently sent money',
                                              style: kBlackMediumStyle,
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            SizedBox(
                                              height: 100,
                                              child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                padding:
                                                    const EdgeInsets.all(0),
                                                itemBuilder: (context, index) {
                                                  if (index == 3) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            var res = await Get
                                                                .to(() =>
                                                                    AllRecentlySentScreen(
                                                                      recentlySent: controller
                                                                          .sendMoneyRecentList
                                                                          .value
                                                                          .data,
                                                                    ));

                                                            if (res != null) {
                                                              setState(() {
                                                                phoneNoController
                                                                        .text =
                                                                    // controller
                                                                    //         .sendMoneyRecentList
                                                                    //         .value
                                                                    //         .data![index]
                                                                    //         .countryCode! +
                                                                    res.phoneNumber!;

                                                                countryCode = res
                                                                    .countryCode!;

                                                                selectedUserData =
                                                                    res;
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                              width: 60,
                                                              height: 60,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        5,
                                                                    spreadRadius:
                                                                        1,
                                                                  ),
                                                                ],
                                                                color: kWhite,
                                                                // color: kWhite,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                              ),
                                                              child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                color: Colors
                                                                    .black54,
                                                                size: 22,
                                                              )),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return GestureDetector(
                                                    onTap: () {
                                                      phoneNoController.text =
                                                          // controller
                                                          //         .sendMoneyRecentList
                                                          //         .value
                                                          //         .data![index]
                                                          //         .countryCode! +
                                                          controller
                                                              .sendMoneyRecentList
                                                              .value
                                                              .data![index]
                                                              .phoneNumber!;

                                                      countryCode = controller
                                                          .sendMoneyRecentList
                                                          .value
                                                          .data![index]
                                                          .countryCode!;

                                                      selectedUserData =
                                                          controller
                                                              .sendMoneyRecentList
                                                              .value
                                                              .data![index];
                                                    },
                                                    child: SizedBox(
                                                      width: 60,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width: 60,
                                                                height: 60,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                      blurRadius:
                                                                          5,
                                                                      spreadRadius:
                                                                          1,
                                                                    ),
                                                                  ],
                                                                  color: kWhite,
                                                                  // color: kWhite,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  // backgroundColor:
                                                                  //     kWhite,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child: Image
                                                                      .network(
                                                                    controller
                                                                            .sendMoneyRecentList
                                                                            .value
                                                                            .data![index]
                                                                            .profileImage ??
                                                                        '',
                                                                    errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        Image
                                                                            .asset(
                                                                      'assets/images/logo/parrot_logo.png',
                                                                      // width:
                                                                      //     30,
                                                                      // height:
                                                                      //     30,
                                                                      // fit: BoxFit
                                                                      //     .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                bottom: 0,
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.1),
                                                                        blurRadius:
                                                                            5,
                                                                        spreadRadius:
                                                                            1,
                                                                      ),
                                                                    ],
                                                                    color:
                                                                        kWhite,
                                                                    // color: kWhite,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                  ),
                                                                  child: Center(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/icons/send_money.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            '${controller.sendMoneyRecentList.value.data![index].name}',
                                                            style:
                                                                kBlackSmallMediumStyle,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                  width: 15,
                                                ),
                                                itemCount: controller
                                                            .sendMoneyRecentList
                                                            .value
                                                            .data!
                                                            .length >
                                                        3
                                                    ? 4
                                                    : controller
                                                        .sendMoneyRecentList
                                                        .value
                                                        .data!
                                                        .length,
                                              ),
                                            ),
                                            const Divider(thickness: 0.30),
                                          ],
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Phone number',
                                    style: kBlackMediumStyle,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          // contact = await Get.to(
                                          //     () => const ContactsScreen());
                                          // if (contact != null) {
                                          //   phoneNoController.text = contact!
                                          //       .phones!.first.value!
                                          //       .replaceAll('-', '')
                                          //       .toString();
                                          // }

                                          contact = await Get.to(
                                              () => const ContactsScreen());
                                          if (contact != null) {
                                            String coNo = contact!
                                                .phones!.first.value!
                                                .trim();
                                            coNo = coNo
                                                .replaceAll('-', '')
                                                .toString();
                                            coNo = coNo
                                                .replaceAll(' ', '')
                                                .toString();
                                            coNo = coNo
                                                .replaceAll('(', '')
                                                .toString();
                                            coNo = coNo
                                                .replaceAll(')', '')
                                                .toString();

                                            if (coNo.startsWith('+6')) {
                                              coNo = coNo.substring(2);
                                            }

                                            phoneNoController.text = coNo;

                                            // if ((coNo.trim().length < 10 ||
                                            //         coNo.trim().length > 11) ||
                                            //     !coNo.trim().startsWith('01')) {
                                            //   //invalid no
                                            //   print('INVALID NO');
                                            //   setState(() {
                                            //     isInvalidNo = true;
                                            //     isInsertNo = false;
                                            //   });

                                            //   return;
                                            // }

                                            // if (isInsertNo || isInvalidNo) {
                                            //   setState(() {
                                            //     isInsertNo = false;
                                            //     isInvalidNo = false;
                                            //   });
                                            // }

                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: 45,
                                          height: 47,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                            color: kWhite,
                                            // color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                            color: kWhite,
                                            // color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: TextFormField(
                                              controller: phoneNoController,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              validator: (value) {
                                                if (value!.trim().isEmpty) {
                                                  return 'Phone number is required';
                                                }
                                                if (!value
                                                    .trim()
                                                    .startsWith('01')) {
                                                  return 'Phone number is invalid';
                                                }
                                                if (value.trim().length < 10 ||
                                                    value.trim().length > 11) {
                                                  return 'Phone number is invalid';
                                                }
                                                return null;
                                              },
                                              onSaved: (val) {
                                                phoneNo = val!.trim();
                                                phoneNo = '$phoneNo';
                                              },
                                              enableInteractiveSelection: true,
                                              style: kBlackMediumStyle,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 14),
                                                helperStyle:
                                                    kBlackSmallLightMediumStyle,
                                                errorStyle:
                                                    kBlackSmallLightMediumStyle,
                                                hintStyle:
                                                    kBlackSmallLightMediumStyle,
                                                hintText: 'Eg: 0123456789',
                                                labelStyle:
                                                    kBlackSmallLightMediumStyle,
                                                fillColor: kWhite,
                                                filled: true,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Enter the amount',
                                    style: kBlackMediumStyle,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
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
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            '${_.userProfile.value.data?.currency}'),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: 1.5,
                                          height: 30,
                                          color: Colors.black12,
                                        ),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: TextFormField(
                                              controller: amountController,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              validator: (value) {
                                                if (value!.trim().isEmpty) {
                                                  return 'Amount is required';
                                                }

                                                return null;
                                              },
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9 .]')),
                                              ],
                                              onSaved: (val) {
                                                amount = val!.trim();
                                              },
                                              enableInteractiveSelection: true,
                                              style: kBlackMediumStyle,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 14),
                                                helperStyle:
                                                    kBlackSmallLightMediumStyle,
                                                errorStyle:
                                                    kBlackSmallLightMediumStyle,
                                                hintStyle:
                                                    kBlackSmallLightMediumStyle,
                                                // hintText: 'Eg: 50',
                                                labelStyle:
                                                    kBlackSmallLightMediumStyle,
                                                fillColor: kWhite,
                                                filled: true,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1.5,
                                          height: 30,
                                          color: Colors.black12,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            amountController.clear();
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.black38,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  GradientButton(
                                    text: 'Next',
                                    width: true,
                                    widthSize: Get.width,
                                    buttonState: btnState,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        FocusScope.of(context).unfocus();

                                        if (selectedUserData == null &&
                                            amount == null &&
                                            phoneNo == null) {
                                          errorSnackbar(
                                              title: 'Failed',
                                              subtitle:
                                                  'Enter phone number & amount or select from recent list!');
                                        } else {
                                          showSendSheet();
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
    );
  }
}
