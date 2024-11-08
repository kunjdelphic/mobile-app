import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/completed_dialog.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class FundRequestForm extends StatefulWidget {
  const FundRequestForm({Key? key}) : super(key: key);

  @override
  _FundRequestFormState createState() => _FundRequestFormState();
}

class _FundRequestFormState extends State<FundRequestForm> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState btnState = ButtonState.idle;
  // late String name, phone, purpose;

  UserProfileController userProfileController = Get.find();

  bool submitted = false;

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

  String? _nameMessage;
  String? _validateName(String? value) {
    if (value!.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _phoneMessage;
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    } else if (value.trim().length < 10 || value.trim().length > 11) {
      return 'Invalid Phone Number';
    } else if (!value.trim().startsWith('01')) {
      return 'Invalid Phone Number!';
    } else {
      return null;
    }
  }

  String? _purposeMessage;
  String? _validatePurpose(String? value) {
    if (value!.trim().isEmpty) {
      return 'Issue is required';
    }
    return null;
  }

  sendFundRequest() async {
    if (_formKey.currentState!.validate() &&
        userProfileController.nameController.text.isNotEmpty &&
        userProfileController.phoneNoController.text.isNotEmpty &&
        userProfileController.purposeController.text.isNotEmpty) {
      _formKey.currentState!.save();
      print("-- API CALLING ");
      setState(() {
        btnState = ButtonState.loading;
      });
      // _validationMessage;
      var res = await userProfileController.fundRequest({
        "name": userProfileController.nameController.text,
        "phone_number": userProfileController.phoneNoController.text,
        "purpose": userProfileController.purposeController.text,
      });
      // _formKey.currentState!.save();
      setState(() {
        btnState = ButtonState.idle;
      });

      if (res!.isEmpty) {
        // if (userProfileController.nameController.text.isNotEmpty && userProfileController.phoneNoController.text.isNotEmpty && userProfileController.purposeController.text.isNotEmpty) {
        showRequestCompletedDialog();
        // }
      } else {
        //error
        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }

  showRequestCompletedDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CompletedDialog(
          title: '"We have received your\nrequest, we will connect shortly."',
          buttonTitle: 'Close',
          image: 'assets/icons/change_phone_dl.png',
        );
      },
    );
    Get.back();
    userProfileController.nameController.clear();
    userProfileController.phoneNoController.clear();
    userProfileController.purposeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(CupertinoIcons.back)),
        elevation: 0.3,
        shadowColor: Colors.grey.shade500,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Fund Request Form",
          style: kBlackLargeStyle,
        ),
      ),
      body: submitted
          ? Container(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(height: 50),
                SvgPicture.asset("assets/images/donation/submit_icon.svg"),
                const SizedBox(
                  height: 30,
                ),
                Text('Your submission was \nsuccessful.', textAlign: TextAlign.center, style: kBlackDarkSuperLargeStyle),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    "We will contact you soon. Your privacy is important to us, and we will handle your information professionally and securely. We appreciate your patience and look forward to assisting you.",
                    style: kBlackMediumStyle.copyWith(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                GradientButton(
                    text: "Back",
                    width: false,
                    onTap: () {
                      Get.back();
                    },
                    widthSize: 0,
                    buttonState: null)
              ]),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    // GetX<UserProfileController>(
                    //   init: UserProfileController(),
                    //   initState: (_) {},
                    //   builder: (_) {
                    //     return Text(
                    //       "${_.userProfile.value.data!.name}",
                    //       style: kPrimaryMediumStyle,
                    //     );
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Personal Information",
                      style: kBlackDarkSuperLargeStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Name:',
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      // validator: (value) {
                      //   if (value!.trim().isEmpty) {
                      //     return 'Name is required';
                      //   }
                      //   return null;
                      // },
                      validator: (value) {
                        _nameMessage = _validateName(value);
                        if (_nameMessage != null) {
                          _shake();
                        }
                        return null;
                      },
                      // onSaved: (val) {
                      //   name = val!.trim();
                      // },
                      controller: userProfileController.nameController,
                      enableInteractiveSelection: true,
                      style: kBlackMediumStyle,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        helperStyle: kRedSmallLightMediumStyle,
                        errorStyle: kRedSmallLightMediumStyle,
                        hintStyle: kBlackSmallLightMediumStyle,
                        hintText: 'Enter Name Here',
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
                    if (_nameMessage != null)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_animation.value - 1, 1),
                            child: child,
                          );
                        },
                        child: Text(_nameMessage!, style: kRedSmallLightMediumStyle),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Phone Number:',
                      style: kBlackMediumStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // TextFormField(
                    //   textAlignVertical: TextAlignVertical.center,
                    //   // validator: (value) {
                    //   //   if (value!.trim().isEmpty) {
                    //   //     return 'Phone Number is required';
                    //   //   }
                    //   //   return null;
                    //   // },
                    //   validator: (value) {
                    //     if (value!.trim().isEmpty) {
                    //       return 'Phone number is required';
                    //     }
                    //     if (!value.trim().startsWith('01')) {
                    //       return 'Invalid Phone Number!';
                    //     }
                    //     if (value.trim().length < 10 ||
                    //         value.trim().length > 11) {
                    //       return 'Invalid Phone Number!';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (val) {
                    //     phone = val!.trim();
                    //   },
                    //   enableInteractiveSelection: true,
                    //   style: kBlackMediumStyle,
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         horizontal: 15, vertical: 14),
                    //     helperStyle: kRedSmallLightMediumStyle,
                    //     errorStyle: kRedSmallLightMediumStyle,
                    //     hintStyle: kBlackSmallLightMediumStyle,
                    //     hintText: 'Eg: 0123456789',
                    //     labelStyle: kRedSmallLightMediumStyle,
                    //     fillColor: kWhite,
                    //     filled: true,
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       borderSide: const BorderSide(
                    //           color: Colors.black38, width: 0.3),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //       borderSide: const BorderSide(
                    //           color: kTextboxBorderColor, width: 1.4),
                    //     ),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12.0),
                    //     ),
                    //   ),
                    // ),

                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      // validator: (value) {
                      //   _validationMessage = _validatePhoneNumber(value);
                      //   return "";
                      // },
                      validator: (value) {
                        _phoneMessage = _validatePhoneNumber(value);
                        if (_phoneMessage != null) {
                          _shake();
                          return "";
                        } else {
                          return null;
                        }
                      },
                      // validator: (value) {
                      //   if (value!.trim().isEmpty) {
                      //     return 'Phone number is required';
                      //   }
                      //   if (!value.trim().startsWith('01')) {
                      //     return 'Invalid Phone Number!';
                      //   }
                      //   if (value.trim().length < 10 || value.trim().length > 11) {
                      //     return 'Invalid Phone Number!';
                      //   }
                      //   return null;
                      // },
                      // onSaved: (val) {
                      //   phone = val!.trim();
                      // },
                      controller: userProfileController.phoneNoController,
                      enableInteractiveSelection: true,
                      style: kBlackMediumStyle,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        // error: SizedBox(
                        //   height: 0,
                        //   width: 0,
                        // ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        helperStyle: kRedSmallLightMediumStyle,
                        // errorStyle: kRedSmallLightMediumStyle,
                        // errorText: _validationMessage,
                        hintStyle: kBlackSmallLightMediumStyle,
                        hintText: 'Eg: 0123456789',

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
                    if (_phoneMessage != null)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_animation.value - 1, -18),
                            child: child,
                          );
                        },
                        child: Text(_phoneMessage!, style: kRedSmallLightMediumStyle),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Purpose (To receive fund)',
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
                        _purposeMessage = _validatePurpose(value);
                        if (_purposeMessage != null) {
                          _shake();
                        }
                        return null;
                      },
                      // onSaved: (val) {
                      //   purpose = val!.trim();
                      // },
                      controller: userProfileController.purposeController,
                      enableInteractiveSelection: true,
                      style: kBlackMediumStyle,
                      textInputAction: TextInputAction.done,
                      minLines: 10,
                      maxLines: 15,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        helperStyle: kRedSmallLightMediumStyle,
                        errorStyle: kRedSmallLightMediumStyle,
                        hintStyle: kBlackSmallLightMediumStyle,
                        hintText:
                            'Eg: I am reaching out to humbly request a donation for (event). We are working towards (describe the mission or goal of the event) and are in need of financial support to make a meaningful impact.',
                        labelStyle: kRedSmallLightMediumStyle,
                        fillColor: kWhite,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.red, width: 1.4),
                        ),
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
                    if (_purposeMessage != null)
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_animation.value - 1, 1),
                            child: child,
                          );
                        },
                        child: Text(_purposeMessage!, style: kRedSmallLightMediumStyle),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    GradientButton(
                      text: 'Submit',
                      width: true,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await sendFundRequest();
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
