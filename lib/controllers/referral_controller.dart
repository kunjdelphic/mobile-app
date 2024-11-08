import 'package:get/get.dart';
import 'package:parrotpos/models/referral/my_level_referral_users.dart';
import 'package:parrotpos/models/referral/my_referral.dart';
import 'package:parrotpos/models/referral/todays_referral_earnings.dart';
import 'package:parrotpos/models/signup/signup_referral.dart';

import 'package:parrotpos/services/remote_service.dart';

class ReferralController extends GetxController {
  final myReferral = MyReferral().obs;
  final isFetching = false.obs;
  final isFetchingLevelUsers = false.obs;
  final isFetchingTodaysReferralEarnings = false.obs;
  final todaysReferralEarnings = TodaysReferralEarnings().obs;
  String? referralLink = '';

  @override
  onReady() {
    getMyReferralLink();
  }

  getMyReferralLink() async {
    var res = await RemoteService.shareReferral();
    //  print(res);
    
    if (res['status'] == 200) {
      referralLink = res["data"]["referral_link"];
    }
  }

  getMyReferral(Map map) async {
    isFetching(true);
    var res = await RemoteService.getMyReferral({});

    if (res.status == 200) {
      myReferral.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });

      isFetching(false);
    } else {
      isFetching(false);
    }
  }

  Future<TodaysReferralEarnings?> getTodaysReferralEarnings(Map map,
      {bool refreshing = false, int index = 1}) async {
    isFetchingTodaysReferralEarnings(!refreshing);
    var res = await RemoteService.getTodaysReferralEarnings(map);

    if (refreshing) {
      if (res.status == 200) {
        // todaysReferralEarnings.update((val) {
        // switch (index) {
        //   case 1:
        //     val!.data!.levelWise!.level1!.transactions!
        //         .addAll(res.data!.levelWise!.level1!.transactions!);
        //          val.message = res.message;
        // val.status = res.status;
        //     break;
        //   case 2:
        //     val!.data!.levelWise!.level2!.transactions!
        //         .addAll(res.data!.levelWise!.level2!.transactions!); val.message = res.message;
        // val.status = res.status;
        //     break;
        //   case 3:
        //     val!.data!.levelWise!.level3!.transactions!
        //         .addAll(res.data!.levelWise!.level3!.transactions!); val.message = res.message;
        // val.status = res.status;
        //     break;
        //   case 4:
        //     val!.data!.levelWise!.level4!.transactions!
        //         .addAll(res.data!.levelWise!.level4!.transactions!); val.message = res.message;
        // val.status = res.status;
        //     break;
        //   case 5:
        //     val!.data!.levelWise!.level5!.transactions!
        //         .addAll(res.data!.levelWise!.level5!.transactions!); val.message = res.message;
        // val.status = res.status;
        //     break;
        //   default:
        // }
        // });

        isFetchingTodaysReferralEarnings(false);
        return res;
      } else {
        isFetchingTodaysReferralEarnings(false);
      }
    } else {
      if (res.status == 200) {
        todaysReferralEarnings.update((val) {
          val!.data = res.data;
          val.message = res.message;
          val.status = res.status;
        });

        isFetchingTodaysReferralEarnings(false);
      } else {
        isFetchingTodaysReferralEarnings(false);
      }
      return res;
    }
    return null;
  }

  Future<MyLevelReferralUsers> getMyLevelReferralUsers(Map map) async {
    var res = await RemoteService.getMyLevelReferralUsers(map);

    return res;
  }

  Future<SignupReferral> getReferralDetails(Map map) async {
    var res = await RemoteService.getReferralDetails(map);
    if (res["status"] == 200) {
      return SignupReferral.fromMap(res["referral"]);
    } else {
      return SignupReferral(
        email: '',
        name: '',
        profileImage: '',
        message: res['message'],
      );
    }
  }
}
