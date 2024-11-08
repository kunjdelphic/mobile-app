import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:parrotpos/models/user_profile/privacy_policy.dart';
import 'package:parrotpos/models/user_profile/terms_and_conditions.dart';
import 'package:parrotpos/models/user_profile/user_profile.dart';
import 'package:parrotpos/screens/login/main_login_screen.dart';

import 'package:parrotpos/services/remote_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/bill_payment/enable_access.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../widgets/buttons/gradient_button.dart';
import '../widgets/dialogs/common_dialogs.dart';
import '../widgets/dialogs/snackbars.dart';

class UserProfileController extends GetxController {
  final userProfile = UserProfile().obs;
  final versionData = versionModel().obs;
  ButtonState btnState = ButtonState.idle;
  final isFetching = false.obs;
  final phonetext = ''.obs;
  final isPhone = false.obs;
  RxBool isFirstLogin = false.obs;
  RxBool isPhoneNumberValid = false.obs;
  final String currentVersionOfApp = "1.3.12";
  // final String currentVersion = "Dev 1.3.11 (3.2) ParrotPos";
  final String currentVersion = "1.3.13 (3) DEV-Parrot Pos";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController issueController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  void setPhonetext(value) {
    phonetext.value = value;
    isPhoneNumberValid.value = false;
  }

  void setIsPhoneNumberValid(value) {
    isPhoneNumberValid.value = value;
    update();
  }

  void deleteAccount() async {
    var res = await RemoteService.deleteAccount();
  }

  getUserDetails() async {
    isFetching(true);

    var res = await RemoteService.getUserDetails();

    if (res.status == 200) {
      userProfile.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });

      if (userProfile.value.data?.name == null || userProfile.value.data?.name == "") {
        // print("object is not");
        isFirstLogin = true.obs;
        Get.dialog(
          customDialog(),
          barrierDismissible: false,
        );
      }
      isFetching(false);
    } else {
      if (res.status == 401 || res.status == 403) {
        await GetStorage().write('accessId', null);
        RemoteService.accessId = '';
        Get.offAll(() => const MainLoginScreen());
      } else {
        userProfile.update((val) {
          val!.data = null;
          val.message = res.message;
          val.status = res.status;
        });
      }
      isFetching(false);
    }
    // print(userProfile.value.data!.profileImage.toString());
  }

  versionMatch(context) async {
    final res = await RemoteService.matchVersion();
    print("AAAAAAAAAAAAAAAAA ${res}");
    versionData.value = versionModel.fromJson(res ?? {});
    print("BBBBBBBBBBB ${versionData.value.data}");
    final newVersion = versionData.value.data;
    if (newVersion != null && isNewVersionAvailable(currentVersionOfApp, newVersion)) {
      showUpDateDialog(
        context: context,
        onTap: () async {
          if (Platform.isAndroid) {
            const url = "https://play.google.com/store/apps/details?id=com.parrotpos.parrotpos2&hl=en_IN&pli=1";
            if (await canLaunch(url)) {
              launch(url);
            } else {
              throw 'Could not launch $url';
            }
            print("Android");
          } else if (Platform.isIOS) {
            const url = "https://apps.apple.com/my/app/parrotpos/id1548119283";
            if (await canLaunch(url)) {
              launch(url);
            } else {
              throw 'Could not launch $url';
            }
            print("Apple");
          }
        },
      );
    }
  }

  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  RxList<Contact> contacts = <Contact>[].obs;

  Future<void> checkContactPermission(BuildContext context) async {
    PermissionStatus status = await Permission.contacts.request();

    if (status.isGranted) {
      await _pickContact();
    } else /* (status.isDenied || status.isPermanentlyDenied)*/ {
      Get.to(() => EnableAccessScreen())?.then((value) {
        // checkContactPermission(context);
      });

      // contactPermissionDialog(context: context);
      // _showPermissionDialog(context);
    }
  }

  Future<void> _pickContact() async {
    try {
      Contact? contact = await _contactPicker.selectContact();
      contacts?.value = contact == null ? [] : [contact];
    } catch (e) {
      errorSnackbar(title: 'Failed', subtitle: 'Failed to pick contact');
    }
  }

  bool isNewVersionAvailable(String currentVersion, String newVersion) {
    // Convert version strings to lists of integers
    List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
    List<int> newParts = newVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < currentParts.length; i++) {
      print("-----currentParts ${currentParts}");
      print("-----newParts ${newParts}");
      if (newParts.length <= i || newParts[i] > currentParts[i]) {
        return true; // new version is greater
      } else if (newParts[i] < currentParts[i]) {
        return false; // current version is greater or same
      }
    }

    // If all parts are the same length and identical, return false
    return newParts.length > currentParts.length;
  }

  Future<String> updateNameandPhone(Map map) async {
    btnState = ButtonState.loading;
    update();
    var res = await RemoteService.updateNamePhone(map);
    print(res);
    btnState = ButtonState.idle;
    update();
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  updateUserDetails() async {
    isFetching(true);

    var res = await RemoteService.getUserDetails();

    log('UPDATED PROFILE');
    // print(res.data!.profileImage);

    if (res.status == 200) {
      userProfile.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });
      update();
    }

    isFetching(false);
  }

  Future<String> updateAccountVerStatus(Map map) async {
    var res = await RemoteService.updateAccountVerStatus(map);
    if (res["status"] == 200) {
      return "";
    } else {
      // print(res['message']);

      return res['message'];
    }
  }

  Future<String?> sendUserReport(Map map) async {
    var res = await RemoteService.sendUserReport(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> fundRequest(Map map) async {
    var res = await RemoteService.requestDonation(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> sendUserFeedback(Map map) async {
    var res = await RemoteService.sendUserFeedback(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String> uploadProfileImage(Map map) async {
    var res = await RemoteService.uploadProfileImage(map);
    //  print(res);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<TermsAndConditions> getTermsAndConditions(String type) async {
    var res = await RemoteService.getTermsAndConditions(type);
    return res;
  }

  Future<ReferralTermsAndConditions> getReferralTermsAndConditions(String type) async {
    var res = await RemoteService.getReferralTermsAndConditions(type);
    return res;
  }

  Future<PrivacyPolicy> getPrivacyPolicy(String type) async {
    var res = await RemoteService.getPrivacyPolicy(type);
    return res;
  }
}

Widget customDialog() {
  final key = GlobalKey<FormState>();
  final nameCntroller = TextEditingController();
  final phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var isPhoneIos = false;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
          insetPadding: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: isPhoneIos
              ? Form(
                  key: key,
                  child: Container(
                    width: Get.width,
                    height: 420,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Do you wish to update your name as per your Government Identity.",
                          style: kBlackSmallLightMediumStyle,
                        ),
                        Text(
                          "Name",
                          style: kBlackDarkLargeStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: nameCntroller,
                          textAlignVertical: TextAlignVertical.center,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Name is required';
                            }

                            return null;
                          },
                          onSaved: (val) {
                            // phoneNo = val!.trim();
                            // phoneNo = '${Config().countryCode}$phoneNo';
                          },
                          // textAlign: TextAlign.center,
                          // initialValue: "",
                          enableInteractiveSelection: true,
                          style: kBlackMediumStyle,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,

                          // keyboardType: TextInputType.number,
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
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Note:",
                          style: kBlackExtraSmallDarkMediumStyle,
                        ),
                        Text(
                          "These details will make it easier for you to recover a forgotten password and to send or receive money.",
                          style: kBlackSmallLightMediumStyle,
                        ),
                        SizedBox(
                          height: 26,
                        ),
                        GetBuilder<UserProfileController>(
                          init: UserProfileController(),
                          initState: (_) {},
                          builder: (_) {
                            return GradientButton(
                              text: 'Save',
                              onTap: () async {
                                if (key.currentState!.validate()) {
                                  print("validate");
                                  var res = await _.updateNameandPhone({"name": nameCntroller.text, "phone_number": phoneController.text, "country_code": "6"});

                                  if (res.isEmpty) {
                                    Get.back();
                                    _.updateUserDetails();
                                  } else {
                                    Get.snackbar("Error", res, backgroundColor: Colors.red, colorText: kWhite);
                                  }
                                }
                              },
                              width: true,
                              widthSize: Get.width,
                              buttonState: _.btnState,
                            );
                          },
                        )
                      ]),
                    ),
                  ),
                )
              : Form(
                  key: key,
                  child: Container(
                    width: Get.width,
                    height: 420,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Platform.isIOS
                            ? Container()
                            : Text(
                                "Name",
                                style: kBlackDarkLargeStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                        SizedBox(
                          height: Platform.isIOS ? 0 : 10,
                        ),
                        Platform.isIOS
                            ? Container()
                            : TextFormField(
                                controller: nameCntroller,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Name is required';
                                  }

                                  return null;
                                },
                                onSaved: (val) {
                                  // phoneNo = val!.trim();
                                  // phoneNo = '${Config().countryCode}$phoneNo';
                                },
                                // textAlign: TextAlign.center,
                                // initialValue: "",
                                enableInteractiveSelection: true,
                                style: kBlackMediumStyle,
                                textInputAction: TextInputAction.done,

                                keyboardType: TextInputType.name,
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
                        SizedBox(
                          height: Platform.isIOS ? 10 : 30,
                        ),
                        Text(
                          "Phone Number",
                          style: kBlackDarkLargeStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: phoneController,
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
                            // phoneNo = val!.trim();
                            // phoneNo = '${Config().countryCode}$phoneNo';
                          },
                          // textAlign: TextAlign.center,
                          // initialValue: "",
                          enableInteractiveSelection: true,
                          style: kBlackMediumStyle,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                            helperStyle: kRedSmallLightMediumStyle,
                            errorStyle: kRedSmallLightMediumStyle,
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
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Note:",
                          style: kBlackExtraSmallDarkMediumStyle,
                        ),
                        Text(
                          "These details will make it easier for you to recover a forgotten password and to send or receive money.",
                          style: kBlackSmallLightMediumStyle,
                        ),
                        SizedBox(
                          height: 26,
                        ),
                        GetBuilder<UserProfileController>(
                          init: UserProfileController(),
                          initState: (_) {},
                          builder: (_) {
                            return GradientButton(
                              text: Platform.isIOS ? 'Next' : 'Save',
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                if (Platform.isIOS) {
                                  setState(() {
                                    isPhoneIos = !isPhoneIos;
                                  });
                                  var name = GetStorage().read("name");
                                  // print("The name is: " + name);
                                  nameCntroller.text = name;
                                } else {
                                  if (key.currentState!.validate()) {
                                    print("validate");
                                    var res = await _.updateNameandPhone({"name": nameCntroller.text, "phone_number": phoneController.text, "country_code": "6"});

                                    if (res.isEmpty) {
                                      Get.back();
                                      _.updateUserDetails();
                                    } else {
                                      Get.snackbar("Error", res, backgroundColor: Colors.red, colorText: kWhite);
                                    }
                                  }
                                }
                              },
                              width: true,
                              widthSize: Get.width,
                              buttonState: _.btnState,
                            );
                          },
                        )
                      ]),
                    ),
                  ),
                )),
    );
  });
}

// Widget customDialogIOS() {
//   final key = GlobalKey<FormState>();
//   final nameCntroller = TextEditingController();
//   final phoneController = TextEditingController();
//   return WillPopScope(
//     onWillPop: () async => false,
//     child: Dialog(
//         insetPadding: const EdgeInsets.all(14),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//         child: Form(
//           key: key,
//           child: Container(
//             width: Get.width,
//             height: 420,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 22),
//               child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(
//                   "Phone Number",
//                   style: kBlackDarkLargeStyle.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   controller: phoneController,
//                   textAlignVertical: TextAlignVertical.center,
//                   validator: (value) {
//                     if (value!.trim().isEmpty) {
//                       return 'Phone number is required';
//                     }
//                     if (!value.trim().startsWith('01')) {
//                       return 'Phone number is invalid';
//                     }
//                     if (value.trim().length < 10 || value.trim().length > 11) {
//                       return 'Phone number is invalid';
//                     }
//                     return null;
//                   },
//                   onSaved: (val) {
//                     // phoneNo = val!.trim();
//                     // phoneNo = '${Config().countryCode}$phoneNo';
//                   },
//                   // textAlign: TextAlign.center,
//                   // initialValue: "",
//                   enableInteractiveSelection: true,
//                   style: kBlackMediumStyle,
//                   textInputAction: TextInputAction.done,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
//                     helperStyle: kRedSmallLightMediumStyle,
//                     errorStyle: kRedSmallLightMediumStyle,
//                     hintStyle: kBlackSmallLightMediumStyle,
//                     hintText: 'Eg: 0123456789',
//                     labelStyle: kRedSmallLightMediumStyle,
//                     fillColor: kWhite,
//                     filled: true,
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: const BorderSide(color: Colors.black38, width: 0.3),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: const BorderSide(color: kTextboxBorderColor, width: 1.4),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Text(
//                   "Note:",
//                   style: kBlackExtraSmallDarkMediumStyle,
//                 ),
//                 Text(
//                   "These details will make it easier for you to recover a forgotten password and to send or receive money.",
//                   style: kBlackSmallLightMediumStyle,
//                 ),
//                 SizedBox(
//                   height: 26,
//                 ),
//                 GetBuilder<UserProfileController>(
//                   init: UserProfileController(),
//                   initState: (_) {},
//                   builder: (_) {
//                     return GradientButton(
//                       text: 'Save',
//                       onTap: () async {
//                         if (key.currentState!.validate()) {
//                           print("validate");
//                           var res = await _.updateNameandPhone({"name": nameCntroller.text, "phone_number": phoneController.text, "country_code": "6"});
//
//                           if (res.isEmpty) {
//                             Get.back();
//                             _.updateUserDetails();
//                           } else {
//                             Get.snackbar("Error", res, backgroundColor: Colors.red, colorText: kWhite);
//                           }
//                         }
//                       },
//                       width: true,
//                       widthSize: Get.width,
//                       buttonState: _.btnState,
//                     );
//                   },
//                 )
//               ]),
//             ),
//           ),
//         )),
//   );
// }
