import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:parrotpos/models/user_profile/user_profile.dart';

import '../controllers/user_profile_controller.dart';
import '../style/style.dart';

class PromotionsDetailScreen extends StatefulWidget {
  final Promotions extraGuides;
  const PromotionsDetailScreen({Key? key, required this.extraGuides})
      : super(key: key);

  @override
  State<PromotionsDetailScreen> createState() => _PromotionsDetailScreenState();
}

class _PromotionsDetailScreenState extends State<PromotionsDetailScreen> {
  UserProfileController userProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          // '${widget.extraGuides.name}',
          'Promotion',
          style: kBlackLargeStyle,
        ),
      ),
      body: ListView(
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
              width: Get.width,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${widget.extraGuides.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kBlackDarkLargeStyle,
          ),
          // const SizedBox(
          //   height: 6,
          // ),
          // Text(
          //   '${widget.extraGuides.description}',
          //   maxLines: 2,
          //   overflow: TextOverflow.ellipsis,
          //   style: kBlackLightMediumStyle,
          // ),
          const SizedBox(
            height: 5,
          ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 5,
          ),
          // Html(
          //   data: widget.extraGuides.description,
          // ),
          HtmlWidget(
            '${widget.extraGuides.description}',
            textStyle: kBlackMediumStyle,
            // webViewJs: true,
            webView: true,
          ),
        ],
      ),
    );
  }
}
