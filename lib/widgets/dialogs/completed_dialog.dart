import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class CompletedDialog extends StatefulWidget {
  final String title;
  final String buttonTitle;
  final String image;
  final void Function()? onTap;

  CompletedDialog({
    Key? key,
    required this.title,
    required this.buttonTitle,
    this.onTap,
    required this.image,
  }) : super(key: key);

  @override
  _CompletedDialogState createState() => _CompletedDialogState();
}

class _CompletedDialogState extends State<CompletedDialog> {
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
                widget.image,
                width: Get.width * 0.2,
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                widget.title,
                style: kBlackMediumStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              GradientButton(
                text: widget.buttonTitle,
                width: true,
                widthSize: Get.width * 0.65,
                onTap: widget.onTap ??
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
    );
  }
}
