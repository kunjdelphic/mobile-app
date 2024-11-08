import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/wallet_controller.dart';
import '../../../style/style.dart';

class WalletReloadInfo extends StatefulWidget {
  const WalletReloadInfo({super.key});

  @override
  State<WalletReloadInfo> createState() => _WalletReloadInfoState();
}

class _WalletReloadInfoState extends State<WalletReloadInfo> {
  WalletController walletController = Get.find();

  @override
  void initState() {
    super.initState();
    getNote();
  }

  Future<String> getNote() async {
    String res = await walletController.getFetchMainWalletReloadInfo();
    return res;
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
          "Wallet Reload Info",
          style: kBlackLargeStyle,
        ),
      ),
      body: StreamBuilder(
          stream: walletController.walletReloadInfoModel.stream,
          builder: (context, snapshot) {
            return Column(
              children: [
                Text(
                  "${walletController.walletReloadInfoModel.value.message}",
                  style: kBlackLargeStyle,
                )
              ],
            ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.04);
          }),
    );
  }
}
