import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../style/colors.dart';

Widget earningHistoryItemShimmer() {
  return Container(
    margin: const EdgeInsets.all(8),
    width: Get.width,
    height: 100,
    padding: const EdgeInsets.all(1),
    decoration: const BoxDecoration(
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.2),
      //     blurRadius: 6,
      //     spreadRadius: 2,
      //   ),
      // ],
      color: kWhite,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(12),
        topLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
          height: 100,
          width: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              topLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          )),
    ),
  );
}
