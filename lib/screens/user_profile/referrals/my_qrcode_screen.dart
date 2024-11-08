import 'package:dotted_border/dotted_border.dart';
import 'package:double_back_to_close/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MyQrCodeScreen extends StatefulWidget {
  const MyQrCodeScreen({Key? key}) : super(key: key);

  @override
  _MyQrCodeScreenState createState() => _MyQrCodeScreenState();
}

class _MyQrCodeScreenState extends State<MyQrCodeScreen> {
  UserProfileController userProfileController = Get.find();

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  screenshot() async {
    try {
      processingDialog(title: 'Saving the screenshot...', context: context);
      final directory = (await getApplicationDocumentsDirectory()).path; //from path_provide package
      String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
      var path = directory;
      print("+++++++++++${path}");
      print("----------${fileName}");

      String? res = await screenshotController.captureAndSave(
        path,
        fileName: fileName,
      );

      print(res);

      if (res != null) {
        await GallerySaver.saveImage(res);
        Get.back();
        successSnackbar(title: 'Success', subtitle: 'Saved the screenshot to Gallery.');
      } else {
        Get.back();
        errorSnackbar(title: 'Failed', subtitle: 'Unable to save screenshot!');
      }
    } catch (e) {
      print(e);
      Get.back();
      errorSnackbar(title: 'Failed', subtitle: 'Unable to save screenshot!');
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
            "My QR Code",
            style: kBlackLargeStyle,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: Get.width * 0.9,
                // height: Get.height * 0.7,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffFFFFFF),
                      Color(0xffD2DFF8),
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

                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: 10,
                      top: 10,
                      width: Get.width * 0.25,
                      child: Image.asset(
                        'assets/images/referral/background_dots.png',
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Image.asset(
                            'assets/images/referral/logo.png',
                            width: Get.width * 0.4,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Join Me On ParrotPos!',
                            style: kBlueBoldMediumStyle,
                          ),
                          Text(
                            'Pay, Share and Earn!',
                            style: kBlackSmallMediumStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: Get.width * 0.7,
                            child: const Divider(
                              thickness: 0.30,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Here\'s My QR Code:',
                            style: kBlackSmallMediumStyle,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: userProfileController.userProfile.value.data!.referralCode.toString()));
                              Toast.show(
                                "Referal code copied!",
                                context,
                                duration: 2,
                                gravity: Toast.top,
                                textStyle: TextStyle(fontSize: 14, color: Colors.white),
                                backgroundColor: Color(0xAA000000),
                                backgroundRadius: 20,
                              );
                            },
                            onLongPress: () {
                              print('object');
                              Clipboard.setData(ClipboardData(text: userProfileController.userProfile.value.data!.referralCode.toString()));
                              Toast.show(
                                "Referal code copied!",
                                context,
                                duration: 2,
                                gravity: Toast.top,
                                textStyle: TextStyle(fontSize: 14, color: Colors.white),
                                backgroundColor: Color(0xAA000000),
                                backgroundRadius: 20,
                              );
                              // successSnackbar1(title: 'Referal code copied!');
                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard !')));
                            },
                            child: DottedBorder(
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              color: kBlack,
                              dashPattern: const [4],
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${userProfileController.userProfile.value.data?.referralCode}',
                                      style: kBlackDarkSuperLargeStyle,
                                    ),
                                    const Text(
                                      'click to copy',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(15),
                              // image: DecorationImage(
                              //     image: NetworkImage(userProfileController
                              //         .userProfile.value.data!.qrCode
                              //         .toString()))),
                            ),
                            child: QrImageView(
                              data: '${userProfileController.userProfile.value.data?.referralCode}',
                              version: QrVersions.auto,
                              size: Get.width * 0.35,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GradientButton(
              text: 'Screenshot',
              width: true,
              onTap: () async {
                screenshot();
              },
              widthSize: Get.width * 0.9,
              buttonState: ButtonState.idle,
            ),
          ],
        ));
  }
}
