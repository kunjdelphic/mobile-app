import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class MainWalletReloadWebScreen extends StatefulWidget {
  final String url;

  const MainWalletReloadWebScreen({
    super.key,
    required this.url,
  });

  @override
  _MainWalletReloadWebScreenState createState() =>
      _MainWalletReloadWebScreenState();
}

class _MainWalletReloadWebScreenState extends State<MainWalletReloadWebScreen> {
  bool status = false;
  bool pageLoading = false;
  WalletController walletController = Get.find();
  UserProfileController userProfileController = Get.find();
  static var client = http.Client();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
          "Payment",
          style: kBlackLargeStyle,
        ),
      ),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            onWebViewCreated: (WebViewController webViewController) {
              // _controller.complete(webViewController);
            },

            gestureNavigationEnabled: false,
            onPageStarted: (String url) {
              print('STARTED LOADING :: $url');
              setState(() {
                pageLoading = true;
              });
            },
            onPageFinished: (String url) async {
              print('FINISHED LOADING :: $url');

              setState(() {
                pageLoading = false;
              });

              http.Response res = await client.get(
                Uri.parse(url),
              );

              print(res.statusCode);
              print(res.body);

              if (res.body.contains("Your Payment is Failed")) {
                //failed
                print('FAILED PAYMENT');
                status = false;
                walletController.getTransactionHistory({}, refreshing: true);

                // walletController.updateMainWalletReload({});
                // walletController.updateWalletBalance({});

                // userProfileController.getUserDetails();

                Get.back(
                  result: false,
                );
              } else if (res.body.contains("Your Payment Is Successfull")) {
                //success
                print('SUCCESSFUL PAYMENT');

                status = true;

                userProfileController.updateUserDetails();

                walletController.updateMainWalletReload({});
                walletController.updateWalletBalance({});
                walletController.getTransactionHistory({}, refreshing: true);
                walletController.getEarningHistory(refreshing: true);

                log('all done............');

                Get.back(
                  result: true,
                );
              }

              // if (url.contains("wallet/wallet-reload-status?")) {

              // }
            },
            onWebResourceError: (error) {
              print(error);
              Center(
                child: Text(
                  "Facing Some Issue!",
                  style: kBlackMediumStyle,
                ),
              );
            },
            // gestureNavigationEnabled: true,
          ),
          pageLoading
              ? const Center(
                  child: SizedBox(
                    height: 25,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScalePulseOut,
                      colors: [
                        kAccentColor,
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
