import 'package:carousel_slider/carousel_slider.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/bill_payment_controller.dart';
import 'package:parrotpos/controllers/donation_controller.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/controllers/notification_controller.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/top_up_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/screens/all_extra_guides_screen.dart';
import 'package:parrotpos/screens/donation/donation_screen.dart';
import 'package:parrotpos/screens/favorite/favorite_screen.dart';
import 'package:parrotpos/screens/notification/notification_screen.dart';
import 'package:parrotpos/screens/promotions_detail_screen.dart';
import 'package:parrotpos/screens/top_up/top_up_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/wallet_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/internet_controller.dart';
import '../widgets/dialogs/common_dialogs.dart';
import 'bill_payment/main_bill_payment_screen.dart';
import 'donation/fund_result_screen.dart';
import 'donation/home_screen_carousel.dart';
import 'error_screens/no_internet.dart';
import 'extra_guide_detail_screen.dart';
import 'notification/notification_notenable.dart';
import 'notification/server_maintainance_screen.dart';
import 'user_profile/report_and_feedback/feedback_screen.dart';
import 'user_profile/user_profile_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final UserProfileController userProfileController = Get.put(UserProfileController());
  final WalletController walletController = Get.put(WalletController());
  final ReferralController referralController = Get.put(ReferralController());
  final TopUpController topUpController = Get.put(TopUpController());
  final FavoriteController favoriteController = Get.put(FavoriteController());
  final DonationController donationController = Get.put(DonationController());
  final BillPaymentController billPaymentController = Get.put(BillPaymentController());
  final NotificationController notificationController = Get.put(NotificationController());

  int _current = 0;
  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    userProfileController.getUserDetails();
    donationController.getDonation();
    Future.delayed(
      Duration(seconds: 1),
      () {
        userProfileController.versionMatch(context);
      },
    );
    Future.delayed(
      Duration.zero,
      () async {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        final String? token = await messaging.getToken();
        notificationController.updateUserNotification(token: "${token}");
      },
    );

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _internet = Get.put(InternetController());
    RemoteService.checkServer();
    return Scaffold(
        body: DoubleBack(
      message: "Press again to exit",
      textStyle: kWhiteMediumStyle,
      child: Column(
        children: [
          Expanded(
            child: GetX<UserProfileController>(
              init: userProfileController,
              builder: (controller) {
                if ((controller.isFetching.value && controller.userProfile.value.data == null)) {
                  return Column(
                    children: [
                      const SizedBox(height: 3),
                      Container(
                        decoration: const BoxDecoration(
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Icon(
                                  Icons.more_vert_outlined,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Get.to(() => const UserProfileScreen());
                                },
                                child: Container(
                                    width: 45,
                                    height: 45,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: kWhite,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade50,
                                          child: Image.asset(
                                            'assets/images/logo/parrot_logo.png',
                                            fit: BoxFit.contain,
                                            color: Colors.grey,
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    )

                                    // child: Shimmer.fromColors(
                                    //   baseColor: Colors.grey.shade200,
                                    //   highlightColor: Colors.grey.shade50,
                                    //   child: Container(
                                    //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
                                    //   ),
                                    // ),
                                    ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Get.to(() => const UserProfileScreen());
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello!',
                                      style: kBlackDarkMediumStyle,
                                    ),
                                    Text(
                                      '  ',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/icons/notification/ic_no_notif.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: Container(
                                        width: 15,
                                        height: 15,
                                        color: Colors.grey.shade100,
                                      )),
                                    ),
                                    Container(
                                      color: Colors.transparent,
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                        child: Icon(
                                          Icons.support_agent,
                                          size: 18,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/icons/notification/ic_no_notif.png',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      Expanded(
                        // child: Center(
                        //   child: Center(
                        //     child: SizedBox(
                        //       height: 25,
                        //       child: LoadingIndicator(
                        //         indicatorType: Indicator.lineScalePulseOut,
                        //         colors: [
                        //           kAccentColor,
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        child: beforeLoading(context),
                      ),
                    ],
                  );
                }
                if (controller.userProfile.value.data == null) {
                  return NoInternet();
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(bottom: 6),
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Icon(
                                  Icons.more_vert_outlined,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Get.to(() => const UserProfileScreen());
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Center(child: Container(color: Colors.black)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Get.to(() => const UserProfileScreen());
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello!',
                                      style: kBlackDarkMediumStyle,
                                    ),
                                    Text(
                                      '---',
                                      style: kBlackSmallMediumStyle,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Image.asset(
                                'assets/icons/notification/ic_no_notif.png',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Failed to fetch!',
                            style: kBlackMediumStyle,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: 3),
                    Container(
                      decoration: const BoxDecoration(
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(bottom: 6),
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const UserProfileScreen());
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                child: Icon(
                                  Icons.more_vert_outlined,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const UserProfileScreen());
                              },
                              child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Obx(() => true ?? controller.userProfile.value.data!.profileImage != "https://parrotpostest.blob.core.windows.net/images/no_image.svg"
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: CachedNetworkImage(
                                                  imageUrl: controller.userProfile.value.data!.profileImage.toString(),
                                                  errorWidget: (context, url, error) {
                                                    return Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: Image.asset(
                                                        "assets/images/logo/parrot_logo.png",
                                                        fit: BoxFit.contain,
                                                        // color: Colors.grey,
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    );
                                                  },
                                                  placeholder: (c, s) {
                                                    return Shimmer.fromColors(
                                                      baseColor: Colors.grey.shade200,
                                                      highlightColor: Colors.grey.shade50,
                                                      child: Image.asset(
                                                        'assets/images/logo/parrot_logo.png',
                                                        fit: BoxFit.contain,
                                                        color: Colors.grey,
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                      // child: Container(
                                                      //   // height: 30,
                                                      //   // width: 30,
                                                      //   // margin: EdgeInsets.symmetric(horizontal: 5),
                                                      //   decoration: BoxDecoration(
                                                      //     borderRadius: BorderRadius.circular(12),
                                                      //     image: DecorationImage(image: Image.asset(
                                                      //       'assets/images/logo/parrot_logo.png',
                                                      //       fit: BoxFit.cover,
                                                      //       color: Colors.grey,
                                                      //       // height: 30,
                                                      //       // width: 30,
                                                      //     ).image),
                                                      //   ),),
                                                    );
                                                    return Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white));
                                                  }))
                                          : Container(
                                              child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Image.asset(
                                                "assets/images/logo/parrot_logo.png",
                                              ),
                                            )))
                                      // child: Obx(() {
                                      // return CircleAvatar(
                                      //   backgroundColor: Colors.white,
                                      //   // child: CachedNetworkImage(
                                      //   imageUrl: controller.userProfile
                                      //       .value.data!.profileImage
                                      //       .toString(),
                                      //   errorWidget: (context, url, error) {
                                      //     return Image.asset(
                                      //         "assets/images/logo/parrot_logo.png");
                                      //   },
                                      //   placeholder: (c, s) {
                                      //     return Shimmer.fromColors(
                                      //         baseColor:
                                      //             Colors.grey.shade200,
                                      //         highlightColor:
                                      //             Colors.grey.shade50,
                                      //         child: Container(
                                      //             color: Colors.white));
                                      //   }));
                                      //  );
                                      // return CircleAvatar(
                                      //   backgroundColor: kWhite,
                                      //   child: userProfileController.userProfile
                                      //               .value.data!.profileImage ==
                                      //           'https://parrotpostest.blob.core.windows.net/images/no_image.svg'
                                      //       ? Image.asset(
                                      //           'assets/images/referral/ic_profile.png',
                                      //         )
                                      //       : FadeInImage.assetNetwork(
                                      //           placeholder:
                                      //               'assets/images/referral/ic_profile.png',
                                      //           placeholderScale: 0.5,
                                      //           imageErrorBuilder: (context,
                                      //                   error, stackTrace) =>
                                      //               FadeInImage.assetNetwork(
                                      //             placeholder:
                                      //                 'assets/images/referral/ic_profile.png',
                                      //             placeholderScale: 0.5,
                                      //             imageErrorBuilder: (context,
                                      //                     error, stackTrace) =>
                                      //                 Image.asset(
                                      //               'assets/images/referral/ic_profile.png',
                                      //             ),
                                      //             image: controller.userProfile
                                      //                 .value.data!.profileImage!,
                                      //             fit: BoxFit.cover,
                                      //             fadeInDuration: const Duration(
                                      //                 milliseconds: 250),
                                      //             fadeInCurve: Curves.easeInOut,
                                      //             fadeOutDuration: const Duration(
                                      //                 milliseconds: 150),
                                      //             fadeOutCurve: Curves.easeInOut,
                                      //           ),
                                      //           image: controller.userProfile
                                      //               .value.data!.profileImage!,
                                      //           fit: BoxFit.cover,
                                      //           fadeInDuration: const Duration(
                                      //               milliseconds: 250),
                                      //           fadeInCurve: Curves.easeInOut,
                                      //           fadeOutDuration: const Duration(
                                      //               milliseconds: 150),
                                      //           fadeOutCurve: Curves.easeInOut,
                                      //         ),
                                      //     // );
                                      //   }),
                                      // ),
                                      )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const UserProfileScreen());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello!',
                                    style: kBlackDarkMediumStyle,
                                  ),
                                  Text(
                                    controller.userProfile.value.data?.name ?? "----",
                                    style: kBlackSmallMediumStyle,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const FeedbackScreen());
                              },
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/icons/notification/ic_no_notif.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                        child: Container(
                                      width: 15,
                                      height: 15,
                                      color: Colors.grey.shade100,
                                    )),
                                  ),
                                  Container(
                                    color: Colors.transparent,
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child: Icon(
                                        Icons.support_agent,
                                        size: 18,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Future<void> checkPermission() async {
                                var status = await Permission.notification.status;
                                if (status.isGranted) {
                                  Get.to(() => NotificationScreen());
                                } else {
                                  Get.to(() => const NotificationNotEnable());
                                }
                                // Get.to(() => const NotificationScreen());
                              },
                              child: Image.asset(
                                'assets/icons/notification/ic_no_notif.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            // GestureDetector(
                            //   onTap: () async {},
                            //   child: Container(
                            //     height: 40,
                            //     width: 40,
                            //     margin: const EdgeInsets.only(right: 12),
                            //     child: Stack(
                            //       alignment: Alignment.center,
                            //       children: [
                            //         Container(
                            //           height: 36,
                            //           width: 36,
                            //           decoration: BoxDecoration(
                            //             color: kWhite,
                            //             borderRadius:
                            //                 BorderRadius.circular(10),
                            //             boxShadow: [
                            //               BoxShadow(
                            //                 color: kColorPrimary
                            //                     .withOpacity(0.3),
                            //                 blurRadius: 3,
                            //                 spreadRadius: 0.5,
                            //               )
                            //             ],
                            //             border: Border.all(
                            //               width: 1,
                            //               color: kColorPrimary,
                            //             ),
                            //           ),
                            //           child: const Icon(
                            //             Icons.notifications,
                            //             color: kColorPrimary,
                            //             size: 21,
                            //           ),
                            //         ),
                            //         // Positioned(
                            //         //   right: 0,
                            //         //   top: 0,
                            //         //   child: Container(
                            //         //     decoration: BoxDecoration(
                            //         //       borderRadius:
                            //         //           BorderRadius.circular(100),
                            //         //       color: kWhite,
                            //         //       boxShadow: [
                            //         //         BoxShadow(
                            //         //           color: kColorPrimary
                            //         //               .withOpacity(0.3),
                            //         //           blurRadius: 3,
                            //         //           spreadRadius: 0.5,
                            //         //         )
                            //         //       ],
                            //         //     ),
                            //         //     width: 12,
                            //         //     height: 12,
                            //         //     child: const Center(
                            //         //       child: CircleAvatar(
                            //         //         radius: 4.5,
                            //         //         backgroundColor: kColorPrimary,
                            //         //       ),
                            //         //     ),
                            //         //   ),
                            //         // ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            userProfileController.getUserDetails();
                            donationController.getDonation();
                          });
                          // userProfileController.getUserDetails();
                          print("+++++ ${userProfileController.getUserDetails()}");
                          return;
                        },
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const WalletScreen());
                              },
                              child: Container(
                                // height: 115,
                                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  'Created on ${CommonTools().getDate(userProfileController.userProfile.value.data!.joiningTimestamp!)}',
                                                  style: kWhiteSmallMediumStyle,
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
                                                  '${userProfileController.userProfile.value.data!.currency} ${userProfileController.userProfile.value.data!.mainWalletBalance}',
                                                  style: kWhiteDarkSuperLargeStyle,
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  '+ Reload Wallet',
                                                  style: kWhiteMediumStyle,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const FundResultScreen());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width * 0.18,
                                          height: Get.width * 0.18,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/main_donate.svg',
                                              width: Get.width * 0.18,
                                              height: Get.width * 0.18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Donate',
                                          style: kBlackMediumStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const MainBillPaymentScreen());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width * 0.18,
                                          height: Get.width * 0.18,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/main_bill.svg',
                                              width: Get.width * 0.18,
                                              height: Get.width * 0.18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Bill Payment',
                                          style: kBlackMediumStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(milliseconds: 1000),
                                          backgroundColor: kColorPrimary,
                                          content: Text(
                                            'Coming soon!',
                                            style: kWhiteDarkMediumStyle,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width * 0.18,
                                          height: Get.width * 0.18,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/main_other.svg',
                                              width: Get.width * 0.18,
                                              height: Get.width * 0.18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Others',
                                          style: kBlackMediumStyle,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const TopUpScreen());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width * 0.18,
                                          height: Get.width * 0.18,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/main_topup.svg',
                                              width: Get.width * 0.18,
                                              height: Get.width * 0.18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Topup',
                                          style: kBlackMediumStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.to(() => const FavoriteScreen()),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: Get.width * 0.18,
                                          height: Get.width * 0.18,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF6F6F6),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icons/main_favorite.svg',
                                              width: Get.width * 0.18,
                                              height: Get.width * 0.18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Favorite',
                                          style: kBlackMediumStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: Get.width * 0.18,
                                        height: Get.width * 0.18,
                                        padding: const EdgeInsets.all(20),
                                        // decoration: BoxDecoration(
                                        //   color: const Color(0xffF6F6F6),
                                        //   borderRadius: BorderRadius.circular(10),
                                        // ),
                                        // child: Center(
                                        //   child: SvgPicture.asset(
                                        //     'assets/icons/main_other.svg',
                                        //     width: Get.width * 0.18,
                                        //     height: Get.width * 0.18,
                                        //   ),
                                        // ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Text(
                                      //   'Others',
                                      //   style: kBlackMediumStyle,
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              thickness: 0.30,
                              indent: 20,
                              endIndent: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            userProfileController.userProfile.value.data!.promotions!.isNotEmpty
                                ? Column(
                                    children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          height: Get.height * 0.2,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          viewportFraction: 0.7,
                                          initialPage: 3,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                        carouselController: carouselController,

                                        items: userProfileController.userProfile.value.data!.promotions!
                                            .map((e) => GestureDetector(
                                                  onTap: () {
                                                    Get.to(
                                                      () => PromotionsDetailScreen(
                                                        extraGuides: e,
                                                      ),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: CachedNetworkImage(
                                                      imageUrl: e.image!,
                                                      fit: BoxFit.cover,
                                                      placeholder: (c, s) {
                                                        return Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white));
                                                      },
                                                      errorWidget: (context, error, stackTrace) => const Icon(
                                                        Icons.error,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        // [1, 2, 3].map((i) {
                                        //   return Builder(
                                        //     builder: (BuildContext context) {
                                        //       return ClipRRect(
                                        //         borderRadius: BorderRadius.circular(20),
                                        //         child: Image.asset(
                                        //           'assets/images/dashboard/main_$i.png',
                                        //           fit: BoxFit.contain,
                                        //         ),
                                        //       );
                                        //     },
                                        //   );
                                        // }).toList(),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: userProfileController.userProfile.value.data!.promotions!.asMap().entries.map((entry) {
                                          return GestureDetector(
                                            onTap: () => carouselController.animateToPage(entry.key),
                                            child: Container(
                                              width: 12.0,
                                              height: 3.0,
                                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(2),
                                                  shape: BoxShape.rectangle,
                                                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      CarouselSlider(
                                        options: CarouselOptions(
                                          height: Get.height * 0.2,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          viewportFraction: 0.7,
                                          initialPage: 3,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                        carouselController: carouselController,
                                        items: [1, 2, 3]
                                            .map((e) => GestureDetector(
                                                  onTap: () {},
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white))),
                                                ))
                                            .toList(),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: userProfileController.userProfile.value.data!.promotions!.asMap().entries.map((entry) {
                                          return GestureDetector(
                                            onTap: () => carouselController.animateToPage(entry.key),
                                            child: Container(
                                              width: 12.0,
                                              height: 3.0,
                                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(2),
                                                  shape: BoxShape.rectangle,
                                                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                            const HomeScreenCarousel(),
                            // shimmer end,
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Extra Guides',
                                    style: kBlackDarkExtraLargeStyle, //kBlackDarkSuperLargeStyle,
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Get.to(() => const AllExtraGuidesScreen());
                                  //   },
                                  //   child: Text(
                                  //     'View All',
                                  //     style: kBlackLightMediumStyle,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            userProfileController.userProfile.value.data!.extraGuides!.isNotEmpty
                                ?
                                // GridView.builder(
                                //         gridDelegate:
                                //             const SliverGridDelegateWithFixedCrossAxisCount(
                                //           crossAxisCount: 2,
                                //           childAspectRatio: 0.8,
                                //           crossAxisSpacing: 15,
                                //           mainAxisSpacing: 15,
                                //         ),
                                //         shrinkWrap: true,
                                //         physics:
                                //             const NeverScrollableScrollPhysics(),
                                //         padding: const EdgeInsets.symmetric(
                                //           horizontal: 16,
                                //           vertical: 6,
                                //         ),
                                //         itemBuilder: (context, index) =>
                                //             GestureDetector(
                                //           onTap: () {
                                //             Get.to(
                                //               () => ExtraGuideDetailScreen(
                                //                 extraGuides: userProfileController
                                //                     .userProfile
                                //                     .value
                                //                     .data!
                                //                     .extraGuides![index],
                                //               ),
                                //             );
                                //           },
                                //           child: Container(
                                //             width: Get.width,
                                //             decoration: BoxDecoration(
                                //               borderRadius:
                                //                   BorderRadius.circular(18),
                                //               color: kWhite,
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                   color: Colors.black
                                //                       .withOpacity(0.08),
                                //                   spreadRadius: 1,
                                //                   blurRadius: 6,
                                //                 ),
                                //               ],
                                //             ),
                                //             child: Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Expanded(
                                //                   child: ClipRRect(
                                //                     borderRadius:
                                //                         BorderRadius.circular(18),
                                //                     child: CachedNetworkImage(
                                //                       imageUrl:
                                //                           userProfileController
                                //                                   .userProfile
                                //                                   .value
                                //                                   .data!
                                //                                   .extraGuides![
                                //                                       index]
                                //                                   .image ??
                                //                               '',
                                //                       placeholder: (context, url) {
                                //                         return Shimmer.fromColors(
                                //                             child: Container(
                                //                                 color:
                                //                                     Colors.white),
                                //                             baseColor: Colors
                                //                                 .grey.shade200,
                                //                             highlightColor: Colors
                                //                                 .grey.shade50);
                                //                       },
                                //                       errorWidget: (context, error,
                                //                               stackTrace) =>
                                //                           const Icon(
                                //                         Icons.error,
                                //                       ),
                                //                       fit: BoxFit.cover,
                                //                       width: Get.width,
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 const SizedBox(
                                //                   height: 8,
                                //                 ),
                                //                 Padding(
                                //                   padding:
                                //                       const EdgeInsets.symmetric(
                                //                           horizontal: 10),
                                //                   child: Text(
                                //                     '${userProfileController.userProfile.value.data!.extraGuides![index].heading}',
                                //                     maxLines: 1,
                                //                     overflow: TextOverflow.ellipsis,
                                //                     style: kBlackDarkLargeStyle,
                                //                   ),
                                //                 ),
                                //                 const SizedBox(
                                //                   height: 6,
                                //                 ),
                                //                 Padding(
                                //                   padding:
                                //                       const EdgeInsets.symmetric(
                                //                           horizontal: 10),
                                //                   child: Text(
                                //                     '${userProfileController.userProfile.value.data!.extraGuides![index].description}',
                                //                     maxLines: 2,
                                //                     overflow: TextOverflow.ellipsis,
                                //                     style: kBlackLightMediumStyle,
                                //                   ),
                                //                 ),
                                //                 const SizedBox(
                                //                   height: 12,
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //         itemCount: userProfileController
                                //                     .userProfile
                                //                     .value
                                //                     .data!
                                //                     .extraGuides!
                                //                     .length >
                                //                 4
                                //             ? 4
                                //             : userProfileController.userProfile
                                //                 .value.data!.extraGuides!.length,
                                //       )
                                GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    itemCount: (userProfileController.userProfile.value.data!.extraGuides!.length > 4 ? 4 : userProfileController.userProfile.value.data!.extraGuides!.length),
                                    itemBuilder: (context, index) {
                                      // Check if the current index is the last one in the displayed grid
                                      bool isLastIndex = index ==
                                          (userProfileController.userProfile.value.data!.extraGuides!.length > 4 ? 4 - 1 : userProfileController.userProfile.value.data!.extraGuides!.length - 1);

                                      // if (isLastIndex) {
                                      //   return GestureDetector(
                                      //     onTap: () {
                                      //       Get.to(() =>
                                      //           const AllExtraGuidesScreen());
                                      //     },
                                      //     child: Container(
                                      //       width: Get.width,
                                      //       alignment: Alignment.center,
                                      //       decoration: BoxDecoration(
                                      //         borderRadius:
                                      //             BorderRadius.circular(18),
                                      //         color: kWhite,
                                      //         boxShadow: [
                                      //           BoxShadow(
                                      //             color: Colors.black
                                      //                 .withOpacity(0.08),
                                      //             spreadRadius: 1,
                                      //             blurRadius: 6,
                                      //           ),
                                      //         ],
                                      //       ),
                                      //       child: const Text('View \n  All',
                                      //           style: TextStyle(
                                      //               fontSize: 18,
                                      //               fontWeight: FontWeight
                                      //                   .bold) // kBlackLightMediumStyle,
                                      //           ),
                                      //     ),
                                      //   );
                                      // } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ExtraGuideDetailScreen(
                                              extraGuides: userProfileController.userProfile.value.data!.extraGuides![index],
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(18),
                                                color: kWhite,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.08),
                                                    spreadRadius: 1,
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(18),
                                                      child: CachedNetworkImage(
                                                        imageUrl: userProfileController.userProfile.value.data!.extraGuides![index].image ?? '',
                                                        placeholder: (context, url) {
                                                          return Shimmer.fromColors(
                                                            child: Container(color: Colors.white),
                                                            baseColor: Colors.grey.shade200,
                                                            highlightColor: Colors.grey.shade50,
                                                          );
                                                        },
                                                        errorWidget: (context, error, stackTrace) => const Icon(Icons.error),
                                                        fit: BoxFit.cover,
                                                        width: Get.width,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text(
                                                      '${userProfileController.userProfile.value.data!.extraGuides![index].heading}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kBlackDarkLargeStyle,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    child: Text(
                                                      '${userProfileController.userProfile.value.data!.extraGuides![index].description}',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kBlackLightMediumStyle,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                ],
                                              ),
                                            ),
                                            if (userProfileController.userProfile.value.data!.extraGuides!.length > 3)
                                              if (isLastIndex)
                                                Container(
                                                  width: Get.width,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(width: 1, color: Colors.black),
                                                    borderRadius: BorderRadius.circular(18),
                                                    color: kWhite,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.shade200,
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Material(
                                                    borderRadius: BorderRadius.circular(18),
                                                    color: kWhite.withOpacity(0.7),
                                                    child: Ink(
                                                      child: InkWell(
                                                        autofocus: true,
                                                        splashFactory: InkRipple.splashFactory,
                                                        borderRadius: BorderRadius.circular(18),
                                                        onTap: () {
                                                          Future.delayed(
                                                            Duration(milliseconds: 100),
                                                            () {
                                                              Get.to(() => const AllExtraGuidesScreen());
                                                            },
                                                          );
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: const Color(0xffF2F1F7)),
                                                              child: Icon(
                                                                Icons.arrow_forward_ios_rounded,
                                                                size: 30,
                                                                color: Colors.grey.withOpacity(0.8),
                                                              ),
                                                            ),
                                                            const Divider(thickness: 0.30),
                                                            Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text(
                                                                'View More \n Guide  ',
                                                                textAlign: TextAlign.center,
                                                                style: kBlackDarkLargeStyle, //TextStyle(fontSize: 18, fontWeight: FontWeight.bold,) // kBlackLightMediumStyle,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            // Material(
                                            //   borderRadius: BorderRadius.circular(18),
                                            //   color: kWhite.withOpacity(0.8),
                                            //   elevation: 6,
                                            //   child: Ink(
                                            //     decoration: BoxDecoration(
                                            //       borderRadius: BorderRadius.circular(18),
                                            //     ),
                                            //     child: InkWell(
                                            //       splashColor: Colors.blue.withOpacity(0.5),
                                            //       borderRadius: BorderRadius.circular(18),
                                            //       onTap: () {
                                            //         Get.to(() => const AllExtraGuidesScreen());
                                            //       },
                                            //       child: Container(
                                            //         width: Get.width,
                                            //         height: 230, // Adjust height as needed
                                            //         alignment: Alignment.center,
                                            //         child: const Text(
                                            //           'View \n  All',
                                            //           style: TextStyle(
                                            //             fontSize: 25,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      );
                                      // }
                                    },
                                  )
                                : GridView.builder(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    itemBuilder: (context, index) => GestureDetector(
                                      onTap: () {
                                        //  Get.to(
                                        //   () => ExtraGuideDetailScreen(
                                        //     extraGuides: userProfileController
                                        //         .userProfile
                                        //         .value
                                        //         .data!
                                        //         .extraGuides![index],
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          color: kWhite,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              spreadRadius: 1,
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(18),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300,
                                                  highlightColor: Colors.grey.shade100,
                                                  child: CachedNetworkImage(
                                                    imageUrl: userProfileController.userProfile.value.data!.extraGuides![index].image.toString(),
                                                    placeholder: (context, image) {
                                                      return Shimmer.fromColors(baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100, child: Container());
                                                    },
                                                    errorWidget: (context, error, stackTrace) => const Icon(
                                                      Icons.error,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    width: Get.width,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100, child: Container(color: Colors.white, width: 100, height: 20)),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Shimmer.fromColors(
                                                  baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100, child: Container(color: Colors.white, width: 2000, height: 20)),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    itemCount: userProfileController.userProfile.value.data!.extraGuides!.length > 4 ? 4 : userProfileController.userProfile.value.data!.extraGuides!.length,
                                  ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // GetX<UserProfileController>(
          //   init: userProfileController,
          //   builder: (controller) {
          //     if (controller.isFetching.value ||
          //         controller.userProfile.value.data == null) {
          //       return const Center(
          //         child: SizedBox(
          //           height: 25,
          //           child: LoadingIndicator(
          //             indicatorType: Indicator.lineScalePulseOut,
          //             colors: [
          //               kAccentColor,
          //             ],
          //           ),
          //         ),
          //       );
          //     }

          //     return GestureDetector(
          //       onTap: () {
          //         Get.to(() => const WalletScreen());
          //       },
          //       child: Container(
          //         // height: 250,
          //         margin: const EdgeInsets.symmetric(horizontal: 20),
          //         width: Get.width * 0.9,
          //         padding: const EdgeInsets.symmetric(
          //             horizontal: 16, vertical: 12),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(12),
          //           gradient: const LinearGradient(
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //             colors: [
          //               kColorPrimary,
          //               kColorPrimaryDark,
          //             ],
          //           ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.25),
          //               blurRadius: 6,
          //               spreadRadius: 2,
          //             ),
          //           ],
          //         ),
          //         child: Stack(
          //           children: [
          //             Positioned(
          //               child: Image.asset(
          //                 'assets/images/wallet/wallet_bg_shapes.png',
          //                 width: Get.width * 0.3,
          //               ),
          //             ),
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           'Main Wallet',
          //                           style: kWhiteDarkMediumStyle,
          //                         ),
          //                         const SizedBox(
          //                           height: 10,
          //                         ),
          //                         SvgPicture.asset(
          //                           'assets/images/logo/logo_full.svg',
          //                           width: Get.width * 0.2,
          //                         ),
          //                         const SizedBox(
          //                           height: 7,
          //                         ),
          //                         Text(
          //                           'Created on ${CommonTools().getDate(userProfileController.userProfile.value.data!.joiningTimestamp!)}',
          //                           style: kWhiteSmallMediumStyle,
          //                         ),
          //                       ],
          //                     ),
          //                     Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.end,
          //                       children: [
          //                         Text(
          //                           'Balance',
          //                           style: kWhiteDarkMediumStyle,
          //                         ),
          //                         Text(
          //                           '${userProfileController.userProfile.value.data!.currency} ${userProfileController.userProfile.value.data!.mainWalletBalance}',
          //                           style: kWhiteDarkSuperLargeStyle,
          //                         ),
          //                         const SizedBox(
          //                           height: 15,
          //                         ),
          //                         Text(
          //                           '+ Reload Wallet',
          //                           style: kWhiteMediumStyle,
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(
          //                   height: 3,
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    ));
  }
}

Widget beforeLoading(context) {
  return RefreshIndicator(
    onRefresh: () async {
      // userProfileController.getUserDetails();

      return;
    },
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      children: [
        GestureDetector(
          onTap: () {
            // Get.to(() => const WalletScreen());
          },
          child: Container(
            // height: 115,
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              'Created on ',
                              style: kWhiteSmallMediumStyle,
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
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 20, top: 8),
                              height: 15,
                              child: const LoadingIndicator(
                                indicatorType: Indicator.lineScalePulseOut,
                                colors: [
                                  kWhite,
                                ],
                              ),
                            ),
                            // Text(
                            //   'RM 0.00',
                            //   style: kWhiteDarkSuperLargeStyle,
                            // ),
                            // Shimmer.fromColors(
                            //     child: Container(
                            //       child: Text(
                            //         '     ',
                            //         style: kWhiteDarkSuperLargeStyle,
                            //       ),
                            //     ),
                            //     baseColor: Colors.grey.shade300,
                            //     highlightColor: Colors.grey.shade100
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              '+ Reload Wallet',
                              style: kWhiteMediumStyle,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const DonationScreen());
                },
                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/main_donate.svg',
                          width: Get.width * 0.18,
                          height: Get.width * 0.18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Donate',
                      style: kBlackMediumStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const MainBillPaymentScreen());
                },
                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/main_bill.svg',
                          width: Get.width * 0.18,
                          height: Get.width * 0.18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Bill Payment',
                      style: kBlackMediumStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 1000),
                      backgroundColor: kColorPrimary,
                      content: Text(
                        'Coming soon!',
                        style: kWhiteDarkMediumStyle,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/main_other.svg',
                          width: Get.width * 0.18,
                          height: Get.width * 0.18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Others',
                      style: kBlackMediumStyle,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const TopUpScreen());
                },
                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/main_topup.svg',
                          width: Get.width * 0.18,
                          height: Get.width * 0.18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Topup',
                      style: kBlackMediumStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () => Get.to(() => const FavoriteScreen()),
                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/main_favorite.svg',
                          width: Get.width * 0.18,
                          height: Get.width * 0.18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Favorite',
                      style: kBlackMediumStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    width: Get.width * 0.18,
                    height: Get.width * 0.18,
                    padding: const EdgeInsets.all(20),
                    // decoration: BoxDecoration(
                    //   color: const Color(0xffF6F6F6),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    // child: Center(
                    //   child: SvgPicture.asset(
                    //     'assets/icons/main_other.svg',
                    //     width: Get.width * 0.18,
                    //     height: Get.width * 0.18,
                    //   ),
                    // ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Text(
                  //   'Others',
                  //   style: kBlackMediumStyle,
                  // ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: Get.height * 0.2,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 0.7,
                    initialPage: 3,
                    onPageChanged: (index, reason) {},
                  ),
                  carouselController: null,

                  items: [1, 2, 3]
                      .map((e) => GestureDetector(
                            onTap: () {
                              // Get.to(
                              //   () => PromotionsDetailScreen(
                              //     extraGuides: e,
                              //   ),
                              // );
                            },
                            child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Container(color: Colors.white)),
                          ))
                      .toList(),
                  // [1, 2, 3].map((i) {
                  //   return Builder(
                  //     builder: (BuildContext context) {
                  //       return ClipRRect(
                  //         borderRadius: BorderRadius.circular(20),
                  //         child: Image.asset(
                  //           'assets/images/dashboard/main_$i.png',
                  //           fit: BoxFit.contain,
                  //         ),
                  //       );
                  //     },
                  //   );
                  // }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3].map((entry) {
                    return GestureDetector(
                      onTap: () => {},
                      child: Container(
                        width: 12.0,
                        height: 3.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
        // shimmer end
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Extra Guides',
                style: kBlackDarkSuperLargeStyle,
              ),
              TextButton(
                onPressed: () {
                  // Get.to(() => const AllExtraGuidesScreen());
                },
                child: Text(
                  'View All',
                  style: kBlackLightMediumStyle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          spreadRadius: 1,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Image.network(
                                '',
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.error,
                                ),
                                fit: BoxFit.cover,
                                width: Get.width,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Shimmer.fromColors(baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100, child: Container(color: Colors.white, width: 100, height: 20)),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Shimmer.fromColors(baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100, child: Container(color: Colors.white, width: 2000, height: 20)),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
            itemCount: 4),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}
