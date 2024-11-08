import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../screens/bill_payment/enable_access.dart';
// import '../../screens/bill_payment/enable_contact_access.dart';

Future<File?> cropImage(context, bool isGallery, bool isFront) async {
  var image = await ImagePicker().pickImage(
    source: isGallery ? ImageSource.gallery : ImageSource.camera,
    preferredCameraDevice: isFront ? CameraDevice.front : CameraDevice.rear,
  );
  File? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      compressFormat: ImageCompressFormat.jpg,
      maxHeight: 600,
      maxWidth: 600,
      compressQuality: 80,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop image',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        showCropGrid: false,
        lockAspectRatio: true,
        statusBarColor: Theme.of(context).primaryColor,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
        aspectRatioLockEnabled: true,
      ));

  if (croppedFile != null) {
    print(croppedFile.length());
    return croppedFile;
  } else {
    //not croppped
    return null;
  }
}

Future<File?> cropImageSelfie(context, bool isGallery, bool isFront) async {
  var image = await ImagePicker().pickImage(
    source: isGallery ? ImageSource.gallery : ImageSource.camera,
    preferredCameraDevice: isFront ? CameraDevice.front : CameraDevice.rear,
  );
  File? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      compressFormat: ImageCompressFormat.jpg,
      maxHeight: 600,
      maxWidth: 600,
      compressQuality: 80,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop image',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        showCropGrid: false,
        lockAspectRatio: true,
        statusBarColor: Theme.of(context).primaryColor,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
        aspectRatioLockEnabled: true,
      ));

  if (croppedFile != null) {
    print(croppedFile.length());
    return croppedFile;
  } else {
    //not croppped
    return null;
  }
}

Future<File?> cropImageForID(context, bool isGallery) async {
  var image = await ImagePicker().pickImage(
    source: isGallery ? ImageSource.gallery : ImageSource.camera,
  );
  File? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio3x2,
      ],
      // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      compressFormat: ImageCompressFormat.jpg,
      maxHeight: 600,
      maxWidth: 600,
      compressQuality: 80,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop image',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        showCropGrid: false,
        lockAspectRatio: true,
        statusBarColor: Theme.of(context).primaryColor,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
        aspectRatioLockEnabled: true,
      ));

  if (croppedFile != null) {
    print(croppedFile.length());
    return croppedFile;
  } else {
    //not croppped
    return null;
  }
}

Future addPictureSheet(BuildContext context, bool isForID) async {
  File? res = await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: kDarkWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 7,
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Material(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                topLeft: Radius.circular(50),
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: kWhite.withOpacity(0.7),
              child: Ink(
                height: 45,
                width: Get.width * 0.85,
                // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      kBlueBtnColor1,
                      kBlueBtnColor2,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      // offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                // alignment: Alignment.center,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  autofocus: true,
                  splashColor: Colors.white.withOpacity(0.5),
                  onTap: () async {
                    try {
                      PermissionStatus status = await Permission.camera.request();

                      if (status.isGranted) {
                        if (isForID) {
                          var selectedImage = await cropImageForID(context, false);
                          Get.back(result: selectedImage);
                        } else {
                          var selectedImage = await cropImage(context, false, false);
                          Get.back(result: selectedImage);
                        }
                      } else {
                        Get.back();
                        Get.to(() => EnableAccessScreen(camera: true));
                      }
                    } catch (e) {}
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              kBlueBtnColor1,
                              kBlueBtnColor2,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: kWhite,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Take from Camera',
                        style: kWhiteMediumStyle,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Material(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                topLeft: Radius.circular(50),
                bottomRight: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: kWhite.withOpacity(0.7),
              child: Ink(
                height: 45,
                width: Get.width * 0.85,
                // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: kWhite.withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                // alignment: Alignment.center,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  autofocus: true,
                  splashColor: Colors.white.withOpacity(0.5),
                  onTap: () async {
                    print("image selection ready and $isForID");

                    try {
                      final AndroidDeviceInfo? androidInfo = Platform.isAndroid ? await DeviceInfoPlugin().androidInfo : null;
                      PermissionStatus status = Platform.isAndroid
                          ? (androidInfo?.version.sdkInt ?? 31) >= 33
                              ? await Permission.photos.request()
                              : await Permission.storage.request()
                          : await Permission.photos.request();
                      // var release = androidInfo.version.release;
                      // print("status++++++++++++ ${status}");
                      // print("sc${androidInfo.version.sdkInt}");
                      // print("status++++++++++++ ${status}");

                      if (status.isGranted) {
                        if (isForID) {
                          var selectedImage = await cropImageForID(context, true);
                          Get.back(result: selectedImage);
                        } else {
                          var selectedImage = await cropImage(context, true, false);
                          Get.back(result: selectedImage);
                        }
                      } else {
                        Get.back();
                        Get.to(() => EnableAccessScreen(photo: true));
                      }
                    } catch (e) {
                      print("bhai yeh error hai $e");
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              kWhite,
                              kWhite,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              // spreadRadius: 2,
                              // blurRadius: 5,
                              // offset: const Offset(0, 4),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.image,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Add from Gallery',
                        style: kBlackMediumStyle,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      );
    },
  );

  return res;
}

/// Old code Take Camera & Gallery

// GestureDetector(
//   onTap: () async {
//     if (isForID) {
//       var selectedImage = await cropImageForID(context, false);
//       Get.back(result: selectedImage);
//     } else {
//       var selectedImage = await cropImage(context, false, false);
//       Get.back(result: selectedImage);
//     }
//   },
//   child: Container(
//     width: Get.width * 0.85,
//     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//     decoration: BoxDecoration(
//       gradient: const LinearGradient(
//         colors: [
//           kBlueBtnColor1,
//           kBlueBtnColor2,
//         ],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: const Offset(0, 4),
//         ),
//       ],
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(50),
//         topLeft: Radius.circular(50),
//         bottomRight: Radius.circular(15),
//         topRight: Radius.circular(15),
//       ),
//     ),
//     alignment: Alignment.center,
//     child: Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 kBlueBtnColor1,
//                 kBlueBtnColor2,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.15),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 0),
//               ),
//             ],
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: const Icon(
//             Icons.camera_alt_outlined,
//             color: kWhite,
//             size: 22,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           'Take from Camera',
//           style: kWhiteMediumStyle,
//         ),
//         const Spacer(),
//       ],
//     ),
//   ),
// ),
// const SizedBox(
//   height: 15,
// ),
// GestureDetector(
//   onTap: () async {
//     print("image selection ready and $isForID");
//     try {
//       if (isForID) {
//         var selectedImage = await cropImageForID(context, true);
//         Get.back(result: selectedImage);
//       } else {
//         var selectedImage = await cropImage(context, true, false);
//         Get.back(result: selectedImage);
//       }
//     } catch (e) {
//       print("bhai yeh error hai $e");
//     }
//   },
//   child: Container(
//     // height: 45,
//     width: Get.width * 0.85,
//     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//     decoration: BoxDecoration(
//       color: kWhite,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: const Offset(0, 0),
//         ),
//       ],
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(50),
//         topLeft: Radius.circular(50),
//         bottomRight: Radius.circular(15),
//         topRight: Radius.circular(15),
//       ),
//     ),
//     alignment: Alignment.center,
//     child: Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 kWhite,
//                 kWhite,
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: const Icon(
//             Icons.image,
//             color: Colors.black,
//             size: 22,
//           ),
//         ),
//         const Spacer(),
//         Text(
//           'Add from Gallery',
//           style: kBlackMediumStyle,
//         ),
//         const Spacer(),
//       ],
//     ),
//   ),
// ),
