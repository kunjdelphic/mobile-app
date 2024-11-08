import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

errorSnackbar1({
  required String title,
}) {
  Get.showSnackbar(
    GetSnackBar(
      margin: const EdgeInsets.all(40),
      borderRadius: 30,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      messageText: Text(
        'Invalid Referral Code',
        style: kWhiteDarkMediumStyle,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

errorSnackbar({
  required String title,
  required String subtitle,
}) {
  Get.snackbar(
    title,
    subtitle,
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: Colors.red,
    titleText: Text(
      title,
      style: kWhiteDarkMediumStyle,
    ),
    messageText: Text(
      subtitle,
      style: kWhiteSmallMediumStyle,
    ),
  );
  // return SnackBar(
  //   backgroundColor: Colors.red,
  //   content: Text(
  //     text,
  //     style: kWhiteMediumStyle,
  //   ),
  //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //   elevation: 1,
  //   behavior: SnackBarBehavior.floating,
  //   action: SnackBarAction(
  //     label: labelText,
  //     textColor: kWhite,
  //     onPressed: () {},
  //   ),
  //   duration: const Duration(milliseconds: 2000),
  // );
}

successSnackbar1({
  required String title,
}) {
  Get.showSnackbar(GetSnackBar(
    margin: const EdgeInsets.all(40),
    borderRadius: 30,
    backgroundColor: kMediumBlack,
    duration: const Duration(seconds: 3),
    snackPosition: SnackPosition.BOTTOM,
    messageText: Text(
      title,
      style: kWhiteDarkMediumStyle,
      textAlign: TextAlign.center,
    ),
  ));
}

successSnackbar({
  required String title,
  required String subtitle,
}) {
  Get.snackbar(
    title,
    subtitle,
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: kColorPrimary,
    titleText: Text(
      title,
      style: kWhiteDarkMediumStyle,
    ),
    messageText: Text(
      subtitle,
      style: kWhiteSmallMediumStyle,
    ),
  );
  // return SnackBar(
  //   backgroundColor: kColorPrimary,
  //   content: Text(
  //     text,
  //     style: kWhiteMediumStyle,
  //   ),
  //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
  //   elevation: 1,
  //   behavior: SnackBarBehavior.floating,
  //   action: SnackBarAction(
  //     label: labelText,
  //     textColor: kWhite,
  //     onPressed: () {},
  //   ),
  //   duration: const Duration(milliseconds: 2000),
  // );
}

successSnackbarBlackBackGround({
  required String title,
  required String subtitle,
}) {
  Get.snackbar(
    title,
    subtitle,
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: kMediumBlack,
    titleText: Text(
      title,
      style: kWhiteDarkMediumStyle,
    ),
    messageText: Text(
      subtitle,
      style: kWhiteSmallMediumStyle,
    ),
  );
}
