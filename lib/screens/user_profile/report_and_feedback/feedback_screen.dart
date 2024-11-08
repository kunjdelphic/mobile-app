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

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState btnState = ButtonState.idle;
  // late String title, message;
  DateTime timestamp = DateTime.now();
  UserProfileController userProfileController = Get.find();

  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 2, end: 10).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);
  }

  void _shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _titleMessage;
  String? _validateTitle(String? value) {
    if (value!.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  String? _issuesMessage;
  String? _validateIssues(String? value) {
    if (value!.trim().isEmpty) {
      return 'Issue is required';
    }
    return null;
  }

  sendFeedback() async {
    if (_formKey.currentState!.validate() && userProfileController.titleController.text.isNotEmpty && userProfileController.issueController.text.isNotEmpty) {
      _formKey.currentState!.save();
      print("AI CAll ++++++ ");
      setState(() {
        btnState = ButtonState.loading;
      });
      // if (userProfileController.titleController.text.isNotEmpty && userProfileController.issueController.text.isEmpty) {
      // _formKey.currentState!.save();

      print({
        "email": "${userProfileController.userProfile.value.data!.email}",
        "name": "${userProfileController.userProfile.value.data!.name}",
        "title": "${userProfileController.titleController.text}",
        "message": "${userProfileController.issueController.text}",
      });
      var res = await userProfileController.sendUserFeedback({
        "email": "${userProfileController.userProfile.value.data!.email}",
        "name": "${userProfileController.userProfile.value.data!.name}",
        "title": "${userProfileController.titleController.text}",
        "message": "${userProfileController.issueController.text}",
      });

      setState(() {
        btnState = ButtonState.idle;
      });

      if (res!.isEmpty) {
        //reported
        // if (userProfileController.titleController.text.isNotEmpty && userProfileController.issueController.text.isNotEmpty) {
        showFeedbackCompletedDialog();
        // }
      } else {
        //error
        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }

  showFeedbackCompletedDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CompletedDialog(
          title: 'We have received your request, kindly check your mail, for further communication',
          buttonTitle: "OK", //'Review Us',
          onTap: () {
            //take to playstore or appstore review page
            Get.back();
            userProfileController.titleController.clear();
            userProfileController.issueController.clear();
          },
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
          "Contact Support",
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
                // validator: (value) {
                //   if (value!.trim().isEmpty) {
                //     return 'Title is required';
                //   }
                //   return null;
                // },
                validator: (value) {
                  _titleMessage = _validateTitle(value);
                  if (_titleMessage != null) {
                    _shake();
                  }
                  return null;
                },
                // onSaved: (val) {
                //   title = val!.trim();
                // },
                controller: userProfileController.titleController,
                enableInteractiveSelection: true,
                style: kBlackMediumStyle,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  helperStyle: kRedSmallLightMediumStyle,
                  errorStyle: kRedSmallLightMediumStyle,
                  hintStyle: kBlackSmallLightMediumStyle,
                  hintText: '',
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
              if (_titleMessage != null)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_animation.value - 1, 1),
                      child: child,
                    );
                  },
                  child: Text(_titleMessage!, style: kRedSmallLightMediumStyle),
                ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Your Issue:',
                style: kBlackMediumStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                // validator: (value) {
                //   if (value!.trim().isEmpty) {
                //     return 'Issue is required';
                //   }
                //   return null;
                // },
                validator: (value) {
                  _issuesMessage = _validateIssues(value);
                  if (_issuesMessage != null) {
                    _shake();
                  }
                  return null;
                },
                // onSaved: (val) {
                //   message = val!.trim();
                // },
                controller: userProfileController.issueController,
                enableInteractiveSelection: true,
                style: kBlackMediumStyle,
                textInputAction: TextInputAction.done,
                minLines: 4,
                maxLines: 6,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  helperStyle: kRedSmallLightMediumStyle,
                  errorStyle: kRedSmallLightMediumStyle,
                  hintStyle: kBlackSmallLightMediumStyle,
                  hintText: 'eg: App is Great to use.',
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
              if (_issuesMessage != null)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_animation.value - 1, 1),
                      child: child,
                    );
                  },
                  child: Text(_issuesMessage!, style: kRedSmallLightMediumStyle),
                ),
              const SizedBox(
                height: 20,
              ),
              GradientButton(
                text: 'Send',
                width: true,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await sendFeedback();
                    setState(() {});
                  } else {
                    setState(() {});
                  }
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
