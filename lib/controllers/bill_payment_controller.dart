import 'package:get/get.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_categories.dart';

import 'package:parrotpos/services/remote_service.dart';

class BillPaymentController extends GetxController {
  final billPaymentCategories = BillPaymentCategories().obs;
  // final billPaymentProducts = BillPaymentProducts().obs;

  final isFetchingCategories = false.obs;
  final isFetchingProducts = false.obs;

  getBillPaymentCategories(Map map) async {
    isFetchingCategories(true);
    var res = await RemoteService.getBillPaymentCategories(map);

    if (res.status == 200) {
      billPaymentCategories.update((val) {
        val!.categories = res.categories;
        val.message = res.message;
        val.status = res.status;
      });

      // getBillPaymentProducts({
      //   "category_id": billPaymentCategories.value.categories![0].categoryId,
      //   "country": "MY",
      // });

      isFetchingCategories(false);
    } else {
      billPaymentCategories.update((val) {
        val!.message = res.message;
        val.status = res.status;
      });
      isFetchingCategories(false);
    }
  }

  // getBillPaymentProducts(Map map) async {
  //   isFetchingProducts(true);
  //   billPaymentProducts.update((val) {
  //     val!.products = [];
  //     val.message = '';
  //     val.status = 200;
  //   });

  //   var res = await RemoteService.getBillPaymentProducts(map);

  //   if (res.status == 200) {
  //     billPaymentProducts.update((val) {
  //       val!.products = res.products;
  //       val.message = res.message;
  //       val.status = res.status;
  //     });

  //     isFetchingProducts(false);
  //   } else {
  //     billPaymentProducts.update((val) {
  //       val!.message = res.message;
  //       val.status = res.status;
  //     });
  //     isFetchingProducts(false);
  //   }
  // }

  Future<BillPaymentAmounts> getBillPaymentAmounts(Map map) async {
    var res = await RemoteService.getBillPaymentAmounts(map);
    return res;
  }

  Future<String?> initiateBillPayment(Map map) async {
    var res = await RemoteService.initiateBillPayment(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }
}
