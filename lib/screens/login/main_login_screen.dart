import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:parrotpos/screens/login/login_screen.dart';
import 'package:parrotpos/screens/login/sign_up/sign_up_screen_3.dart';
import 'package:parrotpos/screens/user_profile/terms_and_conditions_screen.dart';
import 'package:parrotpos/style/style.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../controllers/internet_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/user_profile_controller.dart';
import '../../services/remote_service.dart';
import '../../style/colors.dart';
import '../../widgets/buttons/white_icon_button.dart';
import '../../widgets/dialogs/snackbars.dart';
import '../main_home.dart';
import '../user_profile/privacy_policy_screen.dart';
import 'old_login_screen.dart';
import 'sign_up/sign_up_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({Key? key}) : super(key: key);

  @override
  _MainLoginScreenState createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  @override
  void initState() {
    RemoteService.checkServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _c = Get.put(InternetController());
    _c.onInit();
    final authController = Get.put(LoginController());
    return Scaffold(
        body: Column(
      children: [
        SafeArea(
            child: Image.asset(
          'assets/images/logo/login_logo@2x.png',
          width: Get.width,
        )),
        const Spacer(),
        Text(
          "Sign In or Sign Up in seconds ",
          style: kBlackDarkExtraLargeStyle,
        ),
        const SizedBox(
          height: 26,
        ),
        WhiteButtonWithIcon(
          icon: SvgPicture.asset(
            "assets/icons/devicon_google.svg",
          ),
          text: 'Continue With Google',
          width: false,
          widthSize: 0,
          onTap: () async {
            var res = await authController.signInWithGoogle();
            if (res == "Login is Successful" || res == "Account Created Successfuly") {
              //logged in

              Get.offAll(() => const MainHome());
            } else {
              //failed

              errorSnackbar(title: "Login Failed", subtitle: res ?? "Something went wrong");
            }
          },
        ),
        const SizedBox(
          height: 11,
        ),
        Platform.isIOS
            ? WhiteButtonWithIcon(
                icon: SvgPicture.asset(
                  "assets/icons/appleLogin.svg",
                  height: 24,
                  // width: 38,
                  // color: Colors.black,
                ),
                // icon: Image.asset(
                //   "assets/icons/apple.png",
                //   height: 32,
                //   width: 48,
                //   // fit: BoxFit.cover,
                // ),
                text: 'Continue With Apple',
                width: false,
                widthSize: 0,
                onTap: () async {
                  var res = await authController.signInWithApple();
                  if (res == "Login is Successful" || res == "Account Created Successfuly") {
                    //logged in

                    Get.offAll(() => const MainHome());
                  } else {
                    //failed

                    errorSnackbar(title: "Login Failed", subtitle: res ?? "Something went wrong");
                  }
                })
            : Container(),
        // Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 30),
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: kWhite,
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.black.withOpacity(0.1),
        //                 spreadRadius: 2,
        //                 blurRadius: 5,
        //                 offset: const Offset(0, 0),
        //               ),
        //             ],
        //             borderRadius: BorderRadius.circular(12),
        //           ),
        //           child: SignInWithAppleButton(
        //               borderRadius: const BorderRadius.all(
        //                 Radius.circular(10.0),
        //               ),
        //                iconAlignment: IconAlignment.left,
        //               style: SignInWithAppleButtonStyle.white,
        //               height: 44,
        //               onPressed: () async {
        //                 var res = await authController.signInWithApple();
        //                 if (res == "Login is Successful" ||
        //                     res == "Account Created Successfuly") {
        //                   //logged in
        //
        //                   Get.offAll(() => const MainHome());
        //                 } else {
        //                   //failed
        //
        //                   errorSnackbar(
        //                       title: "Login Failed",
        //                       subtitle: res ?? "Something went wrong");
        //                 }
        //               },
        //           ),
        //         ),
        //       )
        //       : Container(),

        SizedBox(
          height: Platform.isIOS ? 11 : 0,
        ),
        WhiteButtonWithIcon(
          icon: SvgPicture.asset(
            "assets/icons/ic_round_email.svg",
          ),
          text: ''
              'Use Other Email',
          width: false,
          widthSize: 0,
          onTap: () {
            Get.to(() => const OldLoginScreen());
          },
        ),
        // WhiteButtonWithIcon(
        //   icon: SvgPicture.asset(
        //     "assets/icons/ic_round_email.svg",
        //   ),
        //   text: 'Continue Another Way',
        //   width: false,
        //   widthSize: 0,
        //   onTap: () {
        //     Get.bottomSheet(
        //         isScrollControlled: true,
        //         Container(
        //           height: Get.height * 0.6,
        //           decoration: const BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(10.0),
        //                 topRight: Radius.circular(10.0),
        //               )),
        //           child: Column(
        //             children: [
        //               const SizedBox(
        //                 height: 70,
        //               ),
        //               Text(
        //                 "Continue To Parrotpos",
        //                 style: kBlackDarkExtraLargeStyle,
        //               ),
        //               const SizedBox(
        //                 height: 25,
        //               ),
        //               WhiteButtonWithIcon(
        //                 icon: SvgPicture.asset(
        //                   "assets/icons/devicon_google.svg",
        //                 ),
        //                 text: 'Continue With Google',
        //                 width: false,
        //                 widthSize: 0,
        //                 onTap: () async {
        //                   var res = await authController.signInWithGoogle();
        //                   if (res == "Login is Successful" ||
        //                       res == "Account Created Successfuly") {
        //                     //logged in

        //                     Get.offAll(() => const MainHome());
        //                   } else {
        //                     //failed

        //                     errorSnackbar(
        //                         title: "Login Failed", subtitle: res!);
        //                   }
        //                 },
        //               ),
        //               const SizedBox(
        //                 height: 15,
        //               ),
        //               // WhiteButtonWithIcon(
        //               //   icon: SvgPicture.asset(
        //               //     "assets/icons/yahoo.svg",
        //               //   ),
        //               //   text: 'Continue With Yahoo',
        //               //   width: false,
        //               //   widthSize: 0,
        //               //   onTap: () async {
        //               //     var res =
        //               // await authController.signInWithYahoo(context);

        //               //     if (res == "Login is Successful") {
        //               //       //logged in

        //               //       Get.offAll(() => const MainHome());
        //               //     } else if (res == "Account Created Successfuly") {
        //               //       Get.offAll(() => const SignUpScreen3());
        //               //     } else {
        //               //       //failed

        //               //       errorSnackbar(
        //               //           title: "Login Failed", subtitle: res!);
        //               //     }
        //               //   },
        //               // ),

        //               Platform.isIOS
        //                   ? Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 30),
        //                       child: SignInWithAppleButton(
        //                           borderRadius: BorderRadius.all(
        //                             Radius.circular(10.0),
        //                           ),
        //                           style: SignInWithAppleButtonStyle.black,
        //                           onPressed: () async {
        //                             var res =
        //                                 await authController.signInWithApple();
        //                             if (res == "Login is Successful" ||
        //                                 res == "Account Created Successfuly") {
        //                               //logged in

        //                               Get.offAll(() => const MainHome());
        //                             } else {
        //                               //failed

        //                               errorSnackbar(
        //                                   title: "Login Failed",
        //                                   subtitle: res!);
        //                             }
        //                           }),
        //                     )
        //                   : Container(),
        //               SizedBox(
        //                 height: Platform.isIOS ? 15 : 0,
        //               ),
        //               // WhiteButtonWithIcon(
        //               //   icon: SvgPicture.asset(
        //               //     "assets/icons/apple_logo.svg",
        //               //     width: 23,
        //               //   ),
        //               //   text: 'Continue With Apple',
        //               //   width: false,
        //               //   widthSize: 0,
        //               //   onTap: () async {
        //               //     var res = await authController.signInWithGoogle();

        //               //     if (res!.isEmpty) {
        //               //       //logged in

        //               //       Get.offAll(() => const MainHome());
        //               //     } else if (res == "Sent To Verify Phone Screen") {
        //               //     } else {
        //               //       //failed

        //               //       errorSnackbar(title: "Login Failed", subtitle: res);
        //               //     }
        //               //   },
        //               // ),
        //               // const SizedBox(
        //               //   height: 15,
        //               // ),
        //               // WhiteButtonWithIcon(
        //               //   icon: SvgPicture.asset(
        //               //     "assets/icons/ic_round_email.svg",
        //               //   ),
        //               //   text: 'Continue With Hotmail',
        //               //   width: false,
        //               //   widthSize: 0,
        //               //   onTap: () async {
        //               //     var res = await authController.signInWithGoogle();

        //               //     if (res!.isEmpty) {
        //               //       //logged in

        //               //       Get.offAll(() => const MainHome());
        //               //     } else if (res == "Sent To Verify Phone Screen") {
        //               //     } else {
        //               //       //failed

        //               //       errorSnackbar(title: "Login Failed", subtitle: res);
        //               //     }
        //               //   },
        //               // ),
        //               // const SizedBox(
        //               //   height: 15,
        //               // ),
        //               WhiteButtonWithIcon(
        //                 icon: SvgPicture.asset(
        //                   "assets/icons/ic_round_email.svg",
        //                 ),
        //                 text: 'Use Other Email',
        //                 width: false,
        //                 widthSize: 0,
        //                 onTap: () {
        //                   Get.to(() => const OldLoginScreen());
        //                 },
        //               ),
        //             ],
        //           ),
        //         ));
        //   },
        // ),
        const SizedBox(
          height: 70,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       width: Get.width * 0.34,
        //       height: 1,
        //       color: kColorPrimaryLight,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20),
        //       child: Text(
        //         "OR",
        //         style: kGreenMediumStyle.copyWith(
        //             fontSize: 18, fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //     Container(
        //       width: Get.width * 0.34,
        //       height: 1,
        //       color: kColorPrimaryLight,
        //     ),
        //   ],
        // ),
        // const SizedBox(
        //   height: 48,
        // ),
        // Text(
        //   'Don\'t have an account?',
        //   style: kBlackMediumStyle,
        // ),

        // TextButton(
        //     onPressed: () {
        //       Get.bottomSheet(
        //           isScrollControlled: true,
        //           Container(
        //             height: Get.height * 0.6,
        //             decoration: const BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.only(
        //                     topLeft: Radius.circular(10.0),
        //                     topRight: Radius.circular(10.0))),
        //             child: Column(
        //               children: [
        //                 const SizedBox(
        //                   height: 70,
        //                 ),
        //                 Text(
        //                   "Continue To Parrotpos",
        //                   style: kBlackDarkExtraLargeStyle,
        //                 ),
        //                 const SizedBox(
        //                   height: 25,
        //                 ),
        //                 WhiteButtonWithIcon(
        //                   icon: SvgPicture.asset(
        //                     "assets/icons/devicon_google.svg",
        //                   ),
        //                   text: 'Continue With Google',
        //                   width: false,
        //                   widthSize: 0,
        //                   onTap: () async {
        //                     var res = await authController.signInWithGoogle();

        //                     if (res!.isEmpty) {
        //                       //logged in

        //                       Get.offAll(() => const MainHome());
        //                     } else if (res == "Sent To Verify Phone Screen") {
        //                     } else {
        //                       //failed

        //                       errorSnackbar(
        //                           title: "Login Failed", subtitle: res);
        //                     }
        //                   },
        //                 ),
        //                 const SizedBox(
        //                   height: 15,
        //                 ),
        //                 WhiteButtonWithIcon(
        //                   icon: SvgPicture.asset(
        //                     "assets/icons/yahoo.svg",
        //                   ),
        //                   text: 'Continue With Yahoo',
        //                   width: false,
        //                   widthSize: 0,
        //                   onTap: () async {
        //                     var res =
        //                         await authController.signInWithYahoo(context);

        //                     if (res == "Login is Successful") {
        //                       //logged in

        //                       Get.offAll(() => const MainHome());
        //                     } else if (res == "Account Created Successfuly") {
        //                       Get.offAll(() => const SignUpScreen3());
        //                     } else {
        //                       //failed

        //                       errorSnackbar(
        //                           title: "Login Failed", subtitle: res!);
        //                     }
        //                   },
        //                 ),
        //                 const SizedBox(
        //                   height: 15,
        //                 ),
        //                 // WhiteButtonWithIcon(
        //                 //   icon: SvgPicture.asset(
        //                 //     "assets/icons/apple_logo.svg",
        //                 //     width: 23,
        //                 //   ),
        //                 //   text: 'Continue With Apple',
        //                 //   width: false,
        //                 //   widthSize: 0,
        //                 //   onTap: () async {
        //                 //     var res = await authController.signInWithGoogle();

        //                 //     if (res!.isEmpty) {
        //                 //       //logged in

        //                 //       Get.offAll(() => const MainHome());
        //                 //     } else if (res == "Sent To Verify Phone Screen") {
        //                 //     } else {
        //                 //       //failed

        //                 //       errorSnackbar(
        //                 //           title: "Login Failed", subtitle: res);
        //                 //     }
        //                 //   },
        //                 // ),
        //                 // const SizedBox(
        //                 //   height: 15,
        //                 // ),
        //                 // WhiteButtonWithIcon(
        //                 //   icon: SvgPicture.asset(
        //                 //     "assets/icons/ic_round_email.svg",
        //                 //   ),
        //                 //   text: 'Continue With Hotmail',
        //                 //   width: false,
        //                 //   widthSize: 0,
        //                 //   onTap: () async {
        //                 //     var res = await authController.signInWithGoogle();

        //                 //     if (res!.isEmpty) {
        //                 //       //logged in

        //                 //       Get.offAll(() => const MainHome());
        //                 //     } else if (res == "Sent To Verify Phone Screen") {
        //                 //     } else {
        //                 //       //failed

        //                 //       errorSnackbar(
        //                 //           title: "Login Failed", subtitle: res);
        //                 //     }
        //                 //   },
        //                 // ),
        //                 // const SizedBox(
        //                 //   height: 15,
        //                 // ),
        //                 WhiteButtonWithIcon(
        //                   icon: SvgPicture.asset(
        //                     "assets/icons/ic_round_email.svg",
        //                   ),
        //                   text: 'Use Other Email',
        //                   width: false,
        //                   widthSize: 0,
        //                   onTap: () {
        //                     Get.to(() => const SignUpScreen());
        //                   },
        //                 ),
        //               ],
        //             ),
        //           ));
        //     },
        //     child: Text(
        //       "Sign up",
        //       style: kBlueBoldMediumStyle.copyWith(
        //           color: const Color(0xFF0E76BC),
        //           fontSize: 14,
        //           fontWeight: FontWeight.w500),
        //     )),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 19,
              height: 19,
              decoration: ShapeDecoration(
                color: const Color(0xFF0E76BC),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(1.0),
                child: Icon(
                  Icons.check,
                  color: kWhite,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              "I've read and agree with",
              style: kBlackExtraSmallMediumStyle,
            ),
            InkWell(
              onTap: () {
                Get.put(UserProfileController());
                Get.to(() => const TermsAndConditionsScreen(), arguments: 'app-level');
                // final Uri url = Uri.parse(
                //     "https://parrotpos.com.my/terms_and_conditions.html");
                // launchUrl(url);
              },
              child: Text(
                ' Terms ',
                style: kBlackExtraSmallMediumStyle.copyWith(
                  color: const Color(0xFF39B54A),
                ),
              ),
            ),
            Text(
              "and",
              style: kBlackExtraSmallMediumStyle,
            ),
            InkWell(
              onTap: () async {
                Get.put(UserProfileController());
                Get.to(() => const PrivacyPolicyScreen(), arguments: 'app-level');
                // final Uri url =
                //     Uri.parse('https://parrotpos.com.my/privacy_policy.html');
                // launchUrl(url);
              },
              child: Text(
                ' Privacy Policy ',
                style: kBlackExtraSmallMediumStyle.copyWith(
                  color: const Color(0xFF39B54A),
                ),
              ),
            ),
            // Text.rich(
            //   TextSpan(
            //     children: [
            //       TextSpan(
            //         text: "I've read and agree with ",
            //         style: kBlackExtraSmallMediumStyle,
            //       ),
            //       TextSpan(
            //         text: 'Terms',
            //         style: kBlackExtraSmallMediumStyle.copyWith(
            //           color: const Color(0xFF39B54A),
            //         ),
            //       ),
            //       TextSpan(
            //         text: ' and ',
            //         style: kBlackExtraSmallMediumStyle,
            //       ),
            //       TextSpan(
            //         text: 'Privacy Policy',
            //         style: kBlackExtraSmallMediumStyle.copyWith(
            //           color: const Color(0xFF39B54A),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        // GradientButton(
        //   text: "Sign up",
        //   width: false,
        //   widthSize: 0,
        //   onTap: () => Get.to(() => const SignUpScreen()),
        //   buttonState: ButtonState.idle,
        // ),
        // const SizedBox(
        //   height: 30,
        // ),
        // Text(
        //   'Already have an account?',
        //   style: kBlackMediumStyle,
        // ),
        // const SizedBox(
        //   height: 15,
        // ),
        // WhiteButton(
        //   text: 'Login',
        //   width: false,
        //   widthSize: 0,
        //   onTap: () {
        //     Get.to(() => const LoginScreen());
        //   },
        // ),
        // const SizedBox(
        //   height: 15,
        // ),
        // Text(
        //   'or',
        //   style: kBlackMediumStyle,
        // ),
        // const SizedBox(
        //   height: 15,
        // ),
        // SizedBox(
        //   width: Get.width,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       // GoogleAuthButton(
        //       //   onPressed: () async {
        //       //     var res = await authController.signInWithGoogle();

        //       //     if (res!.isEmpty) {
        //       //       //logged in

        //       //       print(RemoteService.accessId);

        //       //       Get.offAll(() => const MainHome());
        //       //     } else if (res == "Sent To Verify Phone Screen") {
        //       //     } else {
        //       //       //failed

        //       //       errorSnackbar(title: "Login Failed", subtitle: res);
        //       //     }
        //       //   },
        //       //   style: const AuthButtonStyle(
        //       //     buttonType: AuthButtonType.icon,
        //       //   ),
        //       // ),
        //       // const SizedBox(
        //       //   width: 30,
        //       // ),

        //     ],
        //   ),
        // ),
        // const SizedBox(
        //   height: 60,
        // )
        const Spacer(),
      ],
    ));
  }
}
