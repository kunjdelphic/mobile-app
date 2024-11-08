import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/models/user_profile/terms_and_conditions.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralTermsAndConditionsScreen extends StatefulWidget {
  const ReferralTermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  _ReferralTermsAndConditionsScreenState createState() => _ReferralTermsAndConditionsScreenState();
}

class _ReferralTermsAndConditionsScreenState extends State<ReferralTermsAndConditionsScreen> {
  UserProfileController userProfileController = Get.find();

  late ReferralTermsAndConditions termsAndConditions;

  Future<ReferralTermsAndConditions> getReferralTermsAndConditions(type) async {
    var res = await userProfileController.getReferralTermsAndConditions(type);
    if (res.status == 200) {
      //got it
      termsAndConditions = res;
      //  print(termsAndConditions.content);
    } else {
      //error
      // errorSnackbar(title: 'Failed', subtitle: '${res.message}');
    }

    return res;
  }

  final arg = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          style: kBlackLargeStyle,
        ),
      ),
      body: FutureBuilder<ReferralTermsAndConditions>(
        future: getReferralTermsAndConditions(arg),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            // return const Center(
            //   child: SizedBox(
            //     height: 25,
            //     child: LoadingIndicator(
            //       indicatorType: Indicator.lineScalePulseOut,
            //       colors: [
            //         kAccentColor,
            //       ],
            //     ),
            //   ),
            // );
            return Shimmer.fromColors(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: ListView.builder(
                      itemCount: 25,
                      itemBuilder: ((context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.grey.shade50,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 20,
                                width: Get.width,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        );
                      })),
                ),
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade50);
          }
          if (snapshot.data!.status != 200) {
            return Center(
              child: Text(
                'No Terms and Conditions found!',
                style: kBlackMediumStyle,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              HtmlWidget(
                '${termsAndConditions.content}',
                textStyle: kBlackSmallMediumStyle,
                onTapUrl: (url) {
                  final Uri ur = Uri.parse(url);
                  launchUrl(ur);
                  return true;
                },
              )
            ],
          );
        },
      ),
    );
  }
}
