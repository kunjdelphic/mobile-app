import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/completed_dialog.dart';
import 'package:progress_state_button/progress_button.dart';

class PhoneNoOtpReportScreen extends StatefulWidget {
  final String phoneNo;
  const PhoneNoOtpReportScreen({Key? key, required this.phoneNo})
      : super(key: key);

  @override
  _PhoneNoOtpReportScreenState createState() => _PhoneNoOtpReportScreenState();
}

class _PhoneNoOtpReportScreenState extends State<PhoneNoOtpReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState loginBtnState = ButtonState.idle;
  late String title, report;
  DateTime timestamp = DateTime.now();

  sendReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showReportCompletedDialog();
    }
  }

  showReportCompletedDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CompletedDialog(
          title:
              'Your issue is being reviewed. We will contact you within three (3) working days.',
          buttonTitle: 'Close',
          image: 'assets/icons/change_phone_dl.png',
        );
      },
    );
    Get.back(result: true);
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
          "Report",
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
              'Name:',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            GetX<UserProfileController>(
              init: UserProfileController(),
              initState: (_) {},
              builder: (_) {
                return Text(
                  "${_.userProfile.value.data!.name}",
                  style: kPrimaryMediumStyle,
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Date:',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              DateFormat('dd.MM.yyyy | hh:MM:s').format(timestamp),
              style: kPrimaryMediumStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Number to Change:',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Phone number is required';
                }
                if (!value.trim().startsWith('01')) {
                  return 'Phone number is invalid';
                }
                if (value.trim().length < 10 || value.trim().length > 11) {
                  return 'Phone number is invalid';
                }
                return null;
              },
              onSaved: (val) {
                title = val!.trim();
              },
              enableInteractiveSelection: true,
              style: kBlackMediumStyle,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              initialValue: widget.phoneNo,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                helperStyle: kRedSmallLightMediumStyle,
                errorStyle: kRedSmallLightMediumStyle,
                hintStyle: kBlackSmallLightMediumStyle,
                hintText: '',
                labelStyle: kRedSmallLightMediumStyle,
                fillColor: kWhite,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: Colors.black38, width: 0.3),
                ),
                suffixIcon: const Icon(
                  Icons.edit,
                  color: kColorPrimary,
                  size: 18,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: kTextboxBorderColor, width: 1.4),
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
              'Your Report:',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Report is required';
                }
                return null;
              },
              onSaved: (val) {
                report = val!.trim();
              },
              enableInteractiveSelection: true,
              style: kBlackMediumStyle,
              textInputAction: TextInputAction.done,
              minLines: 4,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                helperStyle: kRedSmallLightMediumStyle,
                errorStyle: kRedSmallLightMediumStyle,
                hintStyle: kBlackSmallLightMediumStyle,
                hintText:
                    'I wish to change my phone number but I did not receive an OTP for this new number.',
                labelStyle: kRedSmallLightMediumStyle,
                fillColor: kWhite,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: Colors.black38, width: 0.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide:
                      const BorderSide(color: kTextboxBorderColor, width: 1.4),
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
              text: 'Send Report',
              width: true,
              onTap: () {
                sendReport();
              },
              widthSize: Get.width,
              buttonState: loginBtnState,
            ),
          ],
        ),
      ),
    );
  }
}
