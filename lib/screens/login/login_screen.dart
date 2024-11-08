import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/login_controller.dart';
import 'package:parrotpos/screens/login/forgot_password/forgot_password_screen.dart';
import 'package:parrotpos/screens/main_home.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';

import 'package:progress_state_button/progress_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email, password;
  ButtonState loginBtnState = ButtonState.idle;
  bool isPasswordVisible = false;

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        loginBtnState = ButtonState.loading;
      });

      String? res = await loginController.login({
        "email": email,
        "password": password,
      });
      print(password);
      if (res!.isEmpty) {
        //logged in

        print(RemoteService.accessId);

        Get.offAll(() => const MainHome());
      } else {
        //failed
        setState(() {
          loginBtnState = ButtonState.idle;
        });

        errorSnackbar(title: "Login Failed", subtitle: res);
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
          "Login",
          style: kBlackLargeStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email address';
                }
                // if (!RegExp(
                //         r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                //     .hasMatch(value.removeAllWhitespace)) {
                //   return 'Please enter a valid email address';
                // }
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                helperStyle: kRedSmallLightMediumStyle,
                errorStyle: kRedSmallLightMediumStyle,
                hintStyle: kBlackSmallLightMediumStyle,
                hintText: 'Email address',
                labelStyle: kRedSmallLightMediumStyle,
                fillColor: kWhite,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.black38, width: 0.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: kTextboxBorderColor, width: 1.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Password',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              // validator: (val) {
              //   if (val!.trim().isEmpty) {
              //     return 'Password is required';
              //   }
              //   // if (val.trim().length < 6) {
              //   //   return 'Password should be more than 6 characters';
              //   // }
              //   return null;
              // },
              // onSaved: (val) {
              //   password = val!.trim();
              // },
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: !isPasswordVisible,
              enableInteractiveSelection: true,
              style: kBlackMediumStyle,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                helperStyle: kRedSmallLightMediumStyle,
                errorStyle: kRedSmallLightMediumStyle,
                hintStyle: kBlackSmallLightMediumStyle,
                hintText: 'Password',
                labelStyle: kRedSmallLightMediumStyle,
                fillColor: kWhite,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.black38, width: 0.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: kTextboxBorderColor, width: 1.4),
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
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 0,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.to(() => const ForgotPasswordScreen());
                },
                child: Text(
                  'Forgot Password',
                  textAlign: TextAlign.end,
                  style: kBlackSmallMediumStyle,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Center(
            //   child: ProgressButton(
            //     progressIndicatorSize: 25.0,
            //     progressIndicatorAligment: MainAxisAlignment.center,
            //     stateWidgets: {
            //       ButtonState.idle: Text(
            //         "Login",
            //         style: kWhiteMediumStyle,
            //       ),
            //       ButtonState.loading: Container(),
            //       ButtonState.fail: Container(),
            //       ButtonState.success: Container(),
            //     },
            //     stateColors: const {
            //       ButtonState.idle: kBlueBtnColor2,
            //       ButtonState.loading: kBlueBtnColor2,
            //       ButtonState.fail: Colors.red,
            //       ButtonState.success: Colors.green,
            //     },
            //     height: 45.0,
            //     progressIndicator: const CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            //     maxWidth: MediaQuery.of(context).size.width * 0.85,
            //     minWidth: 54.0,
            //     radius: loginBtnState == ButtonState.loading ? 30.0 : 15.0,
            //     state: loginBtnState,
            //     onPressed: () {
            //       if (_formKey.currentState!.validate()) {
            //         _formKey.currentState!.save();

            //         if (loginBtnState == ButtonState.loading) {
            //           setState(() {
            //             loginBtnState = ButtonState.idle;
            //           });
            //         } else {
            //           setState(() {
            //             loginBtnState = ButtonState.loading;
            //           });
            //         }
            //       }
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            GradientButton(
              text: 'Login',
              width: true,
              onTap: () {
                login();
              },
              widthSize: size.width - 20,
              buttonState: loginBtnState,
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
