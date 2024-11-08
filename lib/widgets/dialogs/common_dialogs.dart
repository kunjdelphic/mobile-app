import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/add_to_favorites_button.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/progress_button.dart';

taskCompletedDialog({
  required String? title,
  String? subtitle,
  required String buttonTitle,
  required String image,
  void Function()? onTap,
  required BuildContext context,
  TextStyle? style,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    image,
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  title != null
                      ? Column(
                          children: [
                            Text(
                              title,
                              style: style ?? kBlackDarkLargeStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  subtitle != null
                      ? Column(
                          children: [
                            Text(
                              subtitle,
                              style: kBlackMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                  GradientButton(
                    text: buttonTitle,
                    width: false,
                    widthSize: Get.width * 0.65,
                    onTap: onTap ??
                        () {
                          Get.back();
                        },
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    height: 20,
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

favoriteCloseDialog({
  required String? title,
  String? subtitle,
  required String buttonTitle,
  required String image,
  void Function()? onTap,
  required BuildContext context,
  TextStyle? style,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    image,
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  title != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              Text(
                                title,
                                style: style ?? kBlackDarkSuperLargeStyle.copyWith(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  subtitle != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            children: [
                              Text(
                                subtitle,
                                style: kBlackSmallLightMediumStyle,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 5,
                  ),
                  GradientButton(
                    text: buttonTitle,
                    width: false,
                    widthSize: Get.width * 0.65,
                    onTap: onTap ??
                        () {
                          Get.back();
                        },
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    height: 20,
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

processingDialog({
  required String? title,
  String? subtitle,
  bool? barrierDismissible,
  void Function()? onTap,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 25,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScalePulseOut,
                      colors: [
                        kAccentColor,
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  title != null
                      ? Column(
                          children: [
                            Text(
                              title,
                              style: kBlackMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  subtitle != null
                      ? Column(
                          children: [
                            Text(
                              subtitle,
                              style: kBlackSmallMediumStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
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

processing({
  required String? title,
  String? subtitle,
  bool? barrierDismissible,
  void Function()? onTap,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible ?? false,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/dialog.png"),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Text(
                    title ?? "",
                    style: kBlackSmallMediumStyle.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  WhiteBluBtn(
                    width: 150,
                    onTap: () {
                      Get.back();
                      // notificationController.launchWhatsApp(callBack: () {
                      //   // Get.to(MessageSentScreen());
                      // });
                      // Get.to(() => NotificationDisableScreen());
                    },
                    text: "Back",
                    widthSize: Get.width * 0.34,
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

lowWalletBalanceDialog({
  required String image,
  void Function()? onTap,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Image.asset(
                        image,
                        width: Get.width * 0.1,
                        height: Get.width * 0.1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Your wallet balance is',
                    style: kBlackMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'LOW!',
                    style: kRedDarkMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GradientButton(
                    text: 'Reload Now',
                    width: true,
                    widthSize: Get.width * 0.65,
                    onTap: onTap ??
                        () {
                          Get.back();
                        },
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    height: 20,
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

decimalNotAllowedDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 5.0,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/icons/bill_payment/decimal_not_allowed.png',
                      width: Get.width * 0.2,
                      height: Get.width * 0.2,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Demical point not allowed!',
                    style: kRedDarkMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GradientButton(
                    text: 'Close',
                    width: true,
                    widthSize: Get.width * 0.65,
                    onTap: () {
                      Get.back();
                    },
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    height: 20,
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

// infoMassageDialog({
//   required BuildContext context,
//   String? text,
// }) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return Dialog(
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(15.0),
//           ),
//         ),
//         // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//         elevation: 5.0,
//         child: SingleChildScrollView(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   Text(
//                     'Info',
//                     style: kBlackDarkSuperLargeStyle,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(
//                     height: 15.0,
//                   ),
//                   Text(
//                     text ?? "",
//                     style: kRedDarkMediumStyle,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   GradientButton(
//                     text: 'Close',
//                     width: true,
//                     widthSize: Get.width * 0.30,
//                     onTap: () {
//                       Get.back();
//                     },
//                     buttonState: ButtonState.idle,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

deleteDialog({
  required String title,
  required String buttonTitle,
  required String buttonTitle2,
  required String image,
  void Function()? onTapYes,
  void Function()? onTapNo,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        // backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 5.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    image,
                    width: Get.width * 0.15,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    title,
                    style: kBlackMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WhiteButton(
                        text: buttonTitle,
                        width: true,
                        widthSize: Get.width * 0.34,
                        onTap: onTapYes ??
                            () {
                              Get.back();
                            },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GradientButton(
                        text: buttonTitle2,
                        width: true,
                        widthSize: Get.width * 0.34,
                        onTap: onTapNo ??
                            () {
                              Get.back();
                            },
                        buttonState: ButtonState.idle,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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

showCompletedTopupDialog({
  required BuildContext context,
  required onTap,
  required onClose,
  required onTapFav,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onClose,
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/icons/change_phone_dl.png',
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Payment in Process..',
                    style: kBlackDarkLargeStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'For more details',
                    style: kBlackMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AddToFavoritesButton(
                    text: 'Add This To Favorites',
                    width: false,
                    onTap: onTapFav,
                    widthSize: Get.width * 0.65,
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GradientButton(
                    text: 'View Transaction History',
                    width: false,
                    widthSize: Get.width * 0.65,
                    onTap: onTap,
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    height: 20,
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

showFavCompletedDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/icons/change_phone_dl.png',
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Payment in Process..',
                    style: kBlackDarkLargeStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'For more details, view transaction history.',
                    style: kBlackMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // AddToFavoritesButton(
                  //   text: 'Add This To Favorites',
                  //   width: false,
                  //   onTap: onTapFav,
                  //   widthSize: Get.width * 0.65,
                  //   buttonState: ButtonState.idle,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // GradientButton(
                  //   text: 'View Transaction History',
                  //   width: false,
                  //   widthSize: Get.width * 0.65,
                  //   onTap: onTap,
                  //   buttonState: ButtonState.idle,
                  // ),
                  const SizedBox(
                    height: 20,
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

showTransferToMainCompletedDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/icons/earning_wallet/checkmark_circle.png',
                    width: Get.width * 0.2,
                    height: Get.width * 0.2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Successfully Added to Main Wallet.',
                    style: kBlackDarkLargeStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
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

contactPermissionDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Contact Permission',
                  style: kBlackDarkExtraLargeStyle,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Unlock this feature by allowing contact access.\n Tap 'Allow' in settings.",
                  // "If you want to pick contacts from contact book then allow permission from settings",
                  // 'Contact access is needed to continue. Please go to settings and allow contact access.',
                  style: kBlackMediumStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    WhiteButton(
                      text: 'Cancel',
                      width: true,
                      widthSize: Get.width * 0.34,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GradientButton(
                      text: 'Allow',
                      // btnColor: true,
                      width: true,
                      widthSize: Get.width * 0.34,
                      onTap: () {
                        Get.back();
                        openAppSettings();
                      },
                      buttonState: ButtonState.idle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

phoneMismatchDialog({
  required String title,
  required String buttonTitle,
  required String image,
  void Function()? onTapYes,
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 45,
                  ),
                  Image.asset(
                    image,
                    width: Get.width * 0.25,
                  ),
                  const SizedBox(
                    height: 45.0,
                  ),
                  Text(
                    title,
                    style: kBlackMediumStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  GradientButton(
                    text: buttonTitle,
                    width: true,
                    widthSize: Get.width * 0.8,
                    onTap: onTapYes ??
                        () {
                          Get.back();
                        },
                    buttonState: ButtonState.idle,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const SizedBox(
                    height: 60,
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

showUpDateDialog({
  required BuildContext context,
  required onTap,
}) {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: [
                      Image.asset(
                        'assets/icons/upDate.png',
                        // width: Get.width * 0.2,
                        // height: Get.width * 0.2,
                      ),
                      Positioned(
                        // left: 240,
                        // bottom: 125,
                        top: 15,
                        right: 15,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/favorite/closeround.svg',
                            // width: Get.width * 0.2,
                          ),
                          // Image.asset(
                          //   'assets/icons/closeRound.png',
                          //   width: Get.width * 0.2,
                          //   height: Get.width * 0.2,
                          // ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'New Version !!',
                    style: kDarkLargeStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We added new features and fixed some issues to make your experience smoother.',
                    // style: kBlackMediumStyle,
                    style: kBlackLightMediumStyle.copyWith(
                        // color: Color(0xff434343),
                        // fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(horizontal: 10),
                  const SizedBox(height: 30),
                  GradientBtn(
                    text: 'Update Now',
                    width: false,
                    widthSize: 120,
                    onTap: onTap,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

notificationDeleteDialog({
  required BuildContext context,
  required String title1,
  required String title2,
  required onTap,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 15.0),
                Text(
                  title1,
                  style: kBlackDarkSuperLargeStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  title2,
                  style: kWhiteLightExtraLargeStyle.copyWith(color: Color(0xFF434343)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CommonBorderBtn(
                        border: Border.all(color: Color(0xff0E76BC)),
                        onTap: () {
                          Get.back();
                        },
                        title: "Cancel",
                        style: kPrimaryExtraDarkSuperLargeStyle.copyWith(
                          fontSize: 18,
                          color: const Color(0xff0E76BC),
                        )),
                    WhiteBluBtn(
                      width: 150,
                      onTap: onTap,
                      text: "Delete",
                      widthSize: Get.width * 0.34,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
