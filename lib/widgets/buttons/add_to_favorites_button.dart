import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:progress_state_button/progress_button.dart';

// class AddToFavoritesButton extends StatelessWidget {
//   const AddToFavoritesButton({
//     Key? key,
//     required this.text,
//     required this.width,
//     required this.onTap,
//     required this.widthSize,
//     required this.buttonState,
//     this.btnColor,
//     this.color,
//     this.borderRadius,
//   }) : super(key: key);

//   final String text;
//   final bool width;
//   final void Function() onTap;
//   final double widthSize;
//   final buttonState;

//   final bool? btnColor;
//   final Color? color;
//   final double? borderRadius;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return buttonState == ButtonState.loading
//         ? Center(
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [
//                     kBlueBtnColor1,
//                     kBlueBtnColor2,
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//                 borderRadius: borderRadius != null
//                     ? BorderRadius.circular(borderRadius!)
//                     : BorderRadius.circular(borderRadius ?? 12),
//               ),
//               alignment: Alignment.center,
//               child: const Center(
//                 child: SizedBox(
//                   height: 25,
//                   child: LoadingIndicator(
//                     indicatorType: Indicator.lineScalePulseOut,
//                     colors: [
//                       kWhite,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : GestureDetector(
//             onTap: onTap,
//             child: Center(
//               child: Container(
//                 height: 45,
//                 width: width ? widthSize : size.width * 0.85,
//                 margin: const EdgeInsets.all(0),
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 3,
//                       spreadRadius: 1,
//                     ),
//                   ],
//                   color: Color(0xffEDEDED),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 alignment: Alignment.center,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/icons/add_to_favorite.png',
//                       width: 25,
//                       height: 25,
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     Text(
//                       text,
//                       style: kBlackMediumStyle,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//   }
// }

//it is temporary placeholder for addtofavorite btn  real widget comment up
class AddToFavoritesButton extends StatelessWidget {
  const AddToFavoritesButton({
    Key? key,
    required this.text,
    required this.width,
    required this.onTap,
    required this.widthSize,
    required this.buttonState,
    this.btnColor,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  final String text;
  final bool width;
  final void Function() onTap;
  final double widthSize;
  final buttonState;

  final bool? btnColor;
  final Color? color;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 20,
      width: width ? widthSize : size.width * 0.85,
    );
  }
}
