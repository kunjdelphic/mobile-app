import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class UserProfileButton extends StatelessWidget {
  final String title;
  final Icon icon;
  final bool isSuffix;
  final String suffix;
  final Function() onTap;

  const UserProfileButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSuffix,
    required this.suffix,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
                color: Color(0xffF6F6F6),
                // color: kWhite,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            const Spacer(),
            isSuffix
                ? Row(
                    children: [
                      Text(
                        suffix,
                        style: suffix == 'Not Verified'
                            ? kRedMediumStyle
                            : kBlackLightMediumStyle,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  )
                : const SizedBox(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black45,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
