import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/donation_controller.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';

import '../../style/colors.dart';
import '../../style/style.dart';

class DonationProfileOne extends StatefulWidget {
  const DonationProfileOne({super.key});

  @override
  State<DonationProfileOne> createState() => _DonationProfileOneState();
}

class _DonationProfileOneState extends State<DonationProfileOne> {
  int _current = 3;
  final donationcarouselController = CarouselController();
  final controller = Get.find<DonationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(CupertinoIcons.back)),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: kWhite,
        title: Text(
          'Donee Profile',
          style: kBlackExtraLargeStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              items: [0, 1, 2, 3, 4, 5]
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFC7C7C7)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x0A000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                  spreadRadius: 0,
                                )
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/donation/image_1$e.jpeg"))),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                viewportFraction: 1,
                initialPage: 3,
                onPageChanged: (index, reason) {
                  setState(() {
                    print(index);
                    _current = index;
                  });
                },
              ),
              carouselController: donationcarouselController,
            ),
            // Text(_current.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0, 1, 2, 3, 4, 5].map((entry) {
                return GestureDetector(
                  // onTap: () => donationcarouselController.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 3.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        shape: BoxShape.rectangle,
                        color: _current == entry
                            ? const Color(0xFF0E76BC)
                            : kLightBlack),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: Get.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              // height: 82.50,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                  const BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Container(
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
                                  decoration: ShapeDecoration(
                                      color: const Color(0xFFF4F4F4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Positioned(
                                top: 31,
                                child: Container(
                                  height: 8,
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                  ),
                                  width: double.parse(controller
                                              .donation.value.data!.totalDonate
                                              .toString()) <=
                                          200.00
                                      ? 10
                                      : (Get.width - 190) /
                                          10000 *
                                          double.parse(controller
                                              .donation.value.data!.totalDonate
                                              .toString()),
                                  decoration: ShapeDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFF00FFD1),
                                        Color(0xFF0095FF),
                                      ]),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Positioned(
                                top: 31,
                                child: Container(
                                  height: 8,
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                  ),
                                  width: double.parse(controller.donation.value
                                              .data!.userTotalDonate
                                              .toString()) <=
                                          100.00
                                      ? 5
                                      : (Get.width - 190) /
                                          10000 *
                                          double.parse(controller.donation.value
                                              .data!.userTotalDonate
                                              .toString()),
                                  decoration: ShapeDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFFD6FE67),
                                        Color(0xFF2FF804),
                                      ]),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Positioned(
                                  top: 42,
                                  left: double.parse(controller
                                              .donation.value.data!.totalDonate
                                              .toString()) <=
                                          100.00
                                      ? 5
                                      : (Get.width - 190) /
                                              10000 *
                                              double.parse(controller.donation
                                                  .value.data!.totalDonate
                                                  .toString()) +
                                          4,
                                  child: Image.asset(
                                      "assets/images/donation/fund_result_polygon2.png")),
                              Positioned(
                                  top: 21,
                                  left: (Get.width - 190) /
                                          10000 *
                                          double.parse(controller.donation.value
                                              .data!.userTotalDonate
                                              .toString()) +
                                      4,
                                  child: Image.asset(
                                      "assets/images/donation/fund_result_polygon1.png")),
                              Positioned(
                                top: 50,
                                left: (Get.width - 190) /
                                    10000 *
                                    double.parse(controller
                                        .donation.value.data!.totalDonate
                                        .toString()),
                                child: Row(
                                  children: [
                                    Text(
                                      '${controller.donation.value.data!.totalDonateCurrency}',
                                      style:
                                          kBlueExtraSmallMediumStyle.copyWith(
                                        fontSize: 6,
                                        color: const Color(0xFF1076BE),
                                      ),
                                    ),
                                    Text(
                                      '${controller.donation.value.data!.totalDonate}',
                                      style:
                                          kGreenExtraSmallMediumStyle.copyWith(
                                              color: const Color(0xFF1076BE),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: (Get.width - 190) /
                                    10000 *
                                    double.parse(controller
                                        .donation.value.data!.userTotalDonate
                                        .toString()),
                                child: Row(
                                  children: [
                                    Text(
                                      '${controller.donation.value.data!.userTotalDonateCurrency}',
                                      style:
                                          kGreenExtraSmallMediumStyle.copyWith(
                                        fontSize: 6,
                                      ),
                                    ),
                                    Text(
                                      '${controller.donation.value.data!.userTotalDonate}',
                                      style:
                                          kGreenExtraSmallMediumStyle.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
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
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38),
              child: Row(
                children: [
                  Text('Bandar Damai Home Care',
                      style: kBlackDarkExtraLargeStyle),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  width: Get.width * 0.5,
                  padding: const EdgeInsets.only(left: 32, top: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/donation/timer-icon.png",
                          width: 21,
                        ),
                      ),
                      Text(
                        "Operation Hours",
                        style: kBlackLargeStyle.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Text(
                  ":",
                  style: kBlackLargeStyle,
                ),
                Container(
                  // width: Get.width * 0.5,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "8.00am to 10.00pm",
                    style: kBlackLargeStyle,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: Get.width * 0.53,
                  padding: const EdgeInsets.only(left: 32),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/donation/location-point-icon.png",
                          width: 21,
                        ),
                      ),
                      Text(
                        "Located At",
                        style: kBlackLargeStyle.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Text(
                  ":",
                  style: kBlackLargeStyle,
                ),
                Container(
                  // width: Get.width * 0.5,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Cheras, K.L.",
                    style: kBlackLargeStyle,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: Get.width * 0.53,
                  padding: const EdgeInsets.only(left: 32),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/donation/call-icon.png",
                          width: 21,
                        ),
                      ),
                      Text(
                        "Contect No.",
                        style: kBlackLargeStyle.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Text(
                  ":",
                  style: kBlackLargeStyle,
                ),
                Container(
                  // width: Get.width * 0.5,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "0182220404",
                    style: kBlackLargeStyle,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: Get.width * 0.53,
                  padding: const EdgeInsets.only(left: 32),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/donation/person-icon.png",
                          width: 21,
                        ),
                      ),
                      Text(
                        "Person In-charge",
                        style: kBlackLargeStyle.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Text(
                  ":",
                  style: kBlackLargeStyle,
                ),
                Container(
                  // width: Get.width * 0.5,
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Dr.Durai Raju",
                    style: kBlackLargeStyle,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 38.0),
                  child: Text(
                    "More Information",
                    style: kBlackExtraLargeStyle,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Profile",
                    style:
                        kBlackDarkLargeStyle.copyWith(color: Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "Bandar Damai Home Care is a nursing home located in Cheras, Kuala Lumpur, Dedicated to providing high-quality residential care services, home care offers a safe and nurturing environment for individuals in need of assistance and support.\n\nFurthermore, the home care has also been recognized by the University of Malaya and received a certificate of appreciation for its services in 2019.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Mission",
                    style:
                        kBlackDarkLargeStyle.copyWith(color: Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "Mission of Bandar Damai Home Care is to enhance the quality of life for its residents by delivering personalized care and promoting their physical, emotional, and social well-being. With a compassionate and professional team, they strive to create a home-like atmosphere where residents can thrive and maintain their dignity.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Service",
                    style:
                        kBlackDarkLargeStyle.copyWith(color: Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "Bandar Damai Home Care provides a variety of services for the elderly, such as: ",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 38),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Text("● "),
                  Expanded(
                    child: Text(
                      "Personal care, including bathing, dressing and grooming",
                      style: kBlackLightMediumStyle.copyWith(
                          fontWeight: FontWeight.w300, color: kBlack),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                  ),
                  Text("●  "),
                  Expanded(
                    child: Text(
                      "Nursing care such as medication administration and wound care",
                      style: kBlackLightMediumStyle.copyWith(
                          fontWeight: FontWeight.w300, color: kBlack),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "Rehabilitation services such as physical therapy and occupational therapy",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "Social activities in the form of group outings and games",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "Spiritual care in the form of religious services and counselling",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Facilities",
                    style:
                        kBlackDarkLargeStyle.copyWith(color: Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "Bandar Damai Home Care currently operates two homes, each of which has a 40-bed capacity. Some of the key facilities provided by Bandar Damai Home Care include:",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "24-hour nursing and medical care",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "Balanced diet (6 meals daily)",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "In-house laundry",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "TV/Video (Astro channels)",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "Basic medication (by KKM)",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "Ripper Mattress and Aqua bed (for bed-ridden folks)",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                ),
                Text("●  "),
                Expanded(
                  child: Text(
                    "In-house physiotherapy, acupuncture and reflexology",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Expenses",
                    style:
                        kBlackDarkLargeStyle.copyWith(color: Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "Bandar Damai Home Care incurs daily food expenses of RM 15.5 per adult, totaling RM 1,519.00 per day for the 98 residents. Over the course of a month (30 days), this amounts to RM 45,570.00. \n\nIn addition to that, apart from food costs, the total monthly expenses for the home care facility amount to RM 55,250.00. Consequently, the overall monthly expenditure for Bandar Damai Home Care is RM 100,820.00. \n\nGiven these expenses, any assistance or support to aid the home care facility would be greatly appreciated, as it enables us to make a meaningful contribution to the community and help those in need.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Address and Contact Details",
                    style:
                        kBlackDarkLargeStyle.copyWith(color: Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "Located at No. 24, Jalan Damai Perdana 2/6f, in the vibrant neighborhood of Bandar Damai Perdana, Kuala Lumpur.\n\nIf you have any inquiries or would like to learn more about the services provided by Bandar Damai Home Care, their friendly staff is available to assist you. You can reach them by phone at 0182220404.\n\nWhether you have questions about admission procedures, facility amenities, or would like to schedule a visit, their knowledgeable team is dedicated to addressing your needs and providing the information you require.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: GradientButton(
                  text: "Back",
                  width: true,
                  onTap: () {
                    Get.back();
                  },
                  widthSize: Get.width,
                  buttonState: null),
            )
          ],
        ),
      ),
    );
  }
}
