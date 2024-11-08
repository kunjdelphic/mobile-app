import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/top_up_controller.dart';
import 'package:parrotpos/models/topup/recent_top_up.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';

class RecentTopUpItem extends StatelessWidget {
  final RecentTopUpData recentTopUpData;
  final onDelete;
  const RecentTopUpItem({
    Key? key,
    required this.recentTopUpData,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: Get.width * 0.18,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
                color: kWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/ic_remove.png',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Remove',
                    style: kRedExtraSmallMediumStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: Get.width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
          color: kWhite,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            topLeft: Radius.circular(50),
            bottomRight: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
                color: kWhite,
                borderRadius: BorderRadius.circular(100),
              ),
              child: CircleAvatar(
                backgroundColor: kWhite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    '${recentTopUpData.others!.productLogo}',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/logo/parrot_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${recentTopUpData.others!.productName}',
                    style: kBlackMediumStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    recentTopUpData.others!.accountNumber ?? 'NA',
                    style: kBlackExtraSmallLightMediumStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${recentTopUpData.currency} ${recentTopUpData.amount}',
                  style: kBlackDarkMediumStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  CommonTools().getDateAndTime(recentTopUpData.timestamp!),
                  style: kBlackExtraSmallLightMediumStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.more_vert,
              color: Colors.black26,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
