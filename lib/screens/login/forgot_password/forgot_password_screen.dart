import 'package:flutter/material.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/models/signup/forgot_password.dart';
import 'package:parrotpos/screens/login/forgot_password/reset_password_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? email;
  ButtonState loginBtnState = ButtonState.idle;
  bool isOtpSent = false;
  final LoginController loginController = Get.put(LoginController());
  late ForgotPassword forgotPassword;

  reqForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        loginBtnState = ButtonState.loading;
      });

      ForgotPassword? res = await loginController.forgotPassword({
        "email": email,
      });

      forgotPassword = res!;

      if (res.sessionId.isNotEmpty) {
        //sign up complete

        setState(() {
          loginBtnState = ButtonState.idle;
          isOtpSent = true;
        });
      } else {
        //failed
        setState(() {
          loginBtnState = ButtonState.idle;
          isOtpSent = false;
        });

        errorSnackbar(title: "Reset Password Failed", subtitle: res.message);
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
            "Forgot Password",
            style: kBlackLargeStyle,
          ),
        ),
        body: isOtpSent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/forgot_password/otp_sent_reset_password.png',
                    width: size.width,
                    height: size.height * 0.45,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'An OTP has been sent to',
                    style: kBlackMediumStyle,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    email ?? 'NA',
                    style: kPrimaryDarkMediumStyle,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Be sure to also check your spam inbox.',
                    style: kPrimaryMediumStyle,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GradientButton(
                    text: 'Enter OTP',
                    width: false,
                    onTap: () {
                      Get.to(
                        () => ResetPasswordScreen(
                          forgotPassword: forgotPassword,
                        ),
                      );
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
                      'Enter your email',
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Email address is required';
                        }
                        if (!RegExp(
                                r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        email = val!.trim();
                      },
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
                        hintText: 'Email address',
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
                    const SizedBox(
                      height: 20,
                    ),
                    GradientButton(
                      text: 'Reset Password',
                      width: true,
                      onTap: () {
                        reqForgotPassword();
                      },
                      widthSize: size.width - 20,
                      buttonState: loginBtnState,
                    ),
                  ],
                ),
              ));
  }
}
