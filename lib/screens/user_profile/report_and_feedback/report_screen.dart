import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/completed_dialog.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState btnState = ButtonState.idle;
  DateTime timestamp = DateTime.now();
  late String title, report;
  UserProfileController userProfileController = Get.find();

  sendReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        btnState = ButtonState.loading;
      });

      var res = await userProfileController.sendUserReport({
        "email": "${userProfileController.userProfile.value.data!.email}",
        "name": "${userProfileController.userProfile.value.data!.name}",
        "title": title,
        "report": report
      });

      setState(() {
        btnState = ButtonState.idle;
      });

      if (res!.isEmpty) {
        //reported
        showReportCompletedDialog();
      } else {
        //error
        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }

  showReportCompletedDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CompletedDialog(
          title:
              'Thank you for your report.\nWe will contact you within\nthree (3) working days.',
          buttonTitle: 'Close',
          image: 'assets/icons/change_phone_dl.png',
        );
      },
    );
    Get.back();
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
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
                'Title:',
                style: kBlackMediumStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Title is required';
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
                      'eg: I paid my Celcom Postpaid bill but my payment was not updated.',
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
                text: 'Send Report',
                width: true,
                onTap: () {
                  sendReport();
                },
                widthSize: Get.width,
                buttonState: btnState,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
