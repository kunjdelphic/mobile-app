import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/models/favorite/recurring.dart';
import 'package:parrotpos/screens/favorite/add_new_recurring_detail_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class AddRecurringItem extends StatefulWidget {
  final RecurringData recurringData;

  const AddRecurringItem({
    Key? key,
    required this.recurringData,
  }) : super(key: key);

  @override
  State<AddRecurringItem> createState() => _AddRecurringItemState();
}

class _AddRecurringItemState extends State<AddRecurringItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
        color: kWhite,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          topLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              '${widget.recurringData.productImage}',
              fit: BoxFit.contain,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/logo/parrot_logo.png',
                fit: BoxFit.contain,
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.recurringData.nickName ?? 'NA',
                    style: kBlackMediumStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    '${widget.recurringData.productName}',
                    style: kBlackExtraSmallMediumStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.recurringData.accountNumber ?? 'NA',
                    style: kBlackExtraSmallMediumStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AddNewRecurringDetailScreen(
                    recurringData: widget.recurringData));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/favorite/add_recurring_btn.png',
                    width: 35,
                    height: 35,
                  ),
                  Text(
                    'Add',
                    style: kBlackDarkMediumStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}
