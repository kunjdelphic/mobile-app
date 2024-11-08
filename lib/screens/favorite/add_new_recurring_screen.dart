import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/favorite/add_recurring_item.dart';

class AddNewRecurringScreen extends StatefulWidget {
  const AddNewRecurringScreen({Key? key}) : super(key: key);

  @override
  State<AddNewRecurringScreen> createState() => _AddNewRecurringScreenState();
}

class _AddNewRecurringScreenState extends State<AddNewRecurringScreen> {
  FavoriteController favoriteController = Get.find();

  @override
  void initState() {
    favoriteController.getRecurring({});
    super.initState();
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
          'Recurring',
          style: kBlackLargeStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/favorite/ic_recurring.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Recurring Payment',
                      style: kBlackDarkMediumStyle,
                    ),
                    Text(
                      'Choose from the favorites below:',
                      style: kBlackSmallLightMediumStyle,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(thickness: 0.30),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GetX<FavoriteController>(
                init: favoriteController,
                builder: (controller) {
                  if (controller.isFetchingRecurring.value) {
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
                  if (controller.recurring.value.data == null) {
                    return Center(
                      child: SizedBox(
                        height: 35,
                        child: Text(
                          controller.recurring.value.message!,
                          style: kBlackSmallMediumStyle,
                        ),
                      ),
                    );
                  }

                  if (controller.recurring.value.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'You do not have any favorite bills at the moment.',
                        textAlign: TextAlign.center,
                        style: kBlackLightMediumStyle,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return AddRecurringItem(
                        recurringData: controller.recurring.value.data![index],
                      );
                    },
                    itemCount: controller.recurring.value.data!.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
