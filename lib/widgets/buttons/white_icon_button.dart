import 'package:flutter/material.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class WhiteButtonWithIcon extends StatelessWidget {
  const WhiteButtonWithIcon({
    Key? key,
    required this.text,
    required this.width,
    required this.widthSize,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final String text;
  final bool width;
  final double widthSize;
  final icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // return MaterialButton(
    //   onPressed: onTap,
    //   elevation: 4,
    //   height: 45,
    //   color: Colors.blue,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   child: Text(
    //     text,
    //     style: kBlackMediumStyle,
    //   ),
    // );

    return Container(
      height: 45,
      width: width ? widthSize : size.width * 0.85,
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: kWhite,
            splashFactory: NoSplash.splashFactory,
            surfaceTintColor: Colors.transparent,
            disabledForegroundColor: Colors.transparent,
            elevation: 0,
            minimumSize: const Size(0, 45),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Row(
          children: [
            const SizedBox(
              width: 25,
            ),
            icon,
            const SizedBox(
              width: 32,
            ),
            Text(
              text,
              style: kBlackMediumStyle,
            ),
          ],
        ),
      ),
    );
  }
}
