import 'package:get/get.dart';

import 'package:parrotpos/models/donation/donation.dart';

import 'package:parrotpos/services/remote_service.dart';

class DonationController extends GetxController {
  final donation = Donation().obs;
  final isFetching = false.obs;

  getDonation() async {
    isFetching(true);
    var res = await RemoteService.getDonation();

    if (res.status == 200) {
      donation.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });
      // donation.value.data!.totalDonate = "5000";
      // donation.value.data!.userTotalDonate = "1000";
      isFetching(false);
    } else {
      donation.update((val) {
        val!.data = null;
        val.message = res.message;
        val.status = res.status;
      });
      isFetching(false);
    }
  }
}
