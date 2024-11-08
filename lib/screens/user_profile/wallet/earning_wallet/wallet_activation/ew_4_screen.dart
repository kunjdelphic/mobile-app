import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/user_profile/wallet/earning_wallet/wallet_activation/ew_2_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/sheets.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../../bill_payment/enable_access.dart';
import 'ew_3_screen.dart';

class EW4Screen extends StatefulWidget {
  const EW4Screen({Key? key}) : super(key: key);

  @override
  _EW4ScreenState createState() => _EW4ScreenState();
}

class _EW4ScreenState extends State<EW4Screen> {
  ButtonState submitBtnState = ButtonState.idle;
  File? selfieImage;
  UserProfileController userProfileController = Get.find();

  uploadId() async {
    if (selfieImage != null) {
      setState(() {
        submitBtnState = ButtonState.loading;
      });

      String res = await userProfileController.updateAccountVerStatus({
        'type': 'SELFIE',
        'frontImage': selfieImage,
      });

      if (res.isEmpty) {
        //updated
        setState(() {
          submitBtnState = ButtonState.idle;
        });

        taskCompletedDialog(
          title: 'Submitted.',
          buttonTitle: 'Next',
          image: 'assets/images/tick.png',
          context: context,
          onTap: () {
            Get.back();
            Get.back(result: true);
          },
          subtitle: 'Please allow up to three (3) working days for us to verify your details.',
        );
      } else {
        //failed
        setState(() {
          submitBtnState = ButtonState.idle;
        });

        errorSnackbar(title: "Failed", subtitle: 'Submitting Selfie was unsuccessful!');
      }
    } else {
      errorSnackbar(title: "Failed", subtitle: 'Select your selfie to proceed!');
    }
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
          "Take A Selfie",
          style: kBlackLargeStyle,
        ),
      ),
      body: selfieImage == null
          ? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Image.asset(
                  'assets/images/wallet/ew_selfie.png',
                  width: Get.width * 0.55,
                  height: Get.width * 0.55,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Take a Selfie with your ID.',
                  style: kBlackDarkMediumStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'To complete your verification process, please take a selfie with your ID. This helps us better confirm your identity.',
                  style: kBlackSmallLightMediumStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Tips:\n ●  Position your face and your ID within the frame.\n ●  Make sure that the image is not blurry.',
                  style: kBlackSmallLightMediumStyle,
                ),
                const SizedBox(
                  height: 25,
                ),
                const SizedBox(
                  height: 25,
                ),
                GradientButton(
                  text: 'Open Camera',
                  width: true,
                  onTap: () async {
                    PermissionStatus status = await Permission.camera.request();
                    if (status.isGranted) {
                      selfieImage = await cropImageSelfie(context, false, true);
                    } else {
                      Get.to(() => EnableAccessScreen(camera: true));
                    }

                    setState(() {});
                  },
                  widthSize: Get.width,
                  buttonState: ButtonState.idle,
                )
              ],
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                SizedBox(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    dashPattern: const [5, 5],
                    color: Colors.grey,
                    strokeWidth: 1,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          selfieImage!,

                          // height: 200,
                          // width: Get.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Please ensure your picture is clear and sharp before submitting your selfie.',
                    textAlign: TextAlign.center,
                    style: kBlackSmallLightMediumStyle,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    selfieImage = await cropImageSelfie(context, false, true);

                    setState(() {});
                  },
                  child: Center(
                    child: Container(
                      height: 45,
                      width: Get.width,
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            kBlueBtnColor1,
                            kBlueBtnColor2,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            color: kWhite,
                            size: 22,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Retake Picture',
                            style: kWhiteMediumStyle,
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
                  text: 'Submit',
                  width: true,
                  onTap: () async {
                    uploadId();
                  },
                  widthSize: Get.width,
                  buttonState: submitBtnState,
                )
              ],
            ),
    );
  }
}
