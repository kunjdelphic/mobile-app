import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/screens/user_profile/delete_account/delete_flow_2.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../style/style.dart';

class DeleteFlow1Screen extends GetView<UserProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();

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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 35,
                ),
                Image.asset(
                  'assets/images/delet2.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Want to delete account?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: const Text(
                    "Once your account is deleted, all of its resources and data will be permanently deleted. Please enter your phone number used to sign up to confirm you would like to permanently delete your account  ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Obx(
                      () => TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          errorText: !controller.isPhoneNumberValid.value
                              ? null
                              : "Invalid phone number",
                        ),
                        onChanged: (value) => controller.setPhonetext(value),
                        textAlign:
                            TextAlign.center, // Align the text to the center
                        style: TextStyle(
                            color: !controller.isPhoneNumberValid.value
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                const SizedBox(
                  height: 95,
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
                        },
                        widthSize: MediaQuery.of(context).size.width * 0.4,
                        buttonState: ButtonState.idle),
                    WhiteButton(
                      text: "Next",
                      width: true,
                      onTap: () {
                        // ignore: unrelated_type_equality_checks

                        if ((controller.phonetext.value.startsWith("01") &&
                            controller.phonetext.value.length >= 10 &&
                            controller.phonetext.value.length <= 11)) {
                          if (controller.phonetext ==
                              controller.userProfile.value.data!.phoneNumber) {
                            Get.to(() => DeleteFlow2Screen(),
                                transition: Transition.rightToLeft,
                                arguments: 'app-level');
                          } else {
                            phoneMismatchDialog(
                                title:
                                    "The phone number you entered doesn't match your account ",
                                buttonTitle: "OK",
                                image: "assets/icons/change_phone_dl.png",
                                context: context);
                          }
                        } else {
                          controller.setIsPhoneNumberValid(true);
                        }
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
