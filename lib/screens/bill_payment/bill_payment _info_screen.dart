import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/bill_payment/bill_payment_categories.dart';
import '../../style/style.dart';

class BillInfoScreen extends StatefulWidget {
  final BillPaymentCategoriesProducts billPaymentProduct;
  const BillInfoScreen({super.key, required this.billPaymentProduct});

  @override
  State<BillInfoScreen> createState() => _BillInfoScreenState();
}

class _BillInfoScreenState extends State<BillInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Info",
          style: kBlackLargeStyle,
        ),
      ),
      body: Column(
        children: [
          widget.billPaymentProduct.helpText!.isEmpty
              ? Center(
                  child: Text(
                    "Data Not Available",
                    style: kBlackLargeStyle,
                    textAlign: TextAlign.center,
                  ),
                )
              : Text(
                  "${widget.billPaymentProduct.helpText ?? ""}",
                  style: kBlackLargeStyle,
                  textAlign: TextAlign.center,
                ),
        ],
      ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.04, vertical: Get.mediaQuery.size.width * 0.01),
    );
  }
}
