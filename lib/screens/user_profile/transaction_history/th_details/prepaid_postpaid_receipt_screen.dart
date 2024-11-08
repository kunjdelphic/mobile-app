import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../widgets/dialogs/common_dialogs.dart';
import '../../../../widgets/dialogs/snackbars.dart';

class PrepaidPostpaidReceiptScreen extends StatefulWidget {
  final TransactionHistoryData transactionHistoryData;
  const PrepaidPostpaidReceiptScreen({
    Key? key,
    required this.transactionHistoryData,
  }) : super(key: key);

  @override
  _PrepaidPostpaidReceiptDetainState createState() => _PrepaidPostpaidReceiptDetainState();
}

class _PrepaidPostpaidReceiptDetainState extends State<PrepaidPostpaidReceiptScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  RxBool isDownload = false.obs;

  downloadReceipt() async {
    try {
      isDownload.value = true;
      processingDialog(title: 'Download  the Receipt...', context: context, barrierDismissible: true);
      final directory = (await getApplicationDocumentsDirectory()).path; //from path_provide package
      String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
      var path = directory;
      print("+++++++++++${path}");
      print("----------${fileName}");

      String? res = await screenshotController.captureAndSave(
        path,
        fileName: fileName,
      );

      print(res);

      if (res != null) {
        await GallerySaver.saveImage(res).then((val) {
          Get.back();
          processing(title: "Receipt Downloaded to Your Gallery.", context: context);
        });
        // successSnackbar(title: 'Success', subtitle: 'Download the Receipt to Gallery.');
      } else {
        Get.back();
        errorSnackbar(title: 'Failed', subtitle: 'Unable to Download Receipt!');
      }
      // Get.closeCurrentSnackbar();
      // if (!Get.isSnackbarOpen) {
      isDownload.value = false;
      // }

      // Get.back();
    } catch (e) {
      print(e);
      Get.back();
      errorSnackbar(title: 'Failed', subtitle: 'Unable to Download Receipt!');
      isDownload.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/icons/transaction_history/ic_receipt_logo.png',
                        width: Get.width * 0.6,
                        height: 65,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'Here\'s Your Receipt!',
                        textAlign: TextAlign.center,
                        style: kBlackMediumStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Divider(thickness: 0.30),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/transaction_history/ic_receipt.png',
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CommonTools().getModernDateAndTime(widget.transactionHistoryData.timestamp!),
                                style: kBlackExtraSmallLightMediumStyle,
                              ),
                              Text(
                                '${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.amount}',
                                style: kBlackDarkExtraLargeStyle,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Status:',
                                style: kBlackSmallMediumStyle,
                              ),
                              Text(
                                widget.transactionHistoryData.status == 'SUCCESS'
                                    ? 'Successful'
                                    : widget.transactionHistoryData.status == 'PENDING'
                                        ? 'Processing'
                                        : 'Failed',
                                style: widget.transactionHistoryData.status == 'SUCCESS'
                                    ? kPrimaryDarkMediumStyle
                                    : widget.transactionHistoryData.status == 'PENDING'
                                        ? kPrimary2DarkMediumStyle
                                        : kRedDarkMediumStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product:',
                            style: kBlackSmallLightMediumStyle,
                          ),
                          Text(
                            '${widget.transactionHistoryData.others!.productName}',
                            style: kBlackDarkMediumStyle,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            widget.transactionHistoryData.transType == "BILL_PAYMENT" ? 'Account Number:' : "Phone Number",
                            style: kBlackSmallLightMediumStyle,
                          ),
                          Text(
                            widget.transactionHistoryData.others!.accountNumber.isEmpty ? 'N/A' : widget.transactionHistoryData.others!.accountNumber,
                            style: kBlackDarkMediumStyle,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Transaction ID:',
                            style: kBlackSmallLightMediumStyle,
                          ),
                          Text(
                            '${widget.transactionHistoryData.transactionId}',
                            style: kBlackDarkMediumStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Note: This receipt is computer generated and no signature is required.',
                        style: kBlackExtraSmallLightMediumStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Download',
                    width: false,
                    onTap: () {
                      if (!isDownload.value) {
                        downloadReceipt();
                      }
                    },
                    widthSize: Get.width * 0.9,
                    buttonState: ButtonState.idle,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: GradientButton(
                    text: 'Share',
                    width: false,
                    onTap: () async {
                      final directory = (await getApplicationDocumentsDirectory()).path; //from path_provide package
                      String fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
                      var path = directory;
                      print("+++++++++++${path}");
                      print("----------${fileName}");
                      String? res = await screenshotController.captureAndSave(
                        path,
                        fileName: fileName,
                      );
                      Share.shareFiles(["${res}"]);
                    },
                    widthSize: Get.width * 0.9,
                    buttonState: ButtonState.idle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class PrepaidPostpaidReceiptScreen extends StatefulWidget {
//   // final TransactionHistoryData transactionHistoryData;
//   const PrepaidPostpaidReceiptScreen({
//     Key? key,
//     // required this.transactionHistoryData,
//   }) : super(key: key);
//
//   @override
//   _PrepaidPostpaidReceiptDetainState createState() =>
//       _PrepaidPostpaidReceiptDetainState();
// }
//
// class _PrepaidPostpaidReceiptDetainState
//     extends State<PrepaidPostpaidReceiptScreen> {
//   ScreenshotController screenshotController = ScreenshotController();
//
//   downloadReceipt() async {
//     try {
//       processingDialog(title: 'Download  the Receipt...', context: context);
//       final directory = (await getApplicationDocumentsDirectory())
//           .path; //from path_provide package
//       String fileName =
//           DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
//       var path = directory;
//       print("+++++++++++${path}");
//       print("----------${fileName}");
//
//       String? res = await screenshotController.captureAndSave(
//         path,
//         fileName: fileName,
//       );
//
//       print("++-+-+-+-+- ${res}");
//
//       if (res != null) {
//         await GallerySaver.saveImage(res);
//         Get.back();
//         successSnackbar(
//             title: 'Success', subtitle: 'Download the Receipt to Gallery.');
//       } else {
//         Get.back();
//         errorSnackbar(title: 'Failed', subtitle: 'Unable to Download Receipt!');
//       }
//     } catch (e) {
//       print(e);
//       Get.back();
//       errorSnackbar(title: 'Failed', subtitle: 'Unable to Download Receipt!');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: const BackButton(),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [
//           Screenshot(
//             controller: screenshotController,
//             child: Container(
//               color: Colors.white,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                 children: [
//                   Center(
//                     child: Image.asset(
//                       'assets/icons/transaction_history/ic_receipt_logo.png',
//                       width: Get.width * 0.6,
//                       height: 65,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Center(
//                     child: Text(
//                       'Here\'s Your Receipt!',
//                       textAlign: TextAlign.center,
//                       style: kBlackMediumStyle,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   const Divider(thickness: 0.30),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           'assets/icons/transaction_history/ic_receipt.png',
//                           height: 40,
//                           fit: BoxFit.contain,
//                         ),
//                         const SizedBox(
//                           width: 15,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Romil",
//                               // CommonTools().getModernDateAndTime(
//                               //     widget.transactionHistoryData.timestamp!),
//                               style: kBlackExtraSmallLightMediumStyle,
//                             ),
//                             Text(
//                               "2",
//                               // '${widget.transactionHistoryData.currency} ${widget.transactionHistoryData.amount}',
//                               style: kBlackDarkExtraLargeStyle,
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               'Status:',
//                               style: kBlackSmallMediumStyle,
//                             ),
//                             // Text(
//                             //   widget.transactionHistoryData.status == 'SUCCESS'
//                             //       ? 'Successful'
//                             //       : widget.transactionHistoryData.status == 'PENDING'
//                             //           ? 'Processing'
//                             //           : 'Failed',
//                             //   style: widget.transactionHistoryData.status == 'SUCCESS'
//                             //       ? kPrimaryDarkMediumStyle
//                             //       : widget.transactionHistoryData.status == 'PENDING'
//                             //           ? kPrimary2DarkMediumStyle
//                             //           : kRedDarkMediumStyle,
//                             // ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Product:',
//                           style: kBlackSmallLightMediumStyle,
//                         ),
//                         Text(
//                           "Water",
//                           // '${widget.transactionHistoryData.others!.productName}',
//                           style: kBlackDarkMediumStyle,
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         Text(
//                           'Phone Number:',
//                           style: kBlackSmallLightMediumStyle,
//                         ),
//                         Text(
//                           "0123456789",
//                           // widget.transactionHistoryData.others!.phoneNumber.isEmpty
//                           //     ? 'N/A'
//                           //     : widget.transactionHistoryData.others!.phoneNumber,
//                           style: kBlackDarkMediumStyle,
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         Text(
//                           'Transaction ID:',
//                           style: kBlackSmallLightMediumStyle,
//                         ),
//                         Text(
//                           "123456",
//                           // '${widget.transactionHistoryData.transactionId}',
//                           style: kBlackDarkMediumStyle,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 25,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       'Note: This receipt is computer generated and no signature is required.',
//                       style: kBlackExtraSmallLightMediumStyle,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 35,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GradientButton(
//                     text: 'Download',
//                     width: false,
//                     onTap: () {
//                       downloadReceipt();
//                       // Get.back();
//                     },
//                     widthSize: Get.width * 0.9,
//                     buttonState: ButtonState.idle,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 15,
//                 ),
//                 Expanded(
//                   child: GradientButton(
//                     text: 'Share',
//                     width: false,
//                     onTap: () async {
//                       // final directory =
//                       //     await getApplicationDocumentsDirectory(); //from path_provide package
//                       // String fileName =
//                       //     DateTime.now().microsecondsSinceEpoch.toString() +
//                       //         '.jpg';
//                       // final imageFile = File('${directory.path}/${fileName}');
//                       //
//                       // Share.share("${imageFile}");
//                       // print("/////////////// ${imageFile.path}");
//
//                       final directory =
//                           (await getApplicationDocumentsDirectory())
//                               .path; //from path_provide package
//                       String fileName =
//                           DateTime.now().microsecondsSinceEpoch.toString() +
//                               '.jpg';
//                       var path = directory;
//                       print("+++++++++++${path}");
//                       print("----------${fileName}");
//                       String? res = await screenshotController.captureAndSave(
//                         path,
//                         fileName: fileName,
//                       );
//
//                       Share.shareFiles(["${res}"]);
//
//                       // Share.share("${path} ${fileName}");
//                     },
//                     widthSize: Get.width * 0.9,
//                     buttonState: ButtonState.idle,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
