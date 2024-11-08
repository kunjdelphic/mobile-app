import 'package:get/get.dart';
import 'package:parrotpos/models/topup/recent_top_up.dart';
import 'package:parrotpos/models/topup/top_up_amounts.dart';
import 'package:parrotpos/models/topup/top_up_products.dart';

import 'package:parrotpos/services/remote_service.dart';

class TopUpController extends GetxController {
  final topUpProducts = TopUpProducts().obs;
  final recentTopUp = RecentTopUp().obs;

  final isFetchingTopUpProducts = false.obs;
  final isFetchingRecentTopUp = false.obs;

  getTopUpProducts(Map map) async {
    isFetchingTopUpProducts(true);
    var res = await RemoteService.getTopUpProducts(map);

    if (res.status == 200) {
      topUpProducts.update((val) {
        val!.products = res.products;
        val.message = res.message;
        val.status = res.status;
      });

      isFetchingTopUpProducts(false);
    } else {
      topUpProducts.update((val) {
        val!.message = res.message;
        val.status = res.status;
      });
      isFetchingTopUpProducts(false);
    }
  }

  getRecentTopUp(Map map) async {
    isFetchingRecentTopUp(true);
    var res = await RemoteService.getRecentTopUp(map);

    if (res.status == 200) {
      recentTopUp.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });

      isFetchingRecentTopUp(false);
    } else {
      isFetchingRecentTopUp(false);
    }
  }

  Future<TopUpAmounts> getTopUpAmounts(Map map) async {
    var res = await RemoteService.getTopUpAmounts(map);
    return res;
  }

  Future<String?> removeRecentTopUp(Map map) async {
    var res = await RemoteService.removeRecentTopUp(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> initiateTopUp(Map map) async {
    var res = await RemoteService.initiateTopUp(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }
}
