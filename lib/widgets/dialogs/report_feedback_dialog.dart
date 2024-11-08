import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/screens/user_profile/phone_number/change_phone_no_screen.dart';
import 'package:parrotpos/screens/user_profile/report_and_feedback/feedback_screen.dart';
import 'package:parrotpos/screens/user_profile/report_and_feedback/report_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ReportFeedbackDialog extends StatefulWidget {
  const ReportFeedbackDialog({Key? key}) : super(key: key);

  @override
  _ReportFeedbackDialogState createState() => _ReportFeedbackDialogState();
}

class _ReportFeedbackDialogState extends State<ReportFeedbackDialog> {
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
                height: 20,
              ),
              Image.asset(
                'assets/icons/change_phone_dl.png',
                width: Get.width * 0.2,
              ),
              const SizedBox(
                height: 15,
              ),
              GradientButton(
                text: 'Send Report',
                width: true,
                widthSize: Get.width * 0.65,
                onTap: () {
                  Get.off(() => const ReportScreen());
                },
                buttonState: ButtonState.idle,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'OR',
                style: kBlackMediumStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              GradientButton(
                text: 'Send Feedback',
                width: true,
                widthSize: Get.width * 0.65,
                onTap: () {
                  Get.off(() => const FeedbackScreen());
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
    );
  }
}
