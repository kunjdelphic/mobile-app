import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_screen.dart';

import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/wallet/wallet_transaction_item.dart';

class WalletBalanceScreen extends StatefulWidget {
  const WalletBalanceScreen({Key? key}) : super(key: key);

  @override
  _WalletBalanceScreenState createState() => _WalletBalanceScreenState();
}

class _WalletBalanceScreenState extends State<WalletBalanceScreen> {
  final WalletController walletController = Get.find();

  @override
  void initState() {
    super.initState();

    walletController.getWalletBalance({});
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
          "Wallet Balance",
          style: kBlackLargeStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          walletController.getWalletBalance({});

          return;
        },
        child: GetX<WalletController>(
          init: walletController,
          builder: (controller) {
            if (controller.isFetchingWalletBal.value ||
                controller.walletBalance.value.data == null) {
              return const Center(
                child: SizedBox(
                  height: 25,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                    colors: [
                      kAccentColor,
                    ],
                  ),
                ),
              );
            }
            if (controller.walletBalance.value.status != 200) {
              return Center(
                child: SizedBox(
                  height: 35,
                  child: Text(
                    controller.walletBalance.value.message!,
                    style: kBlackSmallMediumStyle,
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                Container(
                  // height: 250,
                  width: Get.width * 0.9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kColorPrimary,
                        kColorPrimaryDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Image.asset(
                          'assets/images/wallet/wallet_bg_shapes.png',
                          width: Get.width * 0.3,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Main Wallet',
                                style: kWhiteDarkMediumStyle,
                              ),
                              Text(
                                'Balance',
                                style: kWhiteDarkMediumStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${Config().currencyCode} ${controller.walletBalance.value.data!.mainWalletAmount}',
                                style: kWhiteDarkSuperLargeStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            '${controller.walletBalance.value.data!.name}',
                            style: kWhiteMediumStyle,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                'assets/images/logo/logo_full.svg',
                                width: Get.width * 0.25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const MainWalletReloadScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kWhite,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/reload_wallet.svg',
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Reload Wallet',
                                        style: kBlackMediumStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(thickness: 0.30),
                const SizedBox(
                  height: 10,
                ),
                controller.walletBalance.value.data!.transactions!.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions found!',
                          style: kBlackSmallMediumStyle,
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return WalletTransactionItem(
                            walletTransaction: controller
                                .walletBalance.value.data!.transactions![index],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                        itemCount: controller
                            .walletBalance.value.data!.transactions!.length,
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
