import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/models/signup/forgot_password.dart';
import 'package:parrotpos/screens/login/main_login_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

import '../../../services/remote_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final ForgotPassword forgotPassword;
  const ResetPasswordScreen({
    Key? key,
    required this.forgotPassword,
  }) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  ButtonState loginBtnState = ButtonState.idle;
  bool isPasswordVisible = false, isRetypePasswordVisible = false;
  late String password, retypePassword, otp = '';
  bool isResetComplete = false;
  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    RemoteService.checkServer();
    super.initState();
  }

  reqForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (otp.trim().isEmpty) {
        Get.snackbar(
          "Failed",
          'OTP is incorrect',
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Failed",
            style: kWhiteDarkMediumStyle,
          ),
          messageText: Text(
            'OTP is incorrect',
            style: kWhiteSmallMediumStyle,
          ),
        );
        return;
      }

      setState(() {
        loginBtnState = ButtonState.loading;
      });

      print({
        "sessionId": widget.forgotPassword.sessionId,
        "otp": otp,
        "password": password,
      });

      String? res = await loginController.verifyForgotPassword({
        "session_id": widget.forgotPassword.sessionId,
        "otp": otp,
        "password": password,
      });
      if (res!.isEmpty) {
        //sign up complete
        setState(() {
          isResetComplete = true;
        });
        // Get.offAll(() => const MainLoginScreen());
      } else {
        //failed
        setState(() {
          loginBtnState = ButtonState.idle;
          isResetComplete = false;
        });
        Get.snackbar(
          "Reset Password",
          res,
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text(
            "Reset Password Failed",
            style: kWhiteDarkMediumStyle,
          ),
          messageText: Text(
            res,
            style: kWhiteSmallMediumStyle,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Reset New Password",
            style: kBlackLargeStyle,
          ),
        ),
        body: isResetComplete
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/forgot_password/password_reset_complete.png',
                    width: size.width,
                    height: size.height * 0.4,
                  ),
                  const Icon(
                    Icons.done,
                    size: 60,
                    color: kColorPrimary,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Your password has been reset.\nYou may proceed to login.',
                    style: kBlackMediumStyle,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GradientButton(
                    text: 'Login',
                    width: false,
                    onTap: () {
                      Get.offAll(() => const MainLoginScreen());
                    },
                    widthSize: 0,
                    buttonState: ButtonState.idle,
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    Text(
                      'Type New Password',
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'New Password is required';
                        }
                        if (val.trim().length < 6) {
                          return 'Password should be more than 6 characters';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        email = val!.trim();
                      },
                      onChanged: (value) {
                        password = value.trim();
                      },
                      obscureText: !isPasswordVisible,
                      enableInteractiveSelection: true,
                      style: kBlackMediumStyle,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 14),
                        helperStyle: kRedSmallLightMediumStyle,
                        errorStyle: kRedSmallLightMediumStyle,
                        hintStyle: kBlackSmallLightMediumStyle,
                        hintText: 'New Password',
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Retype New Password',
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'New Password is required';
                        }
                        if (val.trim().length < 6) {
                          return 'Password should be more than 6 characters';
                        }
                        if (password != val.trim()) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        email = val!.trim();
                      },
                      obscureText: !isRetypePasswordVisible,
                      enableInteractiveSelection: true,
                      style: kBlackMediumStyle,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 14),
                        helperStyle: kRedSmallLightMediumStyle,
                        errorStyle: kRedSmallLightMediumStyle,
                        hintStyle: kBlackSmallLightMediumStyle,
                        hintText: 'Retype Password',
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isRetypePasswordVisible =
                                  !isRetypePasswordVisible;
                            });
                          },
                          icon: Icon(
                            isRetypePasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Center(
                      child: Text(
                        'Enter OTP sent to your email',
                        style: kBlackMediumStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OtpTextField(
                      keyboardType: TextInputType.number,
                      textStyle: kBlackLargeStyle,
                      borderColor: kColorPrimary,
                      focusedBorderColor: kColorPrimary,
                      numberOfFields: 4,

                      // onCodeChanged: (value) {
                      //   List<String> pin = [];

                      //   for (int i = 0; i < value.length; i++) {
                      //     if (value[i] != null && value[i] != '') {
                      //       pin.add(value[i]);
                      //     }
                      //   }
                      //   otp = pin.join();

                      //   print(otp);
                      // },
                      onSubmit: (value) {
                        otp = value;
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    GradientButton(
                      text: 'Update',
                      width: true,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          if (otp.isEmpty) {
                            errorSnackbar(
                                title: "Reset Password",
                                subtitle: 'Enter OTP sent to your email');

                            return;
                          }

                          reqForgotPassword();
                        }
                      },
                      widthSize: size.width - 20,
                      buttonState: loginBtnState,
                    ),
                  ],
                ),
              ));
  }
}
