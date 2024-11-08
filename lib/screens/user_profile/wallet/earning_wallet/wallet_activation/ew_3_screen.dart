import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/buttons/user_profile_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/sheets.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class EW3Screen extends StatefulWidget {
  const EW3Screen({Key? key}) : super(key: key);

  @override
  _EW3ScreenState createState() => _EW3ScreenState();
}

class _EW3ScreenState extends State<EW3Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonState submitBtnState = ButtonState.idle;
  int selectedDoc = -1;
  bool isDocPicking = false;
  bool isAllDocsAdded = false;
  bool isAccepted = false;
  String fullName = '', idNo = '';
  UserProfileController userProfileController = Get.find();
  File? frontImage, backImage;

  uploadId() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        submitBtnState = ButtonState.loading;
      });

      String res = await userProfileController.updateAccountVerStatus({
        'type': 'ID_CARD',
        'cardNo': idNo,
        'name': fullName,
        'frontImage': frontImage,
        'backImage': backImage,
        'cardType': selectedDoc == 0 ? 'ID_CARD' : 'PASSPORT',
      });

      print('DONE :: $res');

      if (res.isEmpty) {
        //updated
        setState(() {
          submitBtnState = ButtonState.idle;
        });

        taskCompletedDialog(
          title: 'Submitted.',
          buttonTitle: 'Next',
          image: 'assets/images/tick.png',
          context: context,
          onTap: () {
            Get.back();
            Get.back(result: true);
          },
          subtitle:
              'Please allow up to three (3) working days for us to verify your details.',
        );
      } else {
        //failed
        setState(() {
          submitBtnState = ButtonState.idle;
        });

        errorSnackbar(title: "Failed", subtitle: '${res}');
      }
    }
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
          "ID Verification",
          style: kBlackLargeStyle,
        ),
      ),
      body: isDocPicking && selectedDoc != -1
          ? selectedDoc == 0
              ? Form(
                  key: _formKey,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    children: [
                      Text(
                        'Full Name as per IC',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          fullName = val!.trim();
                        },
                        onChanged: (value) {
                          fullName = value.trim();
                          if (fullName.isNotEmpty &&
                              idNo.isNotEmpty &&
                              frontImage != null &&
                              backImage != null &&
                              isAccepted) {
                            isAllDocsAdded = true;
                          } else {
                            isAllDocsAdded = false;
                          }
                          setState(() {});
                        },
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 14),
                          helperStyle: kRedSmallLightMediumStyle,
                          errorStyle: kRedSmallLightMediumStyle,
                          hintStyle: kBlackSmallLightMediumStyle,
                          // hintText: 'Full Name',
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
                        height: 15,
                      ),
                      Text(
                        'IC Number',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'IC Number is required';
                          }
                          if (value.trim().length != 12) {
                            return 'IC Number is invalid';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          idNo = val!.trim();
                        },
                        onChanged: (value) {
                          idNo = value.trim();
                          if (fullName.isNotEmpty &&
                              idNo.isNotEmpty &&
                              frontImage != null &&
                              backImage != null &&
                              isAccepted) {
                            isAllDocsAdded = true;
                          } else {
                            isAllDocsAdded = false;
                          }
                          setState(() {});
                        },
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 14),
                          helperStyle: kRedSmallLightMediumStyle,
                          errorStyle: kRedSmallLightMediumStyle,
                          hintStyle: kBlackSmallLightMediumStyle,
                          // hintText: 'IC Number',
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
                        height: 25,
                      ),
                      Text(
                        'Add Your IC Picture (Front)',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [5, 5],
                        color: Colors.grey,
                        strokeWidth: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var res = await addPictureSheet(context, true);
                            if (res != null) {
                              frontImage = res;
                              if (fullName.isNotEmpty &&
                                  idNo.isNotEmpty &&
                                  backImage != null &&
                                  isAccepted) {
                                isAllDocsAdded = true;
                              }
                              setState(() {});
                            }
                          },
                          child: SizedBox(
                            height: 220,
                            // width: double.infinity,
                            child: frontImage != null
                                ? Stack(
                                    children: [
                                      Center(
                                        child: Image.file(
                                          frontImage!,
                                          height: 200,
                                          width: Get.width * 0.8,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAllDocsAdded = false;

                                              frontImage = null;
                                            });
                                          },
                                          child: const CircleAvatar(
                                            radius: 17,
                                            backgroundColor: kColorPrimary,
                                            child: Icon(
                                              Icons.close,
                                              color: kWhite,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Image.asset(
                                      'assets/images/camera.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Add Your IC Picture (Back)',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [5, 5],
                        color: Colors.grey,
                        strokeWidth: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var res = await addPictureSheet(context, true);
                            if (res != null) {
                              backImage = res;
                              if (fullName.isNotEmpty &&
                                  idNo.isNotEmpty &&
                                  frontImage != null &&
                                  isAccepted) {
                                isAllDocsAdded = true;
                              }
                              setState(() {});
                            }
                          },
                          child: SizedBox(
                            height: 220,
                            // width: double.infinity,
                            child: backImage != null
                                ? Stack(
                                    children: [
                                      Center(
                                        child: Image.file(
                                          backImage!,
                                          height: 200,
                                          width: Get.width * 0.8,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAllDocsAdded = false;

                                              backImage = null;
                                            });
                                          },
                                          child: const CircleAvatar(
                                            radius: 17,
                                            backgroundColor: kColorPrimary,
                                            child: Icon(
                                              Icons.close,
                                              color: kWhite,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Image.asset(
                                      'assets/images/camera.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        value: isAccepted,
                        onChanged: (value) {
                          setState(() {
                            isAccepted = value!;

                            if (fullName.isNotEmpty &&
                                idNo.isNotEmpty &&
                                frontImage != null &&
                                backImage != null &&
                                isAccepted) {
                              isAllDocsAdded = true;
                            } else {
                              isAllDocsAdded = false;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          'By clicking submit, I have read and hearby agree to the Terms and Conditions.',
                          style: kBlackSmallMediumStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isAllDocsAdded
                          ? GradientButton(
                              text: 'Complete',
                              width: false,
                              onTap: () {
                                uploadId();
                              },
                              widthSize: Get.width,
                              buttonState: submitBtnState,
                            )
                          : GradientButton(
                              text: 'Submit',
                              width: true,
                              onTap: () {},
                              color: kBlackExtraLightColor,
                              btnColor: true,
                              widthSize: Get.width,
                              buttonState: ButtonState.idle,
                            ),
                    ],
                  ),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    children: [
                      Text(
                        'Full Name as per Passport',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          fullName = val!.trim();
                        },
                        onChanged: (value) {
                          fullName = value.trim();
                          if (fullName.isNotEmpty &&
                              idNo.isNotEmpty &&
                              frontImage != null &&
                              isAccepted) {
                            isAllDocsAdded = true;
                          } else {
                            isAllDocsAdded = false;
                          }
                          setState(() {});
                        },
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 14),
                          helperStyle: kRedSmallLightMediumStyle,
                          errorStyle: kRedSmallLightMediumStyle,
                          hintStyle: kBlackSmallLightMediumStyle,
                          // hintText: 'Full Name',
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
                        height: 15,
                      ),
                      Text(
                        'Passport Number',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Passport Number is required';
                          }
                          // if (value.trim().length != 12) {
                          //   return 'Passport Number is invalid';
                          // }
                          return null;
                        },
                        onSaved: (val) {
                          idNo = val!.trim();
                        },
                        onChanged: (value) {
                          idNo = value.trim();
                          if (fullName.isNotEmpty &&
                              idNo.isNotEmpty &&
                              frontImage != null &&
                              isAccepted) {
                            isAllDocsAdded = true;
                          } else {
                            isAllDocsAdded = false;
                          }
                          setState(() {});
                        },
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 14),
                          helperStyle: kRedSmallLightMediumStyle,
                          errorStyle: kRedSmallLightMediumStyle,
                          hintStyle: kBlackSmallLightMediumStyle,
                          // hintText: 'IC Number',
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
                        height: 25,
                      ),
                      Text(
                        'Add Your Passport Picture (Main)',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(20),
                        dashPattern: const [5, 5],
                        color: Colors.grey,
                        strokeWidth: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var res = await addPictureSheet(context, true);
                            if (res != null) {
                              frontImage = res;
                              if (fullName.isNotEmpty &&
                                  idNo.isNotEmpty &&
                                  isAccepted) {
                                isAllDocsAdded = true;
                              }
                              setState(() {});
                            }
                          },
                          child: SizedBox(
                            height: 220,
                            // width: double.infinity,
                            child: frontImage != null
                                ? Stack(
                                    children: [
                                      Center(
                                        child: Image.file(
                                          frontImage!,
                                          height: 200,
                                          width: Get.width * 0.8,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isAllDocsAdded = false;

                                              frontImage = null;
                                            });
                                          },
                                          child: const CircleAvatar(
                                            radius: 17,
                                            backgroundColor: kColorPrimary,
                                            child: Icon(
                                              Icons.close,
                                              color: kWhite,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Image.asset(
                                      'assets/images/camera.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        value: isAccepted,
                        onChanged: (value) {
                          setState(() {
                            isAccepted = value!;

                            if (fullName.isNotEmpty &&
                                idNo.isNotEmpty &&
                                frontImage != null &&
                                isAccepted) {
                              isAllDocsAdded = true;
                            } else {
                              isAllDocsAdded = false;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          'By clicking submit, I have read and hearby agree to the Terms and Conditions.',
                          style: kBlackSmallMediumStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isAllDocsAdded
                          ? GradientButton(
                              text: 'Complete',
                              width: false,
                              onTap: () {
                                uploadId();
                              },
                              widthSize: Get.width,
                              buttonState: submitBtnState,
                            )
                          : GradientButton(
                              text: 'Submit',
                              width: true,
                              onTap: () {},
                              color: kBlackExtraLightColor,
                              btnColor: true,
                              widthSize: Get.width,
                              buttonState: ButtonState.idle,
                            ),
                    ],
                  ),
                )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              children: [
                Image.asset(
                  'assets/images/wallet/ew_id_veri.png',
                  width: Get.width * 0.4,
                  height: Get.width * 0.4,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Choose A Document to Verify',
                  style: kBlackDarkLargeStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Help us determine if your identity is authentic and belongs to you.',
                  style: kBlackSmallLightMediumStyle,
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDoc = 0;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                      color: kWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Identification Card',
                          style: kBlackMediumStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Spacer(),
                        selectedDoc == 0
                            ? Image.asset(
                                'assets/images/tick.png',
                                width: 25,
                                height: 25,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDoc = 1;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                      color: kWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        Text(
                          'Passport',
                          style: kBlackMediumStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Spacer(),
                        selectedDoc == 1
                            ? Image.asset(
                                'assets/images/tick.png',
                                width: 25,
                                height: 25,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(100)),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                selectedDoc != -1
                    ? GradientButton(
                        text: 'Next',
                        width: true,
                        onTap: () {
                          setState(() {
                            isDocPicking = true;
                          });
                        },
                        widthSize: Get.width,
                        buttonState: ButtonState.idle,
                      )
                    : GradientButton(
                        text: 'Next',
                        width: true,
                        onTap: () {},
                        color: kBlackExtraLightColor,
                        btnColor: true,
                        widthSize: Get.width,
                        buttonState: ButtonState.idle,
                      ),
              ],
            ),
    );
  }
}
