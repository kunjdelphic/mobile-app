import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/models/user_profile/user_profile.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/card/add_bill_voucher.dart';
import 'package:video_player/video_player.dart';

class AddBillVoucher extends StatefulWidget {
  const AddBillVoucher({
    super.key,
  });

  @override
  State<AddBillVoucher> createState() => _AddBillVoucherState();
}

class _AddBillVoucherState extends State<AddBillVoucher> {
  UserProfileController userProfileController = Get.find();
  late VideoPlayerController _controller;
  int claimedVouchers = 750;
  int totalVouchers = 1000;
  int days = 1;
  int hours = 30;
  int minutes = 24;
  int seconds = 2;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        if (minutes > 0) {
          setState(() {
            minutes--;
            seconds = 59;
          });
        } else if (hours > 0) {
          setState(() {
            hours--;
            minutes = 59;
          });
        } else if (days > 0) {
          setState(() {
            days--;
            hours = 23;
          });
        } else {
          timer.cancel();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        setState(() {}); // Update the UI when the video is ready to play
      });
  }

  final List<Map<String, String>> stepsData = [
    {
      'title': "Start by Adding Your First Bill",
      'description':
          "Add your first bill now and make a minimum payment to claim your first RM10. Keep adding to earn more!",
      'buttonText': "Add Bills From Favorites",
    },
    {
      'title': "Track Your Expenses",
      'description':
          "Monitor your expenses and categorize them to gain insights on your spending patterns.",
      'buttonText': "Track Now",
    },
    {
      'title': "Get Rewards",
      'description':
          "Continue adding bills to reach milestones and unlock additional rewards!",
      'buttonText': "Check Rewards",
    },
  ];

  int currentIndex = 0;

  void _addStep() {
    if (currentCount < stepsData.length) {
      setState(() {
        currentCount++;
      });
    }
  }

  int currentCount = 1;
  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = claimedVouchers / totalVouchers;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Get a RM 30.00 Cash Voucher!',
          style: kBlackLargeStyle,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _controller.value.isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(30)),
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 60.0,
                        ),
                      ),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Complete Process to claim voucher',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: kBlackDarkLargeStyle,
                ),
                Center(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/voucher.png'),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Get',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: kBlack,
                                    ),
                                  ),
                                  Text(
                                    ' RM30',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                                width: 300,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  color: Colors.green,
                                  backgroundColor: Colors.green.shade200,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$claimedVouchers/$totalVouchers vouchers claimed',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    '${totalVouchers - claimedVouchers} left',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3 * 2 - 1, (index) {
                      if (index % 2 == 0) {
                        int stepNumber = (index / 2).floor() + 1;
                        bool isActive = stepNumber <= currentCount;

                        return CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              isActive ? kColorPrimary : kwhitegrey,
                          child: Text(
                            stepNumber.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isActive ? kWhite : kLightBlack,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Image.asset(
                            'assets/images/line.png',
                            fit: BoxFit.none,
                          ),
                        );
                      }
                    }),
                  ),
                ),
                ...List.generate(
                  currentCount,
                  (index) => StepCard(
                    stepNumber: index + 1,
                    title: stepsData[index]['title']!,
                    description: stepsData[index]['description']!,
                    buttonText: stepsData[index]['buttonText']!,
                  ),
                ),
                SizedBox(height: 20),
                if (currentCount < stepsData.length)
                  ElevatedButton(
                    onPressed: _addStep,
                    child: Text("Add Next Step"),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GradientBtn(
                      widthSize: 200,
                      width: false,
                      text: 'Claim Voucher',
                      onTap: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
