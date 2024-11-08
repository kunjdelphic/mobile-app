import 'dart:developer';

import 'package:get/get.dart';
import 'package:parrotpos/models/wallet/bank_list.dart';
import 'package:parrotpos/models/wallet/day_referral_earning.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/models/wallet/earning_wallet.dart';
import 'package:parrotpos/models/wallet/main_wallet_reload.dart';
import 'package:parrotpos/models/wallet/product_transaction_history.dart';
import 'package:parrotpos/models/wallet/send_money_recent_list.dart';
import 'package:parrotpos/models/wallet/transaction_history.dart';
import 'package:parrotpos/models/wallet/transaction_history_filter_products.dart';
import 'package:parrotpos/models/wallet/wallet_balance.dart';

import 'package:parrotpos/services/remote_service.dart';

class WalletController extends GetxController {
  final mainWalletReload = MainWalletReload().obs;
  final walletBalance = WalletBalance().obs;
  final sendMoneyRecentList = SendMoneyRecentList().obs;
  final earningHistory = EarningHistory().obs;
  final earningWallet = EarningWallet().obs;
  final transactionHistory = TransactionHistory().obs;
  final transactionHistoryFilter = TransactionHistoryFilterProducts().obs;

  final isFetching = false.obs;
  final isFetchingEarningHistory = true.obs;
  final isFetchingEarningWallet = false.obs;
  final isFetchingTransactionHistory = false.obs;
  final isFetchingWalletBal = false.obs;
  final isFetchingRecentList = false.obs;
  final isFetchingTransactionHistoryFilterProducts = false.obs;
  final pageNumberForEarningHistory = 0.obs;
  final pageNumberForTransactionHistory = 0.obs;

  Future<BankList> getAllBankList(Map map) async {
    var res = await RemoteService.getAllBankList(map);
    return res;
  }

  Future<ProductTransactionHistory> getProductTransactionHistory(Map map) async {
    var res = await RemoteService.getProductTransactionHistory(map);
    return res;
  }

  Future<DayReferralEarning> getDayReferralEarning(Map map) async {
    var res = await RemoteService.getDayReferralEarning(map);
    return res;
  }

  Future<String?> addBankToUserList(Map map) async {
    var res = await RemoteService.addBankToUserList(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> removeBankFromUserList(Map map) async {
    var res = await RemoteService.removeBankFromUserList(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  getMainWalletReload(Map map) async {
    isFetching(true);
    var res = await RemoteService.getMainWalletReload(map);

    if (res.status == 200) {
      mainWalletReload.update((val) {
        val!.banks = res.banks;
        val.minReloadAmount = res.minReloadAmount;
        val.userDetails = res.userDetails;
        val.message = res.message;
        val.status = res.status;
      });

      isFetching(false);
    } else {
      isFetching(false);
    }
  }

  getWalletBalance(Map map) async {
    isFetchingWalletBal(true);
    var res = await RemoteService.getWalletBalance(map);

    if (res.status == 200) {
      walletBalance.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });

      isFetchingWalletBal(false);
    } else {
      isFetchingWalletBal(false);
    }
  }

  updateMainWalletReload(Map map) async {
    var res = await RemoteService.getMainWalletReload(map);

    if (res.status == 200) {
      mainWalletReload.update((val) {
        val!.banks = res.banks;
        val.minReloadAmount = res.minReloadAmount;
        val.userDetails = res.userDetails;
        val.message = res.message;
        val.status = res.status;
      });
    }
  }

  updateWalletBalance(Map map) async {
    var res = await RemoteService.getWalletBalance(map);

    if (res.status == 200) {
      walletBalance.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });
    }
  }

  Future addAmountToMainWallet(Map map) async {
    var res = await RemoteService.addAmountToMainWallet(map);
    return res;
    // if (res["status"] == 200) {
    //   return "";
    // } else {
    //   return res['message'];
    // }
  }

  getSendMoneyRecentList(Map map) async {
    isFetchingRecentList(true);
    var res = await RemoteService.getSendMoneyRecentList(map);
    print("SEND MONEY :: ");
    print(res.message);
    print(res.status);
    print(res.data);
    if (res.status == 200) {
      sendMoneyRecentList.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });

      isFetchingRecentList(false);
    } else {
      sendMoneyRecentList.update((val) {
        val!.data = res.data;
        val.message = res.message;
        val.status = res.status;
      });
      isFetchingRecentList(false);
    }
  }

  Future<String?> sendMoney(Map map) async {
    var res = await RemoteService.sendMoney(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String> getMainWalletReloadNote() async {
    var res = await RemoteService.getMainWalletReloadNote();
    return res['message'];
  }

  final walletReloadInfoModel = WalletReloadInfoModel().obs;
  Future<String> getFetchMainWalletReloadInfo() async {
    var res = await RemoteService.getFetchMainWalletReloadInfo();
    walletReloadInfoModel.value = WalletReloadInfoModel.fromJson(res);
    return res['message'];
  }

  Future<String?> removeRecentFromSendMoney(Map map) async {
    var res = await RemoteService.removeRecentFromSendMoney(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  Future<String?> transferToMainWallet(Map map) async {
    var res = await RemoteService.transferToMainWallet(map);
    if (res["status"] == 200) {
      return "";
    } else {
      return res['message'];
    }
  }

  getEarningHistory({
    bool refreshing = false,
  }) async {
    log(pageNumberForEarningHistory.value.toString() + 'page for earning,.........');
    print("-----------------------------------");

    print("${refreshing}");
    refreshing = false;
    print("-----------------------------------");
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   isFetchingEarningHistory(true);
    // });
    isFetchingEarningHistory(true);

    var res = await RemoteService.getEarningHistory({'page_no': pageNumberForEarningHistory.value}, refreshing: refreshing);
    log("Res***************** ${res.data}");
    log("Res***************** ${res.status}");
    log("Res***************** ${res.message}");
    if (!refreshing) {
      if (res.status == 200) {
        earningHistory.update((val) {
          val!.message = res.message;
          val.status = res.status;
          if (pageNumberForEarningHistory.value == 0) {
            val.data = res.data;
          } else {
            val.data!.addAll(res.data!.toList());
          }
        });

        isFetchingEarningHistory(false);
        // pageNumberForEarningHistory.value++;
      } else {
        earningHistory.update((val) {
          val!.message = res.message;
          val.status = res.status;
          val.data = res.data;
        });
        isFetchingEarningHistory(false);
      }
    }
    //  else {
    //   log('updating earning');
    //   earningHistory.update((val) {
    //     val!.message = res.message;
    //     val.status = res.status;
    //     if (val.data != null && res.data!.isNotEmpty) {
    //       for (var i = 0; i < res.data!.length; i++) {
    //         log('flow2');
    //         val.data![val.data!.indexWhere((element) =>
    //                 element.transactionId == res.data![i].transactionId)] =
    //             res.data![i];
    //       }
    //     }
    //   });
    //   isFetchingEarningHistory(false);
    // }
  }

  getEarningHistorySocket() {
    RemoteService.getEarningHistorySocket();
  }

  getTransactionHistorySocket() {
    RemoteService.getTransactionHistorySocket();
  }

  getEarningWallet(Map map) async {
    isFetchingEarningWallet(true);
    var res = await RemoteService.getEarningWallet(map);

    if (res.status == 200) {
      earningWallet.update((val) {
        val!.message = res.message;
        val.status = res.status;
        val.data = res.data;
      });

      isFetchingEarningWallet(false);
    } else {
      isFetchingEarningWallet(false);

      earningWallet.update((val) {
        val!.message = res.message;
        val.status = res.status;
        val.data = res.data;
      });
    }
  }

  getTransactionHistory(Map map, {bool refreshing = false}) async {
    refreshing == true ? refreshing = false : null;
    isFetchingTransactionHistory(true);
    log('page n---------------------------------------${pageNumberForTransactionHistory.value.toString()}');
    var res = await RemoteService.getTransactionHistory({'page_no': pageNumberForTransactionHistory.value}, refreshing: refreshing);
    log(res.data!.length.toString());
    log("loggin before refresh called ........... $refreshing");
    if (refreshing) {
      transactionHistory.update((val) {
        val!.message = res.message;
        val.status = res.status;

        for (var i = 0; i < res.data!.length; i++) {
          log('flow2');
          val.data![val.data!.indexWhere((element) => element.transactionId == res.data![i].transactionId)] = res.data![i];
        }
      });
      isFetchingTransactionHistory(false);
    } else {
      if (res.status == 200) {
        transactionHistory.update((val) {
          val!.message = res.message;
          if (pageNumberForTransactionHistory.value == 0) {
            val.data = res.data;
            val.status = res.status;
          } else {
            val.data!.addAll(res.data!.toList());
          }
        });
        // if (res.data!.isNotEmpty) {
        //   pageNumberForTransactionHistory.value++;
        // }

        isFetchingTransactionHistory(false);
      } else {
        isFetchingTransactionHistory(false);

        transactionHistory.update((val) {
          val!.message = res.message;
          val.status = res.status;
          val.data = res.data;
        });
      }
    }
  }

  getTransactionHistoryFilterProducts(Map map) async {
    isFetchingTransactionHistoryFilterProducts(true);
    var res = await RemoteService.getTransactionHistoryFilterProducts(map);

    if (res.status == 200) {
      transactionHistoryFilter.update((val) {
        val!.message = res.message;
        val.products = res.products;
        val.status = res.status;
      });

      isFetchingTransactionHistoryFilterProducts(false);
    } else {
      transactionHistoryFilter.update((val) {
        val!.message = res.message;
        val.status = res.status;
        val.products = res.products;
      });
      isFetchingTransactionHistoryFilterProducts(false);
    }
  }
}
