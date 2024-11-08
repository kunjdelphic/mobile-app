import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/models/wallet/send_money_recent_list.dart';

import '../../../../style/colors.dart';
import '../../../../style/style.dart';

class AllRecentlySentScreen extends StatefulWidget {
  final List<SendMoneyRecentListData>? recentlySent;

  const AllRecentlySentScreen({
    Key? key,
    required this.recentlySent,
  }) : super(key: key);

  @override
  State<AllRecentlySentScreen> createState() => _AllRecentlySentScreenState();
}

class _AllRecentlySentScreenState extends State<AllRecentlySentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Send Money",
          style: kBlackLargeStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(
            'Recently sent money',
            style: kBlackMediumStyle,
          ),
          const SizedBox(
            height: 30,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.back(result: widget.recentlySent![index]);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                          color: kWhite,
                          // color: kWhite,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          // backgroundColor:
                          //     kWhite,
                          borderRadius: BorderRadius.circular(100),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Image.network(
                              widget.recentlySent![index].profileImage ?? '',
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/logo/parrot_logo.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
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
                              '${widget.recentlySent![index].name}',
                              style: kBlackDarkMediumStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${widget.recentlySent![index].phoneNumber}',
                              style: kBlackSmallMediumStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Sent on ${CommonTools().getDateAndTime(widget.recentlySent![index].timestamp!)}',
                              style: kBlackSmallMediumStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                          color: kWhite,
                          // color: kWhite,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/send_money.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 15,
            ),
            itemCount: widget.recentlySent!.length > 3
                ? 4
                : widget.recentlySent!.length,
          ),
        ],
      ),
    );
  }
}
