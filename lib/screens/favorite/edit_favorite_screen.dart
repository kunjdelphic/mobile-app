import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/favorite/all_favorites.dart';
import 'package:parrotpos/models/favorite/outstanding_bill.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/send_money/contacts_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class EditFavoriteScreen extends StatefulWidget {
  final AllFavoritesData favoriteProduct;
  final int? index;
  const EditFavoriteScreen({Key? key, required this.favoriteProduct, this.index}) : super(key: key);

  @override
  _EditFavoriteScreenState createState() => _EditFavoriteScreenState();
}

class _EditFavoriteScreenState extends State<EditFavoriteScreen> {
  final FavoriteController favoriteController = Get.find();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController accountOwnerController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  OutstandingBill? outstandingBill;
  ButtonState btnState = ButtonState.idle;
  bool isInsertNo = false;
  bool isInsertNickname = false;
  Contact? contact;
  bool isInvalidNo = false;
  Future<OutstandingBill?>? _futureBillPaymentAmts;
  String cashbackAmt = '0.00';
  final UserProfileController userProfileController = Get.find();
  WalletController walletController = Get.find();
  String? reminderType, reminderDate, reminderDay;

  @override
  void initState() {
    super.initState();

    if (widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER')) {
      accountNoController.text = widget.favoriteProduct.accountNumber!;
    }

    if (widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')) {
      phoneNoController.text = widget.favoriteProduct.accountNumber!;
    }

    nicknameController.text = widget.favoriteProduct.nickName!;

    // if (widget.favoriteProduct.reminder!) {
    //   reminderType = widget.favoriteProduct.reminderType!;
    //   if (reminderType == 'Monthly') {
    //     reminderDate = widget.favoriteProduct.reminderDay!.toString();
    //   } else {
    //     reminderDay = Config().weekdays[widget.favoriteProduct.reminderDay!];
    //   }
    // }
  }

  Future<OutstandingBill?> getOutstandingBill(Map map) async {
    if (map.isEmpty) {
      return null;
    }
    var res = await favoriteController.getOutstandingBill(map);
    if (res.status == 200) {
      outstandingBill = res;
      //got it
      return res;
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: '${res.message}');
      return res;
    }
  }

  addNewFavorite() async {
    setState(() {
      btnState = ButtonState.loading;
    });

    print({
      "type": "${widget.favoriteProduct.type}",
      "amount": outstandingBill != null
          ? outstandingBill!.bill!.outstandingAmount!.contains('-')
              ? 0
              : outstandingBill!.bill!.outstandingAmount
          : 0,
      "product_id": "${widget.favoriteProduct.productId}",
      "nick_name": nicknameController.text.trim(),
      "account_number": widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER') ? accountNoController.text.trim() : phoneNoController.text.trim(),
      // "reminder": reminderType != null,
      // "reminder_hour": reminderType != null ? 10 : 0,
      // "reminder_minute": 0,
      // "reminder_type": "$reminderType",
      // "reminder_day": reminderType != null
      //     ? reminderType == 'Monthly'
      //         ? reminderDate
      //         : Config().weekdays.indexOf(reminderDay!)
      //     : 0,
      // "amount": amountController.text.trim(),
      // "product_id": widget.favoriteProduct.productId,
      // "account_number": "+6-${phoneNoController.text.trim()}"
    });

    String? res;

    res = await favoriteController.editFavorite({
      "favorite_id": "${widget.favoriteProduct.favoriteId}",
      "type": "${widget.favoriteProduct.type}",
      "amount": outstandingBill != null
          ? outstandingBill!.bill!.outstandingAmount!.contains('-')
              ? 0
              : outstandingBill!.bill!.outstandingAmount
          : 0,
      "product_id": "${widget.favoriteProduct.productId}",
      "nick_name": nicknameController.text.trim(),
      "account_number": widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER') ? accountNoController.text.trim() : phoneNoController.text.trim(),
      "reminder": reminderType != null,
      "reminder_hour": reminderType != null ? 10 : 0,
      "reminder_minute": 0,
      "reminder_type": "$reminderType",
      "reminder_day": reminderType != null
          ? reminderType == 'Monthly'
              ? reminderDate
              : Config().weekdays.indexOf(reminderDay!)
          : 0,
      // "amount": amountController.text.trim(),
      // "product_id": widget.favoriteProduct.productId,
      // "account_number": "+6-${phoneNoController.text.trim()}"
    });

    setState(() {
      btnState = ButtonState.idle;
    });

    if (res!.isEmpty) {
      //done
      // favoriteController.get
      // showCompletedTopupDialog(
      //     context: context,
      //     onTap: () {
      //       Get.back();
      //       Get.back();
      //       walletController.getTransactionHistory({});
      //       Get.to(() => const TransactionHistoryScreen());
      //     },
      //     onTapFav: () {});
      Get.back();
      successSnackbar(title: 'Success', subtitle: 'Updated the favorite!');

      // favoriteController.getAllFavorites({});
      favoriteController.allFavorites!.value.data![widget.index!].nickName = nicknameController.text;

      favoriteController.allFavorites!.value.data![widget.index!].accountNumber =
          widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER') ? accountNoController.text.trim() : phoneNoController.text.trim();
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: res);
    }
  }

  addReminderSheet() async {
    int selectedReminderType = 0;
    int selectedWeekday = -1;
    int selectedDate = -1;
    bool selectDay = false;
    bool selectMonth = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
            return SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 7,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 1.5,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Reminder type:',
                          style: kBlackDarkMediumStyle,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setBottomSheetState(() {
                                      selectedReminderType = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: selectedReminderType == 0
                                            ? [
                                                kColorPrimary,
                                                kColorPrimaryDark,
                                              ]
                                            : [
                                                const Color(0xffEDEDED),
                                                const Color(0xffEDEDED),
                                              ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Monthly',
                                        overflow: TextOverflow.ellipsis,
                                        style: selectedReminderType == 0 ? kWhiteMediumStyle : kBlackLightMediumStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setBottomSheetState(() {
                                      selectedReminderType = 1;
                                    });
                                  },
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: selectedReminderType == 1
                                            ? [
                                                kColorPrimary,
                                                kColorPrimaryDark,
                                              ]
                                            : [
                                                const Color(0xffEDEDED),
                                                const Color(0xffEDEDED),
                                              ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Weekly',
                                        overflow: TextOverflow.ellipsis,
                                        style: selectedReminderType == 1 ? kWhiteMediumStyle : kBlackLightMediumStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Select date/dates you wish to be notified:',
                          style: kBlackDarkMediumStyle,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        selectedReminderType == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Center(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: Get.width * 0.15,
                                        mainAxisExtent: Get.width * 0.15,
                                        // crossAxisCount: 6,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 0,
                                      ),
                                      itemBuilder: (context, index) => GestureDetector(
                                        onTap: () {
                                          if (index >= 28) {
                                            return;
                                          }
                                          setBottomSheetState(() {
                                            selectedDate = index;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: kWhite,
                                            border: selectedDate == index
                                                ? Border.all(
                                                    color: kColorPrimary,
                                                    width: 1.5,
                                                  )
                                                : const Border(),
                                            gradient: selectedDate == index
                                                ? const LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      kGreenBtnColor1,
                                                      kGreenBtnColor2,
                                                    ],
                                                  )
                                                : null,
                                            boxShadow: [
                                              BoxShadow(
                                                color: selectedDate == index ? Colors.black.withOpacity(0.2) : Colors.transparent,
                                                blurRadius: 6,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: index == 28 || index == 29 || index == 30
                                                  ? kBlackExtraLightMediumStyle
                                                  : selectedDate == index
                                                      ? kWhiteDarkMediumStyle
                                                      : kBlackMediumStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      itemCount: 31,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: SizedBox(
                                      height: 20,
                                      child: selectMonth
                                          ? Text(
                                              'Select Date',
                                              textAlign: TextAlign.end,
                                              style: kRedSmallMediumStyle,
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setBottomSheetState(() {
                                            selectedWeekday = index;
                                          });
                                        },
                                        child: Container(
                                          height: 45,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: selectedWeekday == index ? kColorPrimary : Colors.black.withOpacity(0.2),
                                                blurRadius: 4,
                                                spreadRadius: selectedWeekday == index ? 2 : 1,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              Config().weekdays[index],
                                              overflow: TextOverflow.ellipsis,
                                              style: selectedWeekday == index ? kBlackDarkMediumStyle : kBlackLightMediumStyle,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => const SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: Config().weekdays.length,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: SizedBox(
                                      height: 20,
                                      child: selectDay
                                          ? Text(
                                              'Select Day',
                                              textAlign: TextAlign.end,
                                              style: kRedSmallMediumStyle,
                                            )
                                          : const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        GradientButton(
                          text: 'Continue',
                          width: false,
                          widthSize: Get.width * 0.7,
                          buttonState: ButtonState.idle,
                          onTap: () {
                            if (selectedReminderType == 0) {
                              if (selectedDate == -1) {
                                setBottomSheetState(() {
                                  selectMonth = true;
                                  return;
                                });
                              } else {
                                setBottomSheetState(() {
                                  selectMonth = false;
                                });
                              }
                              reminderType = 'Monthly';
                              reminderDate = '${selectedDate + 1}';
                            } else {
                              if (selectedWeekday == -1) {
                                setBottomSheetState(() {
                                  selectDay = true;
                                  return;
                                });
                              } else {
                                setBottomSheetState(() {
                                  selectDay = false;
                                });
                              }

                              reminderType = 'Weekly';
                              reminderDay = Config().weekdays[selectedWeekday];
                            }

                            setState(() {});

                            Get.back();

                            // if (double.parse(_
                            //         .userProfile.value.data!.mainWalletBalance
                            //         .toString()) <=
                            //     0) {
                            //   lowWalletBalanceDialog(
                            //     image: 'assets/icons/ic_low_wallet_balance.png',
                            //     context: context,
                            //     onTap: () {
                            //       Get.back();
                            //       Get.to(() => const MainWalletReloadScreen());
                            //     },
                            //   );
                            // } else {
                            //   addNewFavorite();
                            // }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  showBillPaymentSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
            return SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 7,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 1.5,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                            color: kWhite,
                            // color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.1),
                                      //     blurRadius: 5,
                                      //     spreadRadius: 1,
                                      //   ),
                                      // ],
                                      color: kWhite,
                                      // color: kWhite,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: kWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.network(
                                          widget.favoriteProduct.productImage ?? '',
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            'assets/images/logo/parrot_logo.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.favoriteProduct.productName}',
                                          style: kBlackSmallMediumStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER') ? phoneNoController.text.trim() : accountNoController.text.trim(),
                                          style: kBlackExtraSmallLightMediumStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              FutureBuilder<OutstandingBill?>(
                                future: _futureBillPaymentAmts,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  if (snapshot.data == null) {
                                    return const SizedBox();
                                  }
                                  if (snapshot.data!.status != 200) {
                                    return const SizedBox();
                                  }

                                  if (snapshot.data!.bill == null) {
                                    return const SizedBox();
                                  }

                                  return snapshot.data!.bill != null
                                      ? Column(
                                          children: [
                                            const Divider(thickness: 0.30),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Outstanding ',
                                                  style: kBlackSmallMediumStyle,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.red,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                  child: Text(
                                                    '${widget.favoriteProduct.currency} ${snapshot.data!.bill!.outstandingAmount}',
                                                    style: kWhiteSmallMediumStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Payment Method:',
                          textAlign: TextAlign.start,
                          style: kBlackMediumStyle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetX<UserProfileController>(
                          init: userProfileController,
                          builder: (_) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kColorPrimary,
                                        kColorPrimaryDark,
                                      ],
                                    ),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Main Wallet',
                                                    style: kWhiteDarkMediumStyle,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/images/logo/logo_full.svg',
                                                    width: Get.width * 0.2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Balance',
                                                    style: kWhiteDarkMediumStyle,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
                                                    style: kWhiteDarkSuperLargeStyle,
                                                  ),
                                                ],
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
                                  height: 25,
                                ),
                                GradientButton(
                                  text: 'Pay Now',
                                  width: false,
                                  widthSize: Get.width * 0.7,
                                  buttonState: ButtonState.idle,
                                  onTap: () {
                                    Get.back();

                                    if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < 0) {
                                      lowWalletBalanceDialog(
                                        image: 'assets/icons/ic_low_wallet_balance.png',
                                        context: context,
                                        onTap: () {
                                          Get.back();
                                          Get.to(() => const MainWalletReloadScreen());
                                        },
                                      );
                                    } else {
                                      addNewFavorite();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
          "Add New Favorite",
          style: kBlackLargeStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.error_outline,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: Get.width * 0.5,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Hero(
                  tag: '${widget.favoriteProduct.productId}',
                  child: Center(
                    child: Image.network(
                      '${widget.favoriteProduct.productImage}',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/logo/parrot_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                widget.favoriteProduct.productName!.split(' ').map((e) => e.capitalize).join(" "),
                style: kBlackDarkMediumStyle,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Bill Nick Name',
              style: kBlackMediumStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
                color: kWhite,
                // color: kWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: TextFormField(
                        controller: nicknameController,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                        ],
                        onChanged: (value) {
                          if (isInsertNickname) {
                            if (value.isNotEmpty) {
                              setState(() {
                                isInsertNickname = false;
                              });
                            }
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                          helperStyle: kBlackSmallLightMediumStyle,
                          errorStyle: kBlackSmallLightMediumStyle,
                          hintStyle: kBlackSmallLightMediumStyle,
                          hintText: 'Enter your bill nick name',
                          labelStyle: kBlackSmallLightMediumStyle,
                          fillColor: kWhite,
                          filled: true,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          // suffixIcon: phoneNoController.text.trim().isNotEmpty
                          //     ? GestureDetector(
                          //         onTap: () => setState(() {
                          //           phoneNoController.text = '';
                          //         }),
                          //         child: const Icon(
                          //           Icons.close,
                          //           color: Colors.black38,
                          //           size: 18,
                          //         ),
                          //       )
                          //     : const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    height: 20,
                    color: Colors.black12,
                    width: 1,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      nicknameController.text = '';
                      setState(() {
                        isInsertNickname = false;
                      });
                    }),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black38,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 5),
              child: Text(
                isInsertNickname ? 'Enter Bill Nick Name' : '',
                textAlign: TextAlign.end,
                style: kRedSmallMediumStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // contact = await Get.to(() => const ContactsScreen());
                              userProfileController.checkContactPermission(context).then((value) {
                                // if (contact != null) {
                                if (userProfileController.contacts.isNotEmpty ?? false) {
                                  // String coNo = contact!.phones!.first.value!.trim();
                                  String coNo = "${userProfileController.contacts.first.phoneNumbers}";
                                  coNo = coNo.replaceAll('-', '').toString();
                                  coNo = coNo.replaceAll(' ', '').toString();
                                  coNo = coNo.replaceAll('(', '').toString();
                                  coNo = coNo.replaceAll(')', '').toString();
                                  coNo = coNo.replaceAll('[', '').toString();
                                  coNo = coNo.replaceAll(']', '').toString();
                                  coNo = coNo.replaceAll('+6', '').toString();

                                  if (coNo.startsWith('+6')) {
                                    coNo = coNo.substring(2);
                                  }

                                  phoneNoController.text = coNo;

                                  if ((coNo.trim().length < 10 || coNo.trim().length > 11) || !coNo.trim().startsWith('01')) {
                                    //invalid no
                                    print('INVALID NO');
                                    setState(() {
                                      isInvalidNo = true;
                                      isInsertNo = false;
                                    });

                                    return;
                                  }

                                  if (isInsertNo || isInvalidNo) {
                                    setState(() {
                                      isInsertNo = false;
                                      isInvalidNo = false;
                                    });
                                  }

                                  outstandingBill = null;

                                  _futureBillPaymentAmts = getOutstandingBill({"product_id": "${widget.favoriteProduct.productId}", "country": "MY", "account_number": coNo});

                                  setState(() {});
                                }
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 47,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                                color: kWhite,
                                // color: kWhite,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/wallet/phonebook.png',
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    color: kWhite,
                                    // color: kWhite,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: TextFormField(
                                            controller: phoneNoController,
                                            textAlignVertical: TextAlignVertical.center,
                                            // validator: (value) {
                                            //   if (value!.trim().isEmpty) {
                                            //     return 'Phone number is required';
                                            //   }
                                            //   if (!value.trim().startsWith('01')) {
                                            //     return 'Phone number is invalid';
                                            //   }
                                            //   if (value.trim().length < 10 ||
                                            //       value.trim().length > 11) {
                                            //     return 'Phone number is invalid';
                                            //   }
                                            //   return null;
                                            // },
                                            onChanged: (value) {
                                              if (isInsertNo || isInvalidNo) {
                                                setState(() {
                                                  isInsertNo = false;
                                                  isInvalidNo = false;
                                                });
                                              }

                                              //  if (widget.favoriteProduct
                                              //         .fieldsRequired!
                                              //         .singleWhere((element) =>
                                              //             element.type ==
                                              //             'PHONE_NUMBER')
                                              //         .minLength !=
                                              //     '-1') {
                                              //   if (value.toString().length <
                                              //       widget.favoriteProduct
                                              //           .fieldsRequired!
                                              //           .singleWhere(
                                              //               (element) =>
                                              //                   element.type ==
                                              //                   'PHONE_NUMBER')
                                              //           .minLength) {
                                              //     return;
                                              //   }
                                              // }

                                              if (widget.favoriteProduct.hasOutstandingAmount!) {
                                                if (value.trim().length >= 10 && value.trim().length <= 11) {
                                                  //fetch
                                                  outstandingBill = null;
                                                  _futureBillPaymentAmts = getOutstandingBill({
                                                    "product_id": "${widget.favoriteProduct.productId}",
                                                    "country": "MY",
                                                    "account_number": value.trim(),
                                                  });
                                                } else {
                                                  if (outstandingBill != null) {
                                                    outstandingBill = null;
                                                    _futureBillPaymentAmts = getOutstandingBill({});
                                                  }
                                                }
                                                setState(() {});
                                              }
                                            },
                                            enableInteractiveSelection: true,
                                            style: kBlackMediumStyle,
                                            textInputAction: TextInputAction.done,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                              helperStyle: kBlackSmallLightMediumStyle,
                                              errorStyle: kBlackSmallLightMediumStyle,
                                              hintStyle: kBlackSmallLightMediumStyle,
                                              hintText: 'Eg: 0123456789',
                                              labelStyle: kBlackSmallLightMediumStyle,
                                              fillColor: kWhite,
                                              filled: true,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              // suffixIcon: phoneNoController.text.trim().isNotEmpty
                                              //     ? GestureDetector(
                                              //         onTap: () => setState(() {
                                              //           phoneNoController.text = '';
                                              //         }),
                                              //         child: const Icon(
                                              //           Icons.close,
                                              //           color: Colors.black38,
                                              //           size: 18,
                                              //         ),
                                              //       )
                                              //     : const SizedBox(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        height: 20,
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          phoneNoController.text = '';
                                          FocusScope.of(context).unfocus();

                                          setState(() {
                                            isInsertNo = false;
                                            isInvalidNo = false;

                                            if (widget.favoriteProduct.hasOutstandingAmount!) {
                                              outstandingBill = null;
                                              _futureBillPaymentAmts = getOutstandingBill({});
                                            }
                                          });
                                        }),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.black38,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10, right: 5),
                                      child: Text(
                                        isInsertNo
                                            ? 'Enter Phone Number'
                                            : isInvalidNo
                                                ? 'Invalid Phone Number'
                                                : '',
                                        style: kRedSmallMediumStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : const SizedBox(),
            if (widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER'))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Number',
                    style: kBlackMediumStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                      color: kWhite,
                      // color: kWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: TextFormField(
                              controller: accountNoController,
                              textAlignVertical: TextAlignVertical.center,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                              ],
                              // validator: (value) {
                              //   if (value!.trim().isEmpty) {
                              //     return 'Phone number is required';
                              //   }
                              //   if (!value.trim().startsWith('01')) {
                              //     return 'Phone number is invalid';
                              //   }
                              //   if (value.trim().length < 10 ||
                              //       value.trim().length > 11) {
                              //     return 'Phone number is invalid';
                              //   }
                              //   return null;
                              // },
                              onChanged: (value) {
                                if (isInsertNo) {
                                  setState(() {
                                    isInsertNo = false;
                                  });
                                }

                                if (widget.favoriteProduct.hasOutstandingAmount!) {
                                  _futureBillPaymentAmts = null;

                                  if (widget.favoriteProduct.fieldsRequired!.singleWhere((element) => element.type == 'ACCOUNT_NUMBER').minLength != -1) {
                                    if (value.toString().length < int.parse(widget.favoriteProduct.fieldsRequired!.singleWhere((element) => element.type == 'ACCOUNT_NUMBER').minLength!.toString())) {
                                      if (outstandingBill != null) {
                                        outstandingBill = null;
                                        _futureBillPaymentAmts = getOutstandingBill({});
                                      }
                                    } else {
                                      outstandingBill = null;

                                      _futureBillPaymentAmts = getOutstandingBill({"product_id": "${widget.favoriteProduct.productId}", "country": "MY", "account_number": value.trim()});
                                    }
                                  } else {
                                    outstandingBill = null;

                                    _futureBillPaymentAmts = getOutstandingBill({"product_id": "${widget.favoriteProduct.productId}", "country": "MY", "account_number": value.trim()});
                                  }

                                  // if (value.trim().length >= 5) {
                                  //   //fetch
                                  //   outstandingBill = null;

                                  //   _futureBillPaymentAmts = getOutstandingBill({
                                  //     "product_id":
                                  //         "${widget.favoriteProduct.productId}",
                                  //     "country": "MY",
                                  //     "account_number": value.trim()
                                  //   });
                                  // } else {
                                  //   if (outstandingBill != null) {
                                  //     outstandingBill = null;
                                  //     _futureBillPaymentAmts =
                                  //         getOutstandingBill({});
                                  //   }
                                  // }
                                  setState(() {});
                                }
                              },
                              enableInteractiveSelection: true,
                              style: kBlackMediumStyle,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                helperStyle: kBlackSmallLightMediumStyle,
                                errorStyle: kBlackSmallLightMediumStyle,
                                hintStyle: kBlackSmallLightMediumStyle,
                                hintText: 'Enter your account number',
                                labelStyle: kBlackSmallLightMediumStyle,
                                fillColor: kWhite,
                                filled: true,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                // suffixIcon: phoneNoController.text.trim().isNotEmpty
                                //     ? GestureDetector(
                                //         onTap: () => setState(() {
                                //           phoneNoController.text = '';
                                //         }),
                                //         child: const Icon(
                                //           Icons.close,
                                //           color: Colors.black38,
                                //           size: 18,
                                //         ),
                                //       )
                                //     : const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 20,
                          color: Colors.black12,
                          width: 1,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            accountNoController.text = '';
                            setState(() {
                              isInsertNo = false;

                              if (widget.favoriteProduct.hasOutstandingAmount!) {
                                outstandingBill = null;
                                _futureBillPaymentAmts = getOutstandingBill({});
                              }
                            });
                          }),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black38,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 5),
                        child: Text(
                          isInsertNo ? 'Enter Account Number' : '',
                          style: kRedSmallMediumStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            else
              const SizedBox(),
            FutureBuilder<OutstandingBill?>(
              future: _futureBillPaymentAmts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        height: 25,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineScalePulseOut,
                          colors: [
                            kAccentColor,
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                if (snapshot.data!.status != 200) {
                  return const SizedBox();
                }

                if (snapshot.data!.bill == null) {
                  return const SizedBox();
                }

                if (snapshot.data!.bill != null && outstandingBill == null) {
                  if (snapshot.data!.bill!.outstandingAmount!.contains('-')) {
                    //skip
                  } else {
                    amountController.text = double.parse(snapshot.data!.bill!.outstandingAmount!.toString()).toInt().toString();
                  }
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    snapshot.data!.bill != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: const Color(0xffF6F6F6),
                                  // color: kWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                blurRadius: 6,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                            color: kWhite,
                                            // color: kWhite,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/icons/bill_payment/ic_person.png',
                                              width: 18,
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '${snapshot.data!.bill!.accountHolderName}',
                                          style: kBlackMediumStyle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 35,
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      blurRadius: 6,
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                  color: kWhite,
                                                  // color: kWhite,
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/icons/bill_payment/ic_outstanding_amt.png',
                                                    width: 18,
                                                    height: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${widget.favoriteProduct.currency} ${snapshot.data!.bill!.outstandingAmount}',
                                                    style: kBlackMediumStyle,
                                                  ),
                                                  Text(
                                                    'Outstanding Amount',
                                                    style: kBlackSmallLightMediumStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   width: 15,
                                        // ),
                                        // snapshot.data!.bill != null
                                        //     ? GestureDetector(
                                        //         onTap: () {
                                        //           // Get.to(() => BillPdfScreen(
                                        //           //       outstandingBill:
                                        //           //           snapshot.data,
                                        //           //     ));
                                        //         },
                                        //         child: Container(
                                        //           height: 40,
                                        //           padding: const EdgeInsets
                                        //                   .symmetric(
                                        //               horizontal: 15),
                                        //           decoration: BoxDecoration(
                                        //             gradient:
                                        //                 const LinearGradient(
                                        //               begin:
                                        //                   Alignment.topCenter,
                                        //               end: Alignment
                                        //                   .bottomCenter,
                                        //               colors: [
                                        //                 kWhite,
                                        //                 Color(0xffE4F0FA),
                                        //               ],
                                        //             ),
                                        //             boxShadow: [
                                        //               BoxShadow(
                                        //                 color: Colors.black
                                        //                     .withOpacity(0.1),
                                        //                 spreadRadius: 2,
                                        //                 blurRadius: 5,
                                        //                 offset:
                                        //                     const Offset(0, 0),
                                        //               ),
                                        //             ],
                                        //             borderRadius:
                                        //                 BorderRadius.circular(
                                        //                     8),
                                        //           ),
                                        //           alignment: Alignment.center,
                                        //           child: Row(
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment
                                        //                     .center,
                                        //             children: [
                                        //               const SizedBox(
                                        //                 width: 5,
                                        //               ),
                                        //               Text(
                                        //                 'View Bill',
                                        //                 style:
                                        //                     kBlackSmallMediumStyle,
                                        //               ),
                                        //               const SizedBox(
                                        //                 width: 5,
                                        //               ),
                                        //               const Icon(
                                        //                 Icons.arrow_forward_ios,
                                        //                 color: Colors.black45,
                                        //                 size: 15,
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                );
              },
            ),
            widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_OWNER_IC_NUMBER')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Owner I.C. Number (optional)',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                          color: kWhite,
                          // color: kWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextFormField(
                                  controller: accountOwnerController,
                                  textAlignVertical: TextAlignVertical.center,
                                  // validator: (value) {
                                  //   if (value!.trim().isEmpty) {
                                  //     return 'Phone number is required';
                                  //   }
                                  //   if (!value.trim().startsWith('01')) {
                                  //     return 'Phone number is invalid';
                                  //   }
                                  //   if (value.trim().length < 10 ||
                                  //       value.trim().length > 11) {
                                  //     return 'Phone number is invalid';
                                  //   }
                                  //   return null;
                                  // },
                                  // onChanged: (value) {
                                  //   if (isInsertNo || isInvalidNo) {
                                  //     setState(() {
                                  //       isInsertNo = false;
                                  //       isInvalidNo = false;
                                  //     });
                                  //   }

                                  //   if (value.trim().length >= 10 &&
                                  //       value.trim().length <= 11) {
                                  //     //fetch
                                  //     outstandingBill = null;
                                  //     _futureBillPaymentAmts = getOutstandingBill({
                                  //       "product_id":
                                  //           "${widget.favoriteProduct.productId}",
                                  //       "country": "MY",
                                  //       "account_number": "ghr568hui78"
                                  //     });
                                  //   } else {
                                  //     if (outstandingBill != null) {
                                  //       outstandingBill = null;
                                  //       _futureBillPaymentAmts =
                                  //           getOutstandingBill({});
                                  //     }
                                  //   }
                                  //   setState(() {});
                                  // },
                                  enableInteractiveSelection: true,
                                  style: kBlackMediumStyle,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                    helperStyle: kBlackSmallLightMediumStyle,
                                    errorStyle: kBlackSmallLightMediumStyle,
                                    hintStyle: kBlackSmallLightMediumStyle,
                                    hintText: 'Enter IC number',
                                    labelStyle: kBlackSmallLightMediumStyle,
                                    fillColor: kWhite,
                                    filled: true,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    // suffixIcon: phoneNoController.text.trim().isNotEmpty
                                    //     ? GestureDetector(
                                    //         onTap: () => setState(() {
                                    //           phoneNoController.text = '';
                                    //         }),
                                    //         child: const Icon(
                                    //           Icons.close,
                                    //           color: Colors.black38,
                                    //           size: 18,
                                    //         ),
                                    //       )
                                    //     : const SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 20,
                              color: Colors.black12,
                              width: 1,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () => setState(() {
                                accountOwnerController.text = '';
                                // setState(() {
                                //   isInsertNo = false;
                                //   isInvalidNo = false;

                                //   outstandingBill = null;
                                //   _futureBillPaymentAmts = getOutstandingBill({});
                                // });
                              }),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black38,
                                size: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  )
                : const SizedBox(),
            /* const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => addReminderSheet(),
                  child: Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: reminderType != null
                              ? kColorPrimaryLight
                              : Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                      color: kWhite,
                      // color: kWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/favorite/add_reminder.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                reminderType == null
                    ? GestureDetector(
                        onTap: () => addReminderSheet(),
                        child: Text(
                          'Add Reminder',
                          style: kBlackLightMediumStyle,
                        ),
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    color: kWhite,
                                    // color: kWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$reminderType',
                                      style: kBlackMediumStyle,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: reminderType == 'Monthly'
                                      ? const EdgeInsets.all(8)
                                      : const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                    color: kWhite,
                                    // color: kWhite,
                                    borderRadius: reminderType == 'Monthly'
                                        ? BorderRadius.circular(100)
                                        : BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      reminderType == 'Monthly'
                                          ? '$reminderDate'
                                          : '$reminderDay',
                                      style: kBlackMediumStyle,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  reminderDate = null;
                                  reminderDay = null;
                                  reminderType = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.asset(
                                  'assets/icons/ic_remove.png',
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ), */
            const SizedBox(
              height: 25,
            ),
            GradientButton(
              text: 'Save',
              width: false,
              widthSize: Get.width,
              buttonState: btnState,
              onTap: () {
                if (nicknameController.text.trim().isEmpty) {
                  setState(() {
                    isInsertNickname = true;
                  });
                  return;
                }
                if (widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER')) {
                  //account no.

                  if (accountNoController.text.trim().isEmpty) {
                    setState(() {
                      isInsertNo = true;
                    });
                    // errorSnackbar(
                    //     title: 'Failed',
                    //     subtitle: 'Enter phone number to proceed!');
                    return;
                  }
                }
                if (widget.favoriteProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')) {
                  if (phoneNoController.text.trim().isEmpty) {
                    setState(() {
                      isInsertNo = true;
                    });
                    // errorSnackbar(
                    //     title: 'Failed',
                    //     subtitle: 'Enter phone number to proceed!');
                    return;
                  } else if (phoneNoController.text.trim().length < 10 || phoneNoController.text.trim().length > 11 || !phoneNoController.text.trim().startsWith('01')) {
                    setState(() {
                      isInvalidNo = true;
                    });
                    // errorSnackbar(
                    //     title: 'Failed',
                    //     subtitle: 'Phone number is invalid!');
                    return;
                  }
                }

                // if (amountController.text.trim().isEmpty) {
                //   errorSnackbar(title: 'Failed', subtitle: 'Enter amount!');
                // } else {

                addNewFavorite();
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
