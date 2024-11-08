import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/donation_controller.dart';
import 'package:parrotpos/screens/donation/donation_details_screen.dart';
import 'package:parrotpos/screens/donation/donation_profile_one.dart';
import 'package:parrotpos/screens/donation/donation_profile_two.dart';
import 'package:parrotpos/screens/donation/fund_request_form.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/white_button.dart';

import '../../style/colors.dart';
import '../../widgets/buttons/gradient_button.dart';

class FundResultScreen extends StatefulWidget {
  const FundResultScreen({super.key});

  @override
  State<FundResultScreen> createState() => _FundResultScreenState();
}

class _FundResultScreenState extends State<FundResultScreen> {
  final controller = Get.find<DonationController>();

  @override
  void initState() {
    setState(() {});
    controller.getDonation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 100;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(CupertinoIcons.back)),
        centerTitle: true,
        elevation: 0.3,
        shadowColor: Colors.grey.shade500,
        backgroundColor: Colors.white,
        title: Text(
          'Fund Result',
          style: kBlackExtraLargeStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: Get.width,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 11,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: StreamBuilder(
                stream: controller.donation.stream,
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      Container(
                        width: Get.width * 0.5 - 5,
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "My Contribution",
                              style: kBlackExtraSmallMediumStyle,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${controller.donation.value.data!.userTotalDonateCurrency}',
                                  style: kBlackDarkMediumStyle.copyWith(fontSize: 10),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${controller.donation.value.data!.userTotalDonate}',
                                  style: kGreenMediumStyle.copyWith(fontSize: 18),
                                ),
                                const Spacer(),
                                Container(
                                  height: 26,
                                  width: 26,
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
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        color: Colors.grey.shade200,
                        width: 1,
                        height: 100,
                      ),
                      Container(
                        width: Get.width * 0.5 - 5,
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Fund Raised",
                              style: kBlackExtraSmallMediumStyle,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${controller.donation.value.data!.totalDonateCurrency}',
                                  style: kBlackDarkMediumStyle.copyWith(fontSize: 10),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${controller.donation.value.data!.totalDonate}',
                                  style: kBlueExtraSmallMediumStyle.copyWith(
                                    fontSize: 18,
                                    color: const Color(0xFF1076BE),
                                  ), //kGreenMediumStyle.copyWith(fontSize: 18),
                                ),
                                const Spacer(),
                                Container(
                                  height: 26,
                                  width: 26,
                                  decoration: const ShapeDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/logo/logo_full.png",
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(),
                                    shadows: [],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
          GestureDetector(
            onTap: () {
              Get.to(const DonationProfileOne());
            },
            child: Container(
              margin: const EdgeInsets.all(10),
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
                          margin: const EdgeInsets.all(10),
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
                        bottom: 20,
                        right: 20,
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
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 18),
                        child: Text('Happy Retirement for Elderly People !', style: kBlackDarkLargeStyle.copyWith(fontSize: 16)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text('Bandar Damai Home Care', style: kBlackLargeStyle.copyWith(fontSize: 14)),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Padding(
                  //         padding: const EdgeInsets.only(
                  //             left: 18, top: 10, bottom: 10, right: 8),
                  //         child: Container(
                  //           height: 56,
                  //           width: 56,
                  // decoration: ShapeDecoration(
                  //   image: const DecorationImage(
                  //       image: AssetImage(
                  //         "assets/images/donation/donation-1-icon-1.jpeg",
                  //       ),
                  //       fit: BoxFit.fill),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(100),
                  //   ),
                  //   shadows: const [
                  //     BoxShadow(
                  //       color: Color(0x3F000000),
                  //       blurRadius: 4,
                  //       offset: Offset(0, 0),
                  //       spreadRadius: 0,
                  //     ),
                  //   ],
                  // ),
                  //         )),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Text(
                  //               '${controller.donation.value.data!.userTotalDonateCurrency}',
                  //               style: kGreenExtraSmallMediumStyle.copyWith(
                  //                   fontSize: 6),
                  //             ),
                  //             Text(
                  //               '${controller.donation.value.data!.userTotalDonate}',
                  //               style: kGreenExtraSmallMediumStyle.copyWith(
                  //                   fontSize: 12, fontWeight: FontWeight.w600),
                  //             ),
                  //           ],
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(
                  //             left: Get.width *
                  //                 0.74 /
                  //                 10000 *
                  //                 double.parse(controller
                  //                     .donation.value.data!.userTotalDonate
                  //                     .toString()),
                  //           ),
                  //           child: Image.asset(
                  //               "assets/images/donation/fund_result_polygon1.png"),
                  //         ),
                  //         Container(
                  //           width: Get.width - 20,
                  //           margin: const EdgeInsets.only(left: 3),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Expanded(
                  //                 child: Stack(
                  //                   children: [
                  //                     Container(
                  //                       height: 8,
                  //                       decoration: ShapeDecoration(
                  //                         color: const Color(0xFFF4F4F4),
                  //                         shape: RoundedRectangleBorder(
                  //                           borderRadius:
                  //                               BorderRadius.circular(10),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       width: Get.width *
                  //                           0.74 /
                  //                           10000 *
                  //                           double.parse(controller.donation
                  //                               .value.data!.totalDonate
                  //                               .toString()),
                  //                       height: 8,
                  //                       decoration: ShapeDecoration(
                  //                         gradient: const LinearGradient(
                  //                           begin: Alignment(-1.00, -0.00),
                  //                           end: Alignment(1, 0),
                  //                           colors: [
                  // Color(0xFF00FFD1),
                  // Color(0xFF0095FF),
                  //                           ],
                  //                         ),
                  //                         shape: RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(2)),
                  //                       ),
                  //                     ),
                  //                     Container(
                  //                       width: Get.width *
                  //                           0.74 /
                  //                           10000 *
                  //                           double.parse(controller.donation
                  //                               .value.data!.userTotalDonate
                  //                               .toString()),
                  //                       height: 8,
                  //                       decoration: ShapeDecoration(
                  //                         gradient: const LinearGradient(
                  //                           begin: Alignment(-1.00, -0.00),
                  //                           end: Alignment(1, 0),
                  //                           colors: [
                  // Color(0xFFD6FE67),
                  // Color(0xFF2FF804),
                  //                           ],
                  //                         ),
                  //                         shape: RoundedRectangleBorder(
                  //                             borderRadius:
                  //                                 BorderRadius.circular(2)),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 10,
                  //               ),
                  //               SizedBox(
                  //                 width: 100,
                  //                 child: Text(
                  //                   "10,000.00 ",
                  //                   style: kBlackMediumStyle.copyWith(
                  //                       fontSize: 10),
                  //                 ),
                  //               ),
                  //               Container(
                  //                 width: 20,
                  //                 child: Text(
                  //                   '${controller.donation.value.data!.totalDonateCurrency}',
                  //                   style:
                  //                       kBlackMediumStyle.copyWith(fontSize: 8),
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 16,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(
                  //             left: Get.width *
                  //                     0.74 /
                  //                     10000 *
                  //                     double.parse(controller
                  //                         .donation.value.data!.totalDonate
                  //                         .toString()) -
                  //                 56,
                  //           ),
                  //           child: Image.asset(
                  //               "assets/images/donation/fund_result_polygon2.png"),
                  //         ),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       width: Get.width *
                  //               0.74 /
                  //               10000 *
                  //               double.parse(controller
                  //                   .donation.value.data!.totalDonate
                  //                   .toString()) -
                  //           56,
                  //     ),
                  //     Text(
                  //       '${controller.donation.value.data!.totalDonateCurrency}',
                  //       style: kBlueExtraSmallMediumStyle.copyWith(
                  //         fontSize: 6,
                  //         color: const Color(0xFF1076BE),
                  //       ),
                  //     ),
                  //     Text(
                  //       '${controller.donation.value.data!.totalDonate}',
                  //       style: kGreenExtraSmallMediumStyle.copyWith(
                  //           color: const Color(0xFF1076BE),
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w600),
                  //     ),
                  //   ],
                  // ),
                  //       ],
                  //     )
                  //   ],
                  // ),Sized
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width - 20,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 18,
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: ShapeDecoration(
                            image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/donation/donation-1-icon-1.jpeg",
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
                        ),
                        Container(
                          width: Get.width - 180,
                          // color: Colors.black12,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 70,
                                    // margin: EdgeInsets.only(left: 8),
                                  ),
                                  Positioned(
                                    top: 31,
                                    child: Container(
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      width: Get.width - 190,
                                      decoration: ShapeDecoration(color: const Color(0xFFF4F4F4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    ),
                                  ),
                                  Positioned(
                                    top: 31,
                                    child: Container(
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      width: double.parse(controller.donation.value.data!.totalDonate.toString()) <= 200.00
                                          ? 10
                                          : (Get.width - 190) / 10000 * double.parse(controller.donation.value.data!.totalDonate.toString()),
                                      decoration: ShapeDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xFF00FFD1),
                                            Color(0xFF0095FF),
                                          ]),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    ),
                                  ),
                                  Positioned(
                                    top: 31,
                                    child: Container(
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      width: double.parse(controller.donation.value.data!.userTotalDonate.toString()) <= 100.00
                                          ? 5
                                          : (Get.width - 190) / 10000 * double.parse(controller.donation.value.data!.userTotalDonate.toString()),
                                      decoration: ShapeDecoration(
                                          gradient: const LinearGradient(colors: [
                                            Color(0xFFD6FE67),
                                            Color(0xFF2FF804),
                                          ]),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    ),
                                  ),
                                  Positioned(
                                      top: 42,
                                      left: (Get.width - 190) / 10000 * double.parse(controller.donation.value.data!.totalDonate.toString()) + 4,
                                      child: Image.asset("assets/images/donation/fund_result_polygon2.png")),
                                  Positioned(
                                      top: 21,
                                      left: (Get.width - 190) / 10000 * double.parse(controller.donation.value.data!.userTotalDonate.toString()) + 4,
                                      child: Image.asset("assets/images/donation/fund_result_polygon1.png")),
                                  Positioned(
                                    top: 50,
                                    left: (Get.width - 190) / 10000 * double.parse(controller.donation.value.data!.totalDonate.toString()),
                                    child: StreamBuilder(
                                        stream: controller.donation.stream,
                                        builder: (context, snapshot) {
                                          return Row(
                                            children: [
                                              Text(
                                                '${controller.donation.value.data!.totalDonateCurrency}',
                                                style: kBlueExtraSmallMediumStyle.copyWith(
                                                  fontSize: 6,
                                                  color: const Color(0xFF1076BE),
                                                ),
                                              ),
                                              Text(
                                                '${controller.donation.value.data!.totalDonate}',
                                                style: kGreenExtraSmallMediumStyle.copyWith(color: const Color(0xFF1076BE), fontSize: 12, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: (Get.width - 190) / 10000 * double.parse(controller.donation.value.data!.userTotalDonate.toString()),
                                    child: StreamBuilder(
                                        stream: controller.donation.stream,
                                        builder: (context, snapshot) {
                                          return Row(
                                            children: [
                                              Text(
                                                '${controller.donation.value.data!.userTotalDonateCurrency}',
                                                style: kGreenExtraSmallMediumStyle.copyWith(
                                                  fontSize: 6,
                                                ),
                                              ),
                                              Text(
                                                '${controller.donation.value.data!.userTotalDonate}',
                                                style: kGreenExtraSmallMediumStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "10000.00",
                                style: kBlackMediumStyle.copyWith(fontSize: 10),
                              ),
                              Text(
                                "RM",
                                style: kBlackDarkMediumStyle.copyWith(fontSize: 8),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(const DonationProfileTwo());
            },
            child: Container(
              margin: const EdgeInsets.all(10),
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
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                          child: Container(
                            width: Get.width,
                            height: 155,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x21000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                                child: Text(
                              "This campaign will be activated, once the\n target for the above campaign is reached ! ",
                              style: kBlackMediumStyle,
                            )),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 30,
                          bottom: 30,
                          child: Text(
                            "Locked",
                            style: kBlackMediumStyle,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18, top: 10),
                        child: Text('Make their future bright !', style: kBlackDarkLargeStyle.copyWith(fontSize: 16)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Text("Persatuan Pembangunan Pendidikan..", style: kBlackLargeStyle.copyWith(fontSize: 14)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 10, right: 8),
                          child: Container(
                            height: 56,
                            width: 56,
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
                          Container(
                            width: Get.width * 0.74,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 8,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF4F4F4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "10,000.00 ",
                                  style: kBlackMediumStyle.copyWith(fontSize: 10),
                                ),
                                Text(
                                  "RM ",
                                  style: kBlackMediumStyle.copyWith(fontSize: 8),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: WhiteButton(
                text: "More Details",
                width: true,
                widthSize: Get.width,
                onTap: () {
                  Get.to(const DonationDetailScreen());
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GradientButton(
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 200));
                Get.to(const FundRequestForm());
              },
              text: 'Funds Request Form',
              width: true,
              buttonState: null,
              widthSize: Get.width,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ]),
      ),
    );
  }
}
