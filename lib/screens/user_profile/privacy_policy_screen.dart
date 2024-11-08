import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/models/user_profile/privacy_policy.dart';
import 'package:parrotpos/style/style.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  UserProfileController userProfileController = Get.find();

  late PrivacyPolicy privacyPolicy;

  Future<PrivacyPolicy> getPrivacyPolicy(type) async {
    var res = await userProfileController.getPrivacyPolicy(type);
    if (res.status == 200) {
      //got it
      privacyPolicy = res;
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
          "Privacy Policy",
          style: kBlackLargeStyle,
        ),
      ),
      body: FutureBuilder<PrivacyPolicy>(
        future: getPrivacyPolicy(arg),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
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
                'No Privacy Policy found!',
                style: kBlackMediumStyle,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              HtmlWidget(
                '${privacyPolicy.content}',
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
