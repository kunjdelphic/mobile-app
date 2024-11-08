import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/login/main_login_screen.dart';
import 'package:parrotpos/screens/user_profile/delete_account/delete_flow_1.dart';
import 'package:parrotpos/screens/user_profile/privacy_policy_screen.dart';
import 'package:parrotpos/screens/user_profile/referrals/referrals_screen.dart';
import 'package:parrotpos/screens/user_profile/report_and_feedback/feedback_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:parrotpos/screens/user_profile/terms_and_conditions_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/wallet_activation/ew_1_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/user_profile_button.dart';
import 'package:parrotpos/widgets/dialogs/change_phone_no_dialog.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/report_feedback_dialog.dart';
import 'package:parrotpos/widgets/dialogs/sheets.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'wallet/wallet_balance_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileController userProfileController = Get.find();
  showChangePhoneNoDialog() async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return const ChangePhoneNoDialog();
      },
    );
    if (res != null) {
      //success
      // Get.offAll(() => const MainHome());
      userProfileController.getUserDetails();
    } else {
      //cancelled
    }
  }

  // showReportFeedbackDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return const ReportFeedbackDialog();
  //     },
  //   );
  // }

  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: GetX<UserProfileController>(
          init: UserProfileController(),
          initState: (_) {},
          builder: (_) {
            return Text(
              "${_.userProfile.value.data!.name}'s Profile",
              style: kBlackLargeStyle,
            );
          },
        ),
      ),
      body: GetX<UserProfileController>(
        init: userProfileController,
        builder: (_) {
          // if (_.isFetching.value) {
          //   return const Center(
          //     child: SizedBox(
          //       height: 25,
          //       child: LoadingIndicator(
          //         indicatorType: Indicator.lineScalePulseOut,
          //         colors: [
          //           kAccentColor,
          //         ],
          //       ),
          //     ),
          //   );
          // }
          // print('IMAGE URL :: ${_.userProfile.value.data!.profileImage}');
          return RefreshIndicator(
            onRefresh: () async {
              userProfileController.getUserDetails();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: Get.width * 0.36,
                        height: Get.width * 0.36,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  backgroundColor: kWhite,
                                  radius: Get.width * 0.16,
                                  child: _.userProfile.value.data!.profileImage! == "https://parrotpostest.blob.core.windows.net/images/no_image.svg"
                                      ? Image.asset(
                                          'assets/images/referral/ic_profile.png',
                                        )
                                      : CachedNetworkImage(
                                          placeholder: (c, s) {
                                            return Shimmer.fromColors(
                                                baseColor: Colors.grey.shade200,
                                                highlightColor: Colors.grey.shade50,
                                                child: Container(
                                                  color: Colors.white,
                                                ));
                                          },
                                          errorWidget: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/referral/ic_profile.png',
                                            );
                                          },
                                          imageUrl: _.userProfile.value.data!.profileImage!,
                                          fit: BoxFit.cover,
                                          fadeInDuration: const Duration(milliseconds: 250),
                                          fadeInCurve: Curves.easeInOut,
                                          fadeOutDuration: const Duration(milliseconds: 150),
                                          fadeOutCurve: Curves.easeInOut,
                                        ),
                                  // child: Image.network(
                                  //   _.userProfile.value.data!.profileImage!,
                                  //   errorBuilder: (context, error, stackTrace) =>
                                  //       Image.asset(
                                  //     'assets/images/referral/ic_profile.png',
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                            Positioned(
                              width: Get.width * 0.32,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  var res = await addPictureSheet(
                                    context,
                                    false,
                                  );
                                  if (res != null) {
                                    selectedImage = res;

                                    processingDialog(title: 'Uploading the profile image...', context: context);

                                    String response = await userProfileController.uploadProfileImage({
                                      'image': selectedImage,
                                    });

                                    if (response.isEmpty) {
                                      //done
                                      Get.back();
                                      selectedImage = null;

                                      userProfileController.getUserDetails();
                                      //  print("++++++++++++++++");
                                      //   print(
                                      //    _.userProfile.value.data!.profileImage!,
                                      //  );
                                    } else {
                                      //error
                                      Get.back();

                                      errorSnackbar(title: 'Failed', subtitle: response);
                                      return;
                                    }
                                  }
                                },
                                child: const CircleAvatar(
                                  radius: 17,
                                  backgroundColor: kColorPrimary,
                                  child: Icon(
                                    Icons.add,
                                    color: kWhite,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(color: const Color(0xffF2F2F2), borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text(
                          _.userProfile.value.data!.emailVerified ?? false ? 'Verified' : 'Not Verified',
                          style: kPrimarySmallMediumStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${_.userProfile.value.data!.name}',
                  style: kBlackDarkLargeStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${_.userProfile.value.data!.email}',
                  style: kBlackLightMediumStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'created on ${CommonTools().getDate(_.userProfile.value.data!.joiningTimestamp!)}',
                  style: kBlackLightMediumStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                _.userProfile.value.data!.accountStatus == 'APPROVED'
                    ? const SizedBox()
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
                const SizedBox(
                  height: 15,
                ),
                const Divider(thickness: 0.30),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Wallet Balance',
                  icon: const Icon(
                    Icons.account_balance_wallet,
                    color: kColorPrimary,
                  ),
                  isSuffix: true,
                  suffix: '${Config().currencyCode} ${_.userProfile.value.data!.mainWalletBalance}',
                  onTap: () {
                    Get.to(() => const WalletBalanceScreen());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Phone Number',
                  icon: const Icon(
                    Icons.phone_android,
                    color: kColorPrimary,
                  ),
                  isSuffix: true,
                  suffix: _.userProfile.value.data!.phoneVerified! ? 'Verified' : 'Not Verified',
                  onTap: () async {
                    if (!_.userProfile.value.data!.phoneVerified!) {
                      await Get.to(() => const EW1Screen());
                      userProfileController.getUserDetails();
                    } else {
                      showChangePhoneNoDialog();
                    }
                    // Get.to(() => const ChangePhoneNoScreen());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Referral Code',
                  icon: const Icon(
                    Icons.groups,
                    color: kColorPrimary,
                  ),
                  isSuffix: true,
                  suffix: '${_.userProfile.value.data!.referralCode}',
                  onTap: () {
                    Get.to(() => const ReferralsScreen());
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Contact Support',
                  icon: const Icon(
                    Icons.support_agent,
                    color: kColorPrimary,
                  ),
                  isSuffix: false,
                  suffix: '',
                  onTap: () {
                    Get.to(() => const FeedbackScreen());
                    // showReportFeedbackDialog();
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Terms & Conditions',
                  icon: const Icon(
                    Icons.list_alt,
                    color: kColorPrimary,
                  ),
                  isSuffix: false,
                  suffix: '',
                  onTap: () {
                    Get.to(() => const TermsAndConditionsScreen(), arguments: 'app-level');
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Privacy Policy',
                  icon: const Icon(
                    Icons.privacy_tip_outlined,
                    color: kColorPrimary,
                  ),
                  isSuffix: false,
                  suffix: '',
                  onTap: () async {
                    Get.to(() => const PrivacyPolicyScreen(), arguments: 'app-level');
                    // final Uri url = Uri.parse(
                    //     'https://parrotpos.com.my/privacy_policy.html');
                    // launchUrl(url);
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                UserProfileButton(
                  title: 'Delete Account',
                  icon: const Icon(
                    Icons.delete,
                    color: kColorPrimary,
                  ),
                  isSuffix: false,
                  suffix: '',
                  onTap: () {
                    Get.to(() => DeleteFlow1Screen(), arguments: 'app-level');
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 32,
                      // width: 65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            12.0,
                          ),
                        ),
                        border: Border.all(
                          color: Colors.blueAccent,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'V ${userProfileController.currentVersion}',
                        style: kBlackSmallLightMediumStyle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await GetStorage().write('accessId', null);

                        // UserProfileController().dispose();
                        // WalletController().dispose();
                        // LoginController().dispose();

                        await Get.deleteAll(force: true);

                        //jn4dn0pjbnrmrad5cjj48sjjugquwsr64n0u38uitvdf0qlyoqwhy9xk2a619ck62valaxqxgiyitirnjsa7zspin3ssfflisjpmt3sktcluumu99ecz16zk3zi62bjdkqx7ffd0dnxc4b1w0kenmv

                        Get.offAll(() => const MainLoginScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Sign Out',
                            style: kBlackMediumStyle,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            'assets/icons/sign_out.png',
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
