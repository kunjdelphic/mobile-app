import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/screens/user_profile/phone_number/change_phone_no_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../controllers/user_profile_controller.dart';

class ChangePhoneNoDialog extends StatefulWidget {
  const ChangePhoneNoDialog({Key? key}) : super(key: key);

  @override
  _ChangePhoneNoDialogState createState() => _ChangePhoneNoDialogState();
}

class _ChangePhoneNoDialogState extends State<ChangePhoneNoDialog> {
  UserProfileController userProfileController = Get.find();
  @override
  Widget build(BuildContext context) {
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
              Image.asset(
                'assets/icons/change_phone_dl.png',
                width: Get.width * 0.2,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${userProfileController.userProfile.value.data!.phoneNumber}',
                style: kBlackDarkExtraLargeStyle,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'This Is Your current phone number.\nDo you want to change phone number?',
                style: kBlackSmallMediumStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: WhiteButton(
                      text: 'Yes',
                      width: false,
                      widthSize: 0,
                      onTap: () {
                        Get.back();
                        Get.to(() => const ChangePhoneNoScreen());
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GradientButton(
                      text: 'No',
                      btnColor: true,
                      width: false,
                      widthSize: 0,
                      onTap: () {
                        Get.back();
                      },
                      buttonState: ButtonState.idle,
                    ),
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
  }
}
