import 'package:flutter/material.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class WhiteButton extends StatelessWidget {
  const WhiteButton({
    Key? key,
    required this.text,
    required this.width,
    required this.widthSize,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final bool width;
  final double widthSize;
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

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.blueAccent,
      highlightColor: Colors.blue.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        height: 45,
        width: width ? widthSize : size.width * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
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
        child: Text(
          text,
          style: kBlackMediumStyle,
        ),
      ),
    );
  }
}
