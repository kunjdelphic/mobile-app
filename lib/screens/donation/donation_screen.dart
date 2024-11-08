import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/donation_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final DonationController donationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Donation Funds",
          style: kBlackLargeStyle,
        ),
      ),
      body: GetX<DonationController>(
        init: donationController,
        builder: (controller) {
          if (controller.isFetching.value) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: SizedBox(
                  height: 25,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                    colors: [
                      kAccentColor,
                    ],
                  ),
                ),
              ),
            );
          }
          if (controller.donation.value.data == null) {
            return Center(
              child: SizedBox(
                height: 35,
                child: Text(
                  controller.donation.value.message!,
                  style: kBlackSmallMediumStyle,
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kWhite,
                  border: Border.all(
                    color: Colors.black12,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Contributions',
                              style: kBlackSmallLightMediumStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    '${controller.donation.value.data!.userTotalDonateCurrency}',
                                    style: kBlackDarkMediumStyle,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${controller.donation.value.data!.userTotalDonate}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w700,
                                    color: kColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/donation/donation_logo.png',
                          width: Get.width * 0.2,
                        ),
                      ],
                    ),
                    const Divider(thickness: 0.30),
                    Text(
                      'Total Funds Raised',
                      style: kBlackSmallLightMediumStyle,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '${controller.donation.value.data!.totalDonateCurrency}',
                            style: kBlackDarkMediumStyle,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${controller.donation.value.data!.totalDonate}',
                          style: GoogleFonts.poppins(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Funds Results',
                style: kBlackDarkLargeStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  'assets/images/donation/donation.png',
                  width: Get.width * 0.8,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
