import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:parrotpos/models/user_profile/user_profile.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/user_profile_controller.dart';
import '../style/style.dart';

class ExtraGuideDetailScreen extends StatefulWidget {
  final ExtraGuides extraGuides;
  const ExtraGuideDetailScreen({Key? key, required this.extraGuides}) : super(key: key);

  @override
  State<ExtraGuideDetailScreen> createState() => _ExtraGuideDetailScreenState();
}

class _ExtraGuideDetailScreenState extends State<ExtraGuideDetailScreen> {
  UserProfileController userProfileController = Get.find();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a network request or data fetching process
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '${widget.extraGuides.heading}',
          style: kBlackLargeStyle,
        ),
      ),
      body: isLoading ? _buildShimmer() : _buildContent(),

      ///      firest time Code
      // ListView(
      //   padding: const EdgeInsets.all(20),
      //   children: [
      //     ClipRRect(
      //       borderRadius: BorderRadius.circular(18),
      //       child: Image.network(
      //         widget.extraGuides.image ?? '',
      //         errorBuilder: (context, error, stackTrace) => const Icon(
      //           Icons.error,
      //         ),
      //         fit: BoxFit.cover,
      //         width: Get.width,
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 20,
      //     ),
      //     Text(
      //       '${widget.extraGuides.heading}',
      //       maxLines: 1,
      //       overflow: TextOverflow.ellipsis,
      //       style: kBlackDarkLargeStyle,
      //     ),
      //     const SizedBox(
      //       height: 6,
      //     ),
      //     Text(
      //       '${widget.extraGuides.description}',
      //       maxLines: 2,
      //       overflow: TextOverflow.ellipsis,
      //       style: kBlackLightMediumStyle,
      //     ),
      //     const SizedBox(
      //       height: 5,
      //     ),
      //     const Divider(thickness: 0.30),
      //     const SizedBox(
      //       height: 5,
      //     ),
      //     HtmlWidget(
      //       '${widget.extraGuides.content}',
      //       textStyle: kBlackMediumStyle,
      //       // webViewJs: true,
      //       webView: true,
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildShimmer() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              color: Colors.grey,
              height: 200,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey,
            height: 20,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 6),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey,
            height: 20,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 5),
        const Divider(thickness: 0.30),
        const SizedBox(height: 5),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey,
            height: 100,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            widget.extraGuides.image ?? '',
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.error,
            ),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.extraGuides.heading ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: kBlackDarkLargeStyle,
        ),
        const SizedBox(height: 6),
        Text(
          widget.extraGuides.description ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: kBlackLightMediumStyle,
        ),
        const SizedBox(height: 5),
        const Divider(thickness: 0.30),
        const SizedBox(height: 5),
        HtmlWidget(
          widget.extraGuides.content ?? '',
          textStyle: kBlackMediumStyle,
          webView: true,
        ),
      ],
    );
  }
}
