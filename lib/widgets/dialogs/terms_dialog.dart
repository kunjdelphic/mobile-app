// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:parrotpos/style/colors.dart';
// import 'package:parrotpos/style/style.dart';
// import 'package:parrotpos/widgets/buttons/gradient_button.dart';
// import 'package:progress_state_button/progress_button.dart';

// class TermsDialog extends StatefulWidget {
//   const TermsDialog({Key? key}) : super(key: key);

//   @override
//   _TermsDialogState createState() => _TermsDialogState();
// }

// class _TermsDialogState extends State<TermsDialog> {
//   bool isAccepted = true;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Dialog(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(15.0),
//         ),
//       ),
//       // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//       elevation: 5.0,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 'Terms and Conditions',
//                 style: kBlackDarkLargeStyle,
//               ),
//               const SizedBox(
//                 height: 15.0,
//               ),
//               Container(
//                 child: Text(
//                   'What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Why do we use it?It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Why do we use it?It is a long established',
//                   style: kBlackSmallMediumStyle,
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               CheckboxListTile(
//                 dense: true,
//                 contentPadding: const EdgeInsets.all(0),
//                 value: isAccepted,
//                 onChanged: (value) {
//                   setState(() {
//                     isAccepted = value!;
//                   });
//                 },
//                 controlAffinity: ListTileControlAffinity.leading,
//                 title: Text(
//                   'By creating an account, you agree to our Term and Conditions',
//                   style: kBlackSmallMediumStyle,
//                 ),
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               GradientButton(
//                 text: 'Agree',
//                 width: false,
//                 widthSize: 0,
//                 onTap: () {
//                   if (isAccepted) {
//                     Get.back(result: 'DONE');
//                   }
//                 },
//                 buttonState: ButtonState.idle,
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
