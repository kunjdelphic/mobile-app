import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parrotpos/screens/login/sign_up/sign_up_screen_2.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';

import 'package:progress_state_button/progress_button.dart';
import 'package:get/get.dart';

import '../../../services/remote_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email, password, name, confirmPassword;
  ButtonState loginBtnState = ButtonState.idle;
  bool isPasswordVisible = false, isConfirmPasswordVisible = false;
  @override
  void initState() {
    RemoteService.checkServer();
    super.initState();
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
          "Join ParrotPos",
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
              'Name',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
              onSaved: (val) {
                name = val!.trim();
              },
              enableInteractiveSelection: true,
              style: kBlackMediumStyle,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                helperStyle: kRedSmallLightMediumStyle,
                errorStyle: kRedSmallLightMediumStyle,
                hintStyle: kBlackSmallLightMediumStyle,
                hintText: 'Name',
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
              height: 15,
            ),
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
              height: 15,
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
              validator: (val) {
                if (val!.trim().isEmpty) {
                  return 'Password is required';
                }
                if (val.trim().length < 6) {
                  return 'Password should be more than 6 characters';
                }
                if (!RegExp("(?=.*?[A-Z])").hasMatch(val.trim())) {
                  return 'Password must contain at least 1 uppercase letter';
                }
                if (!RegExp("(?=.*?[a-z])").hasMatch(val.trim())) {
                  return 'Password must contain at least 1 lowercase letter';
                }
                if (!RegExp("(?=.*?[0-9])").hasMatch(val.trim())) {
                  return 'Password must contain at least 1 digit letter';
                }
                return null;
              },
              onSaved: (val) {
                password = val!.trim();
              },
              onChanged: (value) {
                password = value.trim();
              },
              obscureText: !isPasswordVisible,
              enableInteractiveSelection: true,
              style: kBlackMediumStyle,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
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
              height: 15,
            ),
            Text(
              'Confirm Password',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              validator: (val) {
                if (val!.trim().isEmpty) {
                  return 'Confirm Password is required';
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
                confirmPassword = val!.trim();
              },
              obscureText: !isConfirmPasswordVisible,
              enableInteractiveSelection: true,
              style: kBlackMediumStyle,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                helperStyle: kRedSmallLightMediumStyle,
                errorStyle: kRedSmallLightMediumStyle,
                hintStyle: kBlackSmallLightMediumStyle,
                hintText: 'Confirm Password',
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
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    });
                  },
                  icon: Icon(
                    isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            GradientButton(
              text: 'Sign Up',
              width: true,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Get.to(
                    () => SignUpScreen2(
                      map: {
                        'name': name,
                        'password': password,
                        'email': email,
                      },
                    ),
                  );
                }
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
