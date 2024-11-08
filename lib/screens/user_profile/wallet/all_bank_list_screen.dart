import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/wallet/bank_list.dart';

import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';

class AllBankListScreen extends StatefulWidget {
  const AllBankListScreen({Key? key}) : super(key: key);

  @override
  _WalletBalanceScreenState createState() => _WalletBalanceScreenState();
}

class _WalletBalanceScreenState extends State<AllBankListScreen> {
  final WalletController walletController = Get.find();
  late BankList bankList;

  // @override
  // void initState() {
  //   getAllBankList();

  //   super.initState();
  // }

  Future<BankList> getAllBankList() async {
    var res = await walletController.getAllBankList({
      "country": "MY",
    });
    if (res.status == 200) {
      //got it
      bankList = res;
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: '${res.message}');
    }

    return bankList;
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
          "Main Wallet Reload ",
          style: kBlackLargeStyle,
        ),
      ),
      body: FutureBuilder<BankList>(
          future: getAllBankList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
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
            if (snapshot.data!.banks!.isEmpty) {
              return Center(
                child: Text(
                  'No Banks Found!',
                  style: kBlackMediumStyle,
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.8,
              ),
              itemCount: snapshot.data!.banks!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    processingDialog(title: 'Adding bank to user list...\nPlease wait', context: context);
                    var res = await walletController.addBankToUserList({
                      'fpx_bank_id': snapshot.data!.banks![index].fpxBankId,
                    });

                    Get.back();
                    if (res!.isEmpty) {
                      //added
                      walletController.updateMainWalletReload({});
                      Get.back(result: true);
                    } else {
                      errorSnackbar(title: 'Failed', subtitle: res);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: snapshot.data!.banks![index].logo?.isNotEmpty ?? false
                          ? CachedNetworkImage(
                              imageUrl: snapshot.data!.banks![index].logo ?? '',
                              placeholder: (context, url) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    '${snapshot.data!.banks![index].name}',
                                    textAlign: TextAlign.center,
                                    style: kBlackExtraSmallLightMediumStyle.copyWith(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/logo/parrot_logo.png',
                                  fit: BoxFit.contain,
                                );
                              },
                              fit: BoxFit.cover,
                              width: Get.width,
                            )
                          // CachedNetworkImage(
                          //         imageUrl: snapshot.data!.banks![index].logo ?? '',
                          //         placeholder: (context, url) {
                          //           return Padding(
                          //             padding: const EdgeInsets.only(top: 40),
                          //             child: Text(
                          //               overflow: TextOverflow.ellipsis,
                          //               '${snapshot.data!.banks![index].name}',
                          //               style: kBlackLightMediumStyle,
                          //             ),
                          //           );
                          //         },
                          //         errorWidget: (context, error, stackTrace) => Image.asset(
                          //           'assets/images/logo/parrot_logo.png',
                          //           fit: BoxFit.contain,
                          //         ),
                          //         fit: BoxFit.cover,
                          //         width: Get.width,
                          //       )
                          // Image.network(
                          //   '${snapshot.data!.banks![index].logo}',
                          //   errorBuilder: (context, error, stackTrace) => Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       const Icon(
                          //         Icons.image_not_supported,
                          //         color: kAccentColor,
                          //         size: 20,
                          //       ),
                          //       const SizedBox(
                          //         height: 4,
                          //       ),
                          //       Text(
                          //         snapshot.data!.banks![index].name!,
                          //         style: kBlackSmallMediumStyle,
                          //       )
                          //     ],
                          //   ),
                          //   width: Get.width * 0.25,
                          // )
                          : Text(
                              '${snapshot.data!.banks![index].name}',
                              overflow: TextOverflow.ellipsis,
                              style: kBlackSmallMediumStyle,
                            ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
