import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/donation_controller.dart';
import 'package:parrotpos/screens/donation/fund_result_screen.dart';

import '../../style/style.dart';

class HomeScreenCarousel extends StatefulWidget {
  const HomeScreenCarousel({super.key});

  @override
  State<HomeScreenCarousel> createState() => _HomeScreenCarouselState();
}

int _current = 0;
final CarouselController donationcarouselController = CarouselController();

class _HomeScreenCarouselState extends State<HomeScreenCarousel> {
  final donationController = Get.put(DonationController());
  @override
  void initState() {
    donationController.getDonation();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String percentValue =
        donationController.donation.value.data?.totalDonate == null ? '0.00' : (double.parse(donationController.donation.value.data!.totalDonate.toString()) / 100).toStringAsFixed(2);

    var data = [
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    height: 180,
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/donation/donation-1.jpeg"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      Get.to(const FundResultScreen());
                    },
                    child: Container(
                      width: 100,
                      height: 26,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.699999988079071),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x21000000),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "View More",
                            style: kBlackExtraSmallMediumStyle,
                          ),
                          SvgPicture.asset("assets/images/donation/arrow_go.svg")
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Happy Retirement for Elderly People !', style: kBlackDarkLargeStyle.copyWith(fontSize: 15)),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/donation/donation-1-icon-1.jpeg",
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Bandar Damai Home Care"),
                    Container(
                      width: Get.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/donation/um-icon.png",
                            width: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Humanitarian",
                            style: kBlackExtraLightMediumStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Stack(
                  children: [
                    Container(
                      width: Get.width - 135,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF4F4F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      width: double.parse(percentValue) < 1.00 ? 5 : ((Get.width - 130) / 100) * double.parse(percentValue),
                      height: 5,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-1.00, 0.00),
                          end: Alignment(1, 0),
                          colors: [
                            Color(0xFFD5FC66),
                            Color(0xFFB1FF2E),
                            Color(0xFF2EF703),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  "$percentValue %",
                  style: kBlackLightMediumStyle,
                ),
                // const SizedBox(
                //   width: 16,
                // ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Target :",
                  style: kBlackLightMediumStyle,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: ' 10,000.00 ',
                        style: kBlackDarkLargeStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.28,
                        ),
                      ),
                      TextSpan(
                        text: 'RM',
                        style: kBlackDarkLargeStyle.copyWith(
                          color: const Color(0xFF434343),
                          fontSize: 10,
                          fontFamily: 'Mulish',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
                const Spacer(),
                StreamBuilder(
                    stream: donationController.donation.stream,
                    builder: (context, snapshot) {
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${donationController.donation.value.data?.totalDonate} ',
                              style: kBlackDarkLargeStyle.copyWith(
                                color: const Color(0xFF79B22C),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.28,
                              ),
                            ),
                            TextSpan(
                              text: 'RM',
                              style: kBlackDarkLargeStyle.copyWith(
                                color: const Color(0xFF434343),
                                fontSize: 10,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.20,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      );
                    }),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            // SizedBox(
            //   height: 10,
            // )
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    height: 180,
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/donation/donation-2.png"),
                        fit: BoxFit.fitWidth,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                Positioned(
                  top: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      Get.to(const FundResultScreen());
                    },
                    child: Container(
                      width: 100,
                      height: 26,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.699999988079071),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x21000000),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "View More",
                            style: kBlackExtraSmallMediumStyle,
                          ),
                          SvgPicture.asset("assets/images/donation/arrow_go.svg")
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Make their future bright !', style: kBlackDarkLargeStyle.copyWith(fontSize: 15)),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/donation/donation-2-icon-2.jpeg",
                            ),
                            fit: BoxFit.fill),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Persatuan Pembangunan Pendidikan.."),
                    Container(
                      width: Get.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/donation/um-icon-3.jpeg",
                            width: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Education",
                            style: kBlackExtraLightMediumStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    width: Get.width,
                    height: 5,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF4F4F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "0.00 %",
                  style: kBlackLightMediumStyle,
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Target :",
                  style: kBlackLightMediumStyle,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: ' 10,000.00 ',
                        style: kBlackDarkLargeStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.28,
                        ),
                      ),
                      TextSpan(
                        text: 'RM',
                        style: kBlackDarkLargeStyle.copyWith(
                          color: const Color(0xFF434343),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
                const Spacer(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '0.00 ',
                        style: kBlackLightLargeStyle.copyWith(
                          // color: const Color(0xFF79B22C),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.28,
                        ),
                      ),
                      TextSpan(
                        text: 'RM',
                        style: kBlackLightLargeStyle.copyWith(
                          // color: const Color(0xFF434343),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.20,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            )
          ],
        ),
      )
    ];

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Text('Fund Results', style: kBlackDarkExtraLargeStyle),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          CarouselSlider(
            items: data.map((e) => GestureDetector(onTap: () => Get.to(const FundResultScreen()), child: e)).toList(),
            options: CarouselOptions(
              height: 355,
              autoPlay: true,
              disableCenter: true,
              viewportFraction: 0.9,
              // reverse: false,
              padEnds: false,
              enableInfiniteScroll: false,
              initialPage: 0,
              pageSnapping: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            carouselController: donationcarouselController,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                width: 12.0,
                height: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), shape: BoxShape.rectangle, color: _current == 0 ? const Color(0xFF0E76BC) : Colors.grey)),
            Container(
                width: 12.0,
                height: 3.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), shape: BoxShape.rectangle, color: _current == 1 ? const Color(0xFF0E76BC) : Colors.grey)),
          ]),
        ],
      ),
    );
  }
}
