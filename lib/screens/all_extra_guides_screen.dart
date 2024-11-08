import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/screens/extra_guide_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/user_profile_controller.dart';
import '../style/colors.dart';
import '../style/style.dart';

class AllExtraGuidesScreen extends StatefulWidget {
  const AllExtraGuidesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllExtraGuidesScreen> createState() => _AllExtraGuidesScreenState();
}

class _AllExtraGuidesScreenState extends State<AllExtraGuidesScreen> {
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
          'Extra Guides',
          style: kBlackLargeStyle,
        ),
      ),
      body: GetX<UserProfileController>(
        init: userProfileController,
        builder: (_) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Get.to(
                  () => ExtraGuideDetailScreen(
                    extraGuides: userProfileController.userProfile.value.data!.extraGuides![index],
                  ),
                );
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          userProfileController.userProfile.value.data!.extraGuides![index].image ?? '',
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.error,
                          ),
                          fit: BoxFit.cover,
                          width: Get.width,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${userProfileController.userProfile.value.data!.extraGuides![index].heading}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kBlackDarkLargeStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${userProfileController.userProfile.value.data!.extraGuides![index].description}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kBlackLightMediumStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
            itemCount: userProfileController.userProfile.value.data!.extraGuides!.length,
          );
        },
      ),
    );
  }
}
