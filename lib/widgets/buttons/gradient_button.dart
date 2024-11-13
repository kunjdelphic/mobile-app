import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:progress_state_button/progress_button.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
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

    return buttonState == ButtonState.loading
        ? Center(
            child: Container(
              height: 45,
              width: width ? widthSize : size.width * 0.85,
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
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: borderRadius != null
                    ? BorderRadius.circular(borderRadius!)
                    : BorderRadius.circular(borderRadius ?? 12),
              ),
              alignment: Alignment.center,
              child: const Center(
                child: SizedBox(
                  height: 20,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                    colors: [
                      kWhite,
                    ],
                  ),
                ),
              ),
            ),
          )
        :
        // GestureDetector(
        //         onTap: onTap,
        //         child: Center(
        //           child: Container(
        //             height: 45,
        //             width: width ? widthSize : size.width * 0.85,
        //             margin: const EdgeInsets.all(0),
        //             padding: const EdgeInsets.symmetric(horizontal: 10),
        //             decoration: BoxDecoration(
        //               gradient: btnColor != null
        //                   ? color != null
        //                       ? LinearGradient(
        //                           colors: [
        //                             color!,
        //                             color!,
        //                           ],
        //                           begin: Alignment.topCenter,
        //                           end: Alignment.bottomCenter,
        //                         )
        //                       : const LinearGradient(
        //                           colors: [
        //                             kColorPrimaryLight,
        //                             kColorPrimary,
        //                           ],
        //                           begin: Alignment.topCenter,
        //                           end: Alignment.bottomCenter,
        //                         )
        //                   : const LinearGradient(
        //                       colors: [
        //                         kBlueBtnColor1,
        //                         kBlueBtnColor2,
        //                       ],
        //                       begin: Alignment.topCenter,
        //                       end: Alignment.bottomCenter,
        //                     ),
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.black.withOpacity(0.1),
        //                   spreadRadius: 2,
        //                   blurRadius: 5,
        //                   offset: const Offset(0, 4),
        //                 ),
        //               ],
        //               borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : BorderRadius.circular(12),
        //             ),
        //             alignment: Alignment.center,
        //             child: Text(
        //               text,
        //               style: kWhiteMediumStyle,
        //             ),
        //           ),
        //         ),
        //       );

        Material(
            borderRadius: BorderRadius.circular(12),
            color: kWhite.withOpacity(0.7),
            child: Ink(
              height: 45,
              width: width ? widthSize : size.width * 0.85,
              // margin: const EdgeInsets.all(0),
              // padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                gradient: btnColor != null
                    ? color != null
                        ? LinearGradient(
                            colors: [
                              color!,
                              color!,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : const LinearGradient(
                            colors: [
                              kColorPrimaryLight,
                              kColorPrimary,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                    : const LinearGradient(
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
                    // spreadRadius: 2,
                    // blurRadius: 5,
                    // offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: borderRadius != null
                    ? BorderRadius.circular(borderRadius!)
                    : BorderRadius.circular(12),
              ),
              // alignment: Alignment.center,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Future.delayed(
                    Duration(milliseconds: 100),
                    () {
                      // if (onTap != null) {
                      onTap!();
                    },
                  );
                },
                autofocus: true,
                splashColor: Colors.white.withOpacity(0.5),
                child: Center(
                  child: Text(
                    text,
                    style: kWhiteMediumStyle,
                  ),
                ),
              ),
            ),
          );
  }
}

class GradientBtn extends StatelessWidget {
  final Color? color;
  final double? borderRadius;
  final double widthSize;
  final bool width;
  final String text;
  final void Function() onTap;
  const GradientBtn(
      {super.key,
      this.borderRadius,
      this.color,
      required this.widthSize,
      required this.width,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: kWhite.withOpacity(0.7),
      child: Ink(
        height: 45,
        width: width ? widthSize : size.width * 0.85,
        // margin: const EdgeInsets.all(0),
        // padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              kSkyBtnColor1,
              kSkyBtnColor2,
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
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : BorderRadius.circular(12),
        ),
        // alignment: Alignment.center,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          autofocus: true,
          splashColor: Colors.white.withOpacity(0.5),
          child: Center(
            child: Text(
              text,
              style: kWhiteLargeInterStyle,
            ),
          ),
        ),
      ),
    );
  }
}

// class CommonFavoriteBtn extends StatelessWidget {
//   // final String? icon;
//   final String? image;
//   final String title;
//   final Color? color;
//   final double? height;
//   final double? width;
//   final BoxFit fit;
//   final void Function()? onTap;
//   const CommonFavoriteBtn({
//     super.key,
//     this.color,
//     required this.title,
//     this.height,
//     this.width,
//     this.onTap,
//     this.fit = BoxFit.contain,
//     this.image,
//     // this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Ink(
//         height: 106,
//         width: 110,
//         // alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: kWhiteF5.withOpacity(0.6), //Colors.white10,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: Colors.black12,
//             width: 1,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // SvgPicture.asset(
//             //   icon ?? "",
//             //   width: width,
//             //   height: height,
//             //   fit: fit,
//             //   color: color,
//             // ),
//             Image.asset(
//               image ?? "",
//               height: height,
//               width: width,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: kBlackSmallStyle,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
class CommonFavoriteBtn extends StatelessWidget {
  // final String? icon;

  final String? image;
  final String title;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Function? onTap;
  const CommonFavoriteBtn({
    super.key,
    this.color,
    required this.title,
    this.height,
    this.width,
    this.onTap,
    this.fit = BoxFit.contain,
    this.image,
    // this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: kWhiteF5.withOpacity(0.6),
      child: Ink(
        height: Get.mediaQuery.size.height * 0.13,
        width: Get.mediaQuery.size.width * 0.28 ?? 110,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: kWhiteF5.withOpacity(0.6), //Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black12,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () {
            Future.delayed(
              Duration(milliseconds: 100),
              () {
                // if (onTap != null) {
                onTap!();
              },
            );
          },
          autofocus: true,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.grey.withOpacity(0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   icon ?? "",
              //   width: width,
              //   height: height,
              //   fit: fit,
              //   color: color,
              // ),
              Image.asset(
                image ?? "",
                height: height,
                width: width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: kBlackSmallStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommonBorderBtn extends StatelessWidget {
  final void Function()? onTap;
  final String? title;
  final Border? border;
  final double? width;
  final TextStyle? style;

  const CommonBorderBtn(
      {super.key, this.onTap, this.title, this.border, this.width, this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border,
        //Border.all(color: kColorPrimary),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.2),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        // gradient: LinearGradient(colors: [
        //   Color(0xFF8BC53F),
        // Color(0xff79B32B),
        // ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(12),
      ),
      height: 45,
      width: width ?? 150,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            // height: 45,
            // width: 150,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              // boxShadow: [
              //   // BoxShadow(
              //   //   color: const Color(0xFF000000).withOpacity(0.5),
              //   // ),
              //   BoxShadow(
              //     color: const Color(0xFF000000).withOpacity(0.23),
              //     blurStyle: BlurStyle.outer,
              //     blurRadius: 1,
              //     offset:const Offset(0.0,0.1)
              //     // spreadRadius: 12
              //   ),
              // ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Center(
                child: Text(
                  title ?? "",
                  style: style,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteBluBtn extends StatelessWidget {
  final double width;
  // final double? width;
  final double widthSize;
  final void Function()? onTap;
  final double? borderRadius;
  final String? text;
  final TextStyle? style;
  const WhiteBluBtn({
    super.key,
    required this.width,
    // this.width,
    this.onTap,
    required this.widthSize,
    this.borderRadius,
    this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: kWhite.withOpacity(0.7),
      child: Ink(
        height: 45,
        width: width, //? widthSize : size.width * 0.85,
        // margin: const EdgeInsets.all(0),
        // padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff0E76BC),
              Color(0xff283891),
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
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius!)
              : BorderRadius.circular(12),
        ),
        // alignment: Alignment.center,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Future.delayed(
              Duration(milliseconds: 100),
              () {
                // if (onTap != null) {
                onTap!();
              },
            );
          },
          // onTap,
          autofocus: true,
          splashColor: Colors.white.withOpacity(0.5),
          child: Center(
            child: Text(text ?? "",
                // style: kWhiteMediumStyle,
                style: style ??
                    kPrimaryExtraDarkSuperLargeStyle.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    )),
          ),
        ),
      ),
    );
  }
}
