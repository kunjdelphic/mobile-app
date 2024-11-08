import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';

import '../../style/colors.dart';
import '../../style/style.dart';

class DonationProfileTwo extends StatefulWidget {
  const DonationProfileTwo({super.key});

  @override
  State<DonationProfileTwo> createState() => _DonationProfileTwoState();
}

class _DonationProfileTwoState extends State<DonationProfileTwo> {
  int _current = 3;
  final donationcarouselController = CarouselController();
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
                                      "assets/images/donation/image_2$e.jpeg"))),
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
                    _current = index;
                  });
                },
              ),
              carouselController: donationcarouselController,
            ),
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: Get.width,
              height: 82.50,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    ),
                  ),
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38),
              child: Row(
                children: [
                  Text('Persatuan Pembangunan Pendidikan..',
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
                    "2.00pm to 10.00pm",
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
                    "Jasin, Melaka.",
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
                    "0182265278",
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
                    "Ms. Viki",
                    style: kBlackLargeStyle,
                  ),
                )
              ],
            ),
            const SizedBox(
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Profile",
                    style: kBlackDarkLargeStyle.copyWith(
                        color: const Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "The Association for the Development of Indian Student Education in Melaka State is a non-profit organization that offers free tuition to B40 students throughout Malaysia. This NGO consists of 7 teachers and 50 students. They operate their own tuition center in Melaka and also provide online tuition.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Mission",
                    style: kBlackDarkLargeStyle.copyWith(
                        color: const Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "The mission of the Association for the Development of Indian Student Education in Melaka State (ADISEMS) is to provide affordable and tuition-free education for all. They believe that by doing so, they can reduce the number of school dropouts and alleviate poverty",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Service",
                    style: kBlackDarkLargeStyle.copyWith(
                        color: const Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Free classes in Bahasa Malaysia (BM), English (BI), Mathematics, and History for students from kindergarten to Form 3.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Arts classes offered at the Learning Centre.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Free Yoga and Zumba classes for students.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Free Mandarin language classes.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Assistance with school fees for B40 students.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Free Football Coaching.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 50,
                ),
                const Text("●   "),
                Expanded(
                  child: Text(
                    "Free computer skills classes.",
                    style: kBlackLightMediumStyle.copyWith(
                        fontWeight: FontWeight.w300, color: kBlack),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Facilities",
                    style: kBlackDarkLargeStyle.copyWith(
                        color: const Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "ADISEMS has a Learning Centre with two classrooms where they provide homework assistance and language classes to ensure students can communicate effectively in English and Bahasa Malaysia. They also have a play area where students can learn to play chess and congkak. Classes are held four days a week.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Expenses",
                    style: kBlackDarkLargeStyle.copyWith(
                        color: const Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "The organization has various monthly expenses. They employ 7 teachers, paying each RM 800, resulting in a total of RM 5,600 for teacher payments. Other expenses include RM 150 for utilities, RM 650 for rental, RM 500 for materials, RM 700 for printing, RM 1,000 for football class expenses (20 students at RM 50 each), and RM 400 for miscellaneous expenses. In total, the organization's monthly expenses amount to RM 9,000.",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 38.0, top: 10, bottom: 10),
                  child: Text(
                    "Address and Contact Details",
                    style: kBlackDarkLargeStyle.copyWith(
                        color: const Color(0xFF1076BE)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(
                "ADISEMS, is situated at: JB 6299, Jalan 6, Taman Desa Kesang, 77000 Jasin, Melaka. Curious minds and eager learners seeking information or desiring to explore their incredible range of services can easily connect with them. Reach out to ADISEMS now at +60 18-2265278, and embark on a captivating educational journey that will inspire and empower you!",
                style: kBlackLightMediumStyle.copyWith(
                    fontWeight: FontWeight.w300, color: kBlack),
              ),
            ),
            const SizedBox(
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
