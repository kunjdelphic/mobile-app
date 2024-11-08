import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/login/main_login_screen.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../style/style.dart';

class DeleteFlow2Screen extends GetView<UserProfileController> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Delete Account",
          style: kBlackLargeStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 35,
            ),
            Image.asset(
              'assets/images/exclaim.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Proceed to delete this account?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Text(
                "Deleting this ParrotPos account is permanent. Your data cannot be recovered if you reactivate this account in the future.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(
              height: 65,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GradientButton(
                    text: "Back",
                    width: true,
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                    widthSize: MediaQuery.of(context).size.width * 0.4,
                    buttonState: ButtonState.idle),
                WhiteButton(
                  text: "Delete",
                  width: true,
                  onTap: () async {
                    controller.deleteAccount();

                    // Get.offAll(() => MainLoginScreen(),
                    //     transition: Transition.rightToLeft,
                    //     arguments: 'app-level');
                    await GetStorage().write('accessId', null);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainLoginScreen()), (route) => false);
                  },
                  widthSize: MediaQuery.of(context).size.width * 0.4,
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
