import 'package:flutter/material.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/models/signup/signup_referral.dart';
import 'package:parrotpos/screens/qr_code_scanner_screen.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';

import 'package:progress_state_button/progress_button.dart';
import 'package:get/get.dart';

import 'sign_up_screen_4.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({Key? key}) : super(key: key);

  @override
  _SignUpScreen3State createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String referralCode;
  ButtonState loginBtnState = ButtonState.idle;
  bool isConfirmed = false;
  bool isReferrerAdded = false;
  late SignupReferral signupReferral;
  final LoginController loginController = Get.put(LoginController());
  // late Future _imageFuture = getImage();
  TextEditingController referralCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _imageFuture = getImage();
  }

  signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        loginBtnState = ButtonState.loading;
      });

      signupReferral = await loginController.getReferralDetails({
        "referral_code": referralCode,
        // "access_id": RemoteService.accessId,
      });
      if (signupReferral.email.isNotEmpty) {
        //sign up complete
        setState(() {
          isConfirmed = true;
          loginBtnState = ButtonState.idle;
        });
        // getImage();

        // Get.offAll(() => const SignUpScreen3());
      } else {
        //failed
        setState(() {
          loginBtnState = ButtonState.idle;
        });

        errorSnackbar1(title: signupReferral.message);
      }
    }
  }

  addReferral() async {
    setState(() {
      loginBtnState = ButtonState.loading;
    });

    signupReferral = await loginController.signUpReferral({
      "referral_code": referralCode,
      // "access_id": RemoteService.accessId,
    });
    if (signupReferral.email.isNotEmpty) {
      //sign up complete
      setState(() {
        isReferrerAdded = true;
        loginBtnState = ButtonState.idle;
      });

      // Get.offAll(() => const SignUpScreen3());
    } else {
      //failed
      setState(() {
        loginBtnState = ButtonState.idle;
      });

      errorSnackbar(title: "Signup Failed", subtitle: signupReferral.message);
    }
  }

  // Future getImage() async {
  //   if (isConfirmed) {
  //     var res = await RemoteService.client.get(
  //       Uri.parse(signupReferral.profileImage),
  //       headers: {
  //         "Content-type": "application/json; charset=utf-8",
  //         "access_id": RemoteService.accessId,
  //       },
  //     );
  //     var response = jsonDecode(res.body);

  //     if (response['status'] == 200) {
  //       print(response);
  //       return response['url'];
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // submitReferral() async {
  //   processingDialog(title: 'Processing..\nPlease wait.', context: context);

  //   signupReferral = await loginController.signUpReferral({
  //     "referral_code": referralCodeController.text.trim(),
  //   });

  //   Get.back();

  //   if (signupReferral.email.isNotEmpty) {
  //     setState(() {
  //       isConfirmed = true;
  //     });

  //     userProfileController.getUserDetails();
  //   } else {
  //     //failed
  //     errorSnackbar(title: "Failed", subtitle: signupReferral!.message);
  //   }
  // }

  // getImage() async {
  //   var res = await RemoteService.client.get(
  //     Uri.parse(signupReferral.profileImage),
  //     headers: {
  //       "Content-type": "application/json; charset=utf-8",
  //       "access_id": RemoteService.accessId,
  //     },
  //   );
  //   var response = jsonDecode(res.body);

  //   if (response['status'] == 200) {
  //     print(response);
  //   } else {
  //     errorSnackbar(
  //         title: "Failed", subtitle: 'Unable to fetch the profile image!');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: BackButton(
          onPressed: () {
            setState(() {
              isConfirmed = false;
            });
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Referral",
          style: kBlackLargeStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: isConfirmed
            ? ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Text(
                    'Referrer:',
                    style: kBlackMediumStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(26, 184, 183, 183),
                    radius: size.width * 0.16,

                    backgroundImage: signupReferral.profileImage
                            .contains('no_image')
                        ? null
                        : NetworkImage(signupReferral.profileImage, headers: {
                            "Content-type": "application/json; charset=utf-8",
                            "access_id": RemoteService.accessId,
                          }),
                    child: signupReferral.profileImage.contains('no_image')
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                                'assets/images/logo/parrot_logo.png'),
                          )
                        : null,
                    // child: FutureBuilder(
                    //   future: _imageFuture,
                    //   builder: (context, snapshot) {
                    //     String profileImageUrl = '';

                    //     return Image.network(profileImageUrl);
                    //   },
                    // ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isReferrerAdded
                      ? Column(
                          children: [
                            const Center(
                                child: CircleAvatar(
                              radius: 20,
                              backgroundColor: kColorPrimary,
                              child: Icon(
                                Icons.done,
                                color: kWhite,
                                size: 22,
                              ),
                            )),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'Referer Added!',
                                textAlign: TextAlign.center,
                                style: kBlackMediumStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GradientButton(
                              text: 'Next',
                              width: true,
                              onTap: () {
                                Get.to(() => const SignUpScreen4());
                                // setState(() {
                                //   isReferrerAdded = false;
                                //   isConfirmed = false;
                                // });
                              },
                              widthSize: size.width - 20,
                              buttonState: loginBtnState,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                signupReferral.name,
                                textAlign: TextAlign.center,
                                style: kBlackLargeStyle,
                              ),
                            ),
                            // Center(
                            //   child: Text(
                            //     'Joined on: 31.01.2021',
                            //     textAlign: TextAlign.center,
                            //     style: kBlackLightMediumStyle,
                            //   ),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: WhiteButton(
                                    text: 'Back',
                                    width: false,
                                    widthSize: 0,
                                    onTap: () {
                                      setState(() {
                                        isConfirmed = false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: GradientButton(
                                    text: 'Confirm',
                                    btnColor: true,
                                    width: true,
                                    onTap: () {
                                      addReferral();
                                      // setState(() {
                                      //   isReferrerAdded = true;
                                      // });
                                    },
                                    widthSize: size.width - 20,
                                    buttonState: loginBtnState,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            WhiteButton(
                              text: 'Skip',
                              width: true,
                              widthSize: size.width,
                              onTap: () {
                                setState(() {
                                  isConfirmed = false;
                                  loginBtnState = ButtonState.idle;
                                  Get.to(() => const SignUpScreen4());
                                });
                              },
                            ),
                          ],
                        ),
                ],
              )
            : ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  Image.asset(
                    'assets/images/referral/add_referral.png',
                    height: size.height * 0.25,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Enter your Referral Code',
                      style: kBlackMediumStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var res =
                              await Get.to(() => const QrCodeScannerScreen());
                          if (res != null) {
                            setState(() {
                              referralCodeController.text = res.code;
                            });
                          }
                        },
                        child: Container(
                          width: 47,
                          height: 47,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kWhite,
                            border: Border.all(
                              color: Colors.black38,
                              width: 0.3,
                            ),
                          ),
                          child: const Icon(
                            Icons.qr_code_scanner_outlined,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: referralCodeController,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Referral Code is required';
                            }

                            return null;
                          },
                          onSaved: (val) {
                            referralCode = val!.trim();
                          },
                          enableInteractiveSelection: true,
                          style: kBlackMediumStyle,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 14),
                            helperStyle: kRedSmallLightMediumStyle,
                            errorStyle: kRedSmallLightMediumStyle,
                            hintStyle: kBlackSmallLightMediumStyle,
                            hintText: 'Referral Code',
                            labelStyle: kRedSmallLightMediumStyle,
                            fillColor: kWhite,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.black38, width: 0.3),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: kTextboxBorderColor, width: 1.4),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GradientButton(
                    text: 'Next',
                    width: true,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        signup();
                      }
                    },
                    widthSize: size.width - 20,
                    buttonState: loginBtnState,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  WhiteButton(
                    text: 'Skip',
                    width: false,
                    widthSize: 0,
                    onTap: () {
                      setState(() {
                        isConfirmed = false;
                        loginBtnState = ButtonState.idle;
                        Get.to(() => const SignUpScreen4());
                      });
                    },
                  ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // Text(
                  //   'Don\'t have an account?',
                  //   textAlign: TextAlign.center,
                  //   style: kBlackMediumStyle,
                  // ),
                  // const Divider(thickness: 0.30),
                  // Image.asset(
                  //   'assets/images/logo/parrotpos_logo.png',
                  //   // width: size.width * 0.2,
                  //   height: 25,
                  // ),
                ],
              ),
      ),
    );
  }
}
