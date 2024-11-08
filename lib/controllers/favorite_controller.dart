import 'dart:async';

import 'package:get/get.dart';

import 'package:parrotpos/models/favorite/all_favorites.dart';
import 'package:parrotpos/models/favorite/all_recurring.dart';
import 'package:parrotpos/models/favorite/favorite_categories.dart';
import 'package:parrotpos/models/favorite/outstanding_bill.dart';
import 'package:parrotpos/models/favorite/recurring.dart';

import 'package:parrotpos/services/remote_service.dart';

class FavoriteController extends GetxController {
  final favoriteCategories = FavoriteCategories().obs;
  // final favoriteProducts = FavoriteProducts().obs;
  Rx<AllFavorites>? allFavorites = AllFavorites().obs;
  Rx<AllFavorites>? tempAllFavorites = AllFavorites().obs;
  final recurring = Recurring().obs;
  final allRecurring = AllRecurring().obs;
  RxBool reloadShimmer = false.obs;

  final isFetchingCategories = false.obs;
  final isFetchingProducts = false.obs;
  final isFetchingFavorites = false.obs;
  final isFetchingRecurring = false.obs;
  final isFetchingAllRecurring = false.obs;
  final pageNumber = 0.obs;
  final firstTimeLoading = true.obs;
  RxBool reload = false.obs;
  int? resetIndex;
  @override
  onReady() {
    Timer.periodic(const Duration(seconds: 10), (t) async {
      if (allFavorites!.value.data != null) {
        for (var element in allFavorites!.value.data!) {
          if (element.lastTransactionStatus == 'PENDING') {
            reload = true.obs;

            // print("object");
          }
        }
        List<int> indexs = [];
        for (int i = 0; i < allFavorites!.value.data!.length; i++) {
          if (allFavorites!.value.data![i].lastTransactionStatus == 'PENDING') {
            // print('index $i');
            indexs.add(i);
          }
        }
        //  print(indexs);
        if (reload.value) {
          tempAllFavorites!.value = await RemoteService().refresFavourite(indexs[0] ~/ 10);
          allFavorites!.update((val) {
            val!.data![indexs[0]] = tempAllFavorites!.value.data![indexs[0] % 10];
          });
          // tempAllFavorites!.value = await RemoteService().refresFavourite(0);
          // if (allFavorites!.value.data!.length ~/ 10 == 1) {
          //   AllFavorites temp1;
          //   temp1 = await RemoteService().refresFavourite(1);
          //   var t1 = tempAllFavorites!.value.data;
          //   var t2 = temp1.data;
          //   var t = [...?t1, ...?t2];
          //   print(t.length);
          //   tempAllFavorites!.value.data = t;
          // }
          // print('${pageNumber.value} page ');

          // AllFavorites temp;
          // for (int i = 0;
          //     i <= (allFavorites!.value.data!.length ~/ 10) + 1;
          //     i++) {
          //   print('index $i');
          //   temp = await RemoteService().refresFavourite(i);
          //   if (i == 0) {
          //     tempAllFavorites!.value = temp;
          //   } else {
          //     tempAllFavorites!.value.data!
          //         .addAll(tempAllFavorites!.value.data!.toList());
          //   }
          // }
          // tempAllFavorites!.value.data!.toSet().toList();
          // allFavorites!.value.data = tempAllFavorites!.value.data;
          //     print(
          //         "all fav : ${allFavorites!.value.data!.length} :${tempAllFavorites!.value.data!.length}");
          //     for (int i = 0; i < tempAllFavorites!.value.data!.length; i++) {
          //       for (int j = 0; j < allFavorites!.value.data!.length; j++) {
          //         if (allFavorites!.value.data![j].favoriteId ==
          //             tempAllFavorites!.value.data![i].favoriteId) {
          //           print(i);
          //           allFavorites!.value.data![j].lastTransactionStatus =
          //               tempAllFavorites!.value.data![i].lastTransactionStatus;
          //         }
          //       }
          //     }
          //   }
          // }
          // allFavorites!.value = allFavorites!.value;
          reload = false.obs;
          //  allFavorites!.value = allFavorites!.value;
          //  pageNumber.value = 0;
        }
        // print(tempAllFavorites!.value.message.toString() + 'hum dono');
      }
    });
  }

  getAllFavorites(Map map, {bool refreshing = false, Function? callback}) async {
    isFetchingFavorites(true);
    var res = await RemoteService.getAllFavorites({'page_no': pageNumber.value}, refreshing: refreshing);
    // log('fav api called ${res.data!.length} lage ${pageNumber.value}');

    if (refreshing) {
      allFavorites!.update((val) {
        val!.message = res.message;
        val.status = res.status;
        if (val.data != null) {
          val.data!.insert(0, res.data!.first);
        } else {
          val.data = [res.data!.first];
        }
      });
      isFetchingFavorites(false);
      if (callback != null) {
        callback();
      }
    } else {
      if (res.status == 200) {
        allFavorites!.update((val) {
          if (pageNumber.value == 0) {
            val!.data = res.data;
            firstTimeLoading(false);
          } else {
            val!.data!.addAll(res.data!.toList());
          }
          val.message = res.message;
          val.status = res.status;
        });

        isFetchingFavorites(false);
      } else {
        allFavorites!.update((val) {
          val!.message = res.message;
          val.status = res.status;
        });
        isFetchingFavorites(false);
      }
    }
    // allFavorites!.value.data?.forEach((element) {
    //   // print(
    //   //     '${element.lastTransactionStatus} main hu status :${element.lastTransactionId}');
    // });
  }

  getAllRecurring(Map map) async {
    isFetchingAllRecurring(true);
    var res = await RemoteService.getAllRecurring(map);

    if (res.status == 200) {
      allRecurring.update((val) {
        val!.recurring = res.recurring;
        val.message = res.message;
        val.status = res.status;
      });

      isFetchingAllRecurring(false);
    } else {
      allRecurring.update((val) {
        val!.message = res.message;
        val.status = res.status;
      });
      isFetchingAllRecurring(false);
    }
  }

  getRecurring(Map map) async {
    isFetchingRecurring(true);
    var res = await RemoteService.getRecurring(map);

    if (res.status == 200) {
      recurring.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });

      isFetchingRecurring(false);
    } else {
      recurring.update((val) {
        val!.message = res.message;
        val.status = res.status;
      });
      isFetchingRecurring(false);
    }
  }

  getFavoriteCategories(Map map, {Function? callBack}) async {
    isFetchingCategories(true);
    var res = await RemoteService.getFavoriteCategories(map);

    if (res.status == 200) {
      favoriteCategories.update((val) {
        val!.categories = res.categories;
        val.message = res.message;
        val.status = res.status;
      });

      if (callBack != null) {
        callBack();
      }

      // getFavoriteProducts({
      //   "category_name": favoriteCategories.value.products![0],
      // });

      isFetchingCategories(false);
    } else {
      favoriteCategories.update((val) {
        val!.message = res.message;
        val.status = res.status;
        val.categories = res.categories;
      });
      isFetchingCategories(false);
    }
  }

  // getFavoriteProducts(Map map) async {
  //   isFetchingProducts(true);

  //   var res = await RemoteService.getFavoriteProducts(map);

  //   if (res.status == 200) {
  //     favoriteProducts.update((val) {
  //       val!.products = res.products;
  //       val.message = res.message;
  //       val.status = res.status;
  //     });

  //     isFetchingProducts(false);
  //   } else {
  //     favoriteProducts.update((val) {
  //       val!.message = res.message;
  //       val.status = res.status;
  //     });
  //     isFetchingProducts(false);
  //   }
  // }

  Future<Map<String, dynamic>?> addNewFavorite(Map map) async {
    var res = await RemoteService.addNewFavorite(map);
    return res;
    // return null;
  }

  Future<String?> editFavorite(Map map) async {
    var res = await RemoteService.editFavorite(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> removeFavorite(Map map) async {
    var res = await RemoteService.removeFavorite(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> updateFavoriteOrder(Map map) async {
    var res = await RemoteService.updateFavoriteOrder(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> addNewRecurring(Map map) async {
    var res = await RemoteService.addNewRecurring(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> editRecurring(Map map) async {
    var res = await RemoteService.editRecurring(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> removeRecurring(Map map) async {
    var res = await RemoteService.removeRecurring(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> updateRecurringOrder(Map map) async {
    var res = await RemoteService.updateRecurringOrder(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<OutstandingBill> getOutstandingBill(Map map) async {
    var res = await RemoteService.getOutstandingBill(map);
    print("getOutstandingBill +++++++ ${res}");
    return res;
  }

  // Future<String?> initiateBillPayment(Map map) async {
  //   var res = await RemoteService.initiateBillPayment(map);
  //   if (res["status"] == 200) {
  //     return "";
  //   } else {
  //     return res['message'];
  //   }
  // }
}

// class DummyData {
//   String? favoriteId = "          ";
//   String? type = "     ";
//   String? nickName = "     ";
//   String? lastUpdated = "         ";
//   dynamic amount = "        ";
//   dynamic cashback = "              ";
//   String? lastPaidBill = "      ";
//   dynamic order = "       ";
//   String? accountNumber = "     ";
//   String? lastTransactionId = "         ";
//   String? lastTransactionStatus = "        ";
//   String? lastTransactionTimestamp = "        ";
//   bool? reminder = true;
//   bool? recurring = true;
//   bool? hasOutstandingAmount = true;
//   String? productId = "   ";
//   String? productName = "       ";
//   String? productImage = "         ";
//   String? serviceId = "   ";
//   String? categoryId = "    ";
//   String? country = "        ";
//   String? currency = "     ";
//   String? helpText = "    ";
//   // List<FieldsRequired>? fieldsRequired;
//   String? amountType = "   ";
//   dynamic maximumAmount = "    ";
//   dynamic minimumAmount = "   ";
//   List<Amounts>? amounts = [];
// }
