import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controllers/notification_controller.dart';
import '../../services/remote_service.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/dialogs/common_dialogs.dart';

class FullNotificationScreen extends StatefulWidget {
  final String id;
  const FullNotificationScreen({
    super.key,
    required this.id,
  });

  @override
  State<FullNotificationScreen> createState() => _FullNotificationScreenState();
}

class _FullNotificationScreenState extends State<FullNotificationScreen> {
  final NotificationController notificationController = Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getNotificationRead();
    });
  }

  // Get the formatted output
  // String formattedTime = formatNotificationTime(createdAt);
  // Future<String> getNotificationRead() async {
  //   var res = await RemoteService.getNotificationRead(id: widget.id);
  //   print("Read +++++ Status${notificationController.getNotificationModel.value.message}");
  //   print("Read +++++ Status${notificationController.getNotificationModel.value.status}");
  //   print("Read +++++ Status${notificationController.getNotificationModel.value.notifications}");
  //   return res;
  // }

  getNotificationRead() async {
    await notificationController.getReadNotification(id: widget.id).then((value) {
      setState(() {});
    });
    print("Read +++++ Status${notificationController.getNotificationModel.value.message}");
    print("Read +++++ Status${notificationController.getNotificationModel.value.status}");
    print("Read +++++ Status${notificationController.getNotificationModel.value.notifications}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close, size: 24, color: Colors.grey),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                notificationDeleteDialog(
                  onTap: () {},
                  context: context,
                  title1: "Delete Notification !",
                  title2: "Are you sure you want to delete selected notifications.",
                );
              },
              child: SvgPicture.asset(
                "assets/icons/notification_delete.svg",
                height: 20,
                width: 20,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: notificationController.getNotificationModel.stream,
          builder: (context, snapshot) {
            final readeData = notificationController.getNotificationRead.value;
            String formatNotificationTime(String? createdAt) {
              if (createdAt == null) {
                return "Invalid date";
              }

              DateTime notificationTime = DateTime.parse(createdAt);

              // Get the current time
              DateTime now = DateTime.now();

              // Calculate the difference
              Duration difference = now.difference(notificationTime);

              // Display the difference in a user-friendly way
              if (difference.inDays > 0) {
                return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
              } else if (difference.inHours > 0) {
                return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
              } else if (difference.inMinutes > 0) {
                return "${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago";
              } else {
                return "Just now";
              }
            }

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  // margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFD9Ecc7),
                        Color(0xFFD9Ecc7),
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff0E76BC),
                              Color(0xff283891),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 5),
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: Colors.grey, width: 1.3),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      readeData.notifications?.title ?? "",
                                      style: kBlackLargeStyle,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(15),
                  color: kWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            // children: [Icon(Icons.date_range), Text("${readeData.notifications?.createdAt}")],
                            children: [
                              Image.asset(
                                "assets/images/calendar.png",
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "${DateFormat('MMMM d, yyyy HH:mm').format(DateTime.parse(readeData.notifications?.createdAt ?? DateTime.now().toString()))}",
                                style: kBlackLargeStyle,
                              ),
                            ],
                          ),
                          Text(
                            formatNotificationTime(readeData.notifications?.createdAt),
                            style: kBlackSmall.copyWith(
                              fontSize: 11,
                              color: Color(0xFF575757),
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 0.30),
                      Text(
                        "${readeData.notifications?.message}",
                        style: kBlackSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: Get.width,
                  color: kWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Support Contact ",
                          style: kPrimaryDarkExtraLargeStyle.copyWith(
                            color: Color(0xFF0E76BC),
                          )
                          // TextStyle(
                          //   color: Color(0xFF0E76BC),
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.w600,
                          // ),
                          ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(text: "Email :  ", style: kBlackLargeStyle, children: [
                          TextSpan(
                            text: "support@example.com",
                            style: kBlackLightLargeStyle.copyWith(
                              color: Color(0xFF3D3D3D),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(text: "Phone : ", style: kBlackLargeStyle, children: [
                          TextSpan(
                            text: "+1234567890",
                            style: kBlackLightLargeStyle.copyWith(
                              color: Color(0xFF3D3D3D),
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 16),
                      Text("Social Media",
                          style: kPrimaryDarkExtraLargeStyle.copyWith(
                            color: Color(0xFF0E76BC),
                          )),
                      SizedBox(height: 12),
                      Container(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SocialMediaData(image: "assets/images/facebook-logo.png"),
                            SocialMediaData(image: "assets/images/twitter-logo.png"),
                            SocialMediaData(image: "assets/images/whatsapp-logo.png"),
                            SocialMediaData(image: "assets/images/tiktok-png.png"),
                            SocialMediaData(image: "assets/images/instagram.png"),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

class SocialMediaData extends StatelessWidget {
  final String image;
  const SocialMediaData({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0.1, 0.2),
          ),
        ],
      ),
      child: Image.asset(image, fit: BoxFit.cover),
    );
  }
}
