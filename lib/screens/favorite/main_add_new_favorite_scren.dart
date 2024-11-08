import 'package:cached_network_image/cached_network_image.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/controllers/top_up_controller.dart';
import 'package:parrotpos/models/topup/top_up_amounts.dart';
import 'package:parrotpos/screens/user_profile/wallet/send_money/contacts_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controllers/user_profile_controller.dart';
import '../../models/favorite/favorite_categories.dart';
import 'add_new_favorite_screen.dart';

class MainAddNewFavoriteScreen extends StatefulWidget {
  final int fromCategory;
  const MainAddNewFavoriteScreen({
    Key? key,
    required this.fromCategory,
  }) : super(key: key);

  @override
  _MainAddNewFavoriteScreenState createState() => _MainAddNewFavoriteScreenState();
}

class _MainAddNewFavoriteScreenState extends State<MainAddNewFavoriteScreen> {
  final FavoriteController favoriteController = Get.find();
  final UserProfileController userProfileController = Get.find();
  String search = '';
  TextEditingController searchController = TextEditingController();
  int selectedCategory = 0;
  bool isList = false;
  Future<List<FavoriteCategoriesProducts>>? _futureProducts;
  String? amount, countryCode;
  TextEditingController phoneNoController = TextEditingController();

  ButtonState btnState = ButtonState.idle;
  int selectedTab = 0;
  int selectedNetworkType = -1;
  int selectedAmt = -1;
  String? cashbackAmt;
  Contact? contact;
  bool isSelectNetworkType = false;
  bool isInsertNo = false;
  bool isInvalidNo = false;
  bool isChooseAmt = true;
  Future<TopUpAmounts?>? _futureTopUpAmts;
  Map filterMap = {};
  late TopUpAmounts topUpAmounts;
  final TopUpController topUpController = Get.find();
  bool isInsertNickname = false;
  TextEditingController nicknameController = TextEditingController();
  // final ScrollController _scrollController = ScrollController();
  RxBool isLoad = false.obs;
  late AutoScrollController autoScroll;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (widget.fromCategory != null) {
  //       selectedCategory = widget.fromCategory ?? 0;
  //       // favoriteController.favoriteCategories.value.categories?.forEach((element) {
  //       //   keyList.add(ValueKey(value));
  //       // });
  //       // scrollToCenter(selectedCategory); // Center the preselected category
  //       setState(() {});
  //     }
  //   });
  //
  //   favoriteController.getFavoriteCategories({"country": "MY"}, () {
  //     scrollToCenter(selectedCategory);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // autoScrollFun();
    // if (widget.fromCategory != null) {
    selectedCategory = widget.fromCategory ?? 0;
    print('select cat...${selectedCategory}');

    // _setSelectedButton(widget.fromCategory);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoad.value = true;
      favoriteController.getFavoriteCategories({"country": "MY"}, callBack: () {
        autoScroll = AutoScrollController(viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom), axis: Axis.horizontal);
        autoScrollFun();
        isLoad.value = false;
      });
    });
  }

  autoScrollFun() async {
    autoScroll = AutoScrollController(viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom), axis: Axis.horizontal);
    await autoScroll.scrollToIndex(selectedCategory, preferPosition: AutoScrollPosition.middle);
    autoScroll.highlight(selectedCategory);
  }
  // final _controller = AutoScrollController();

  Future<List<FavoriteCategoriesProducts>> getFilteredCategories() async {
    List<FavoriteCategoriesProducts> favoriteProducts = [];
    if (searchController.text.trim().isEmpty) {
      return favoriteController.favoriteCategories.value.categories![selectedCategory].products!;
    }

    for (var item in favoriteController.favoriteCategories.value.categories![selectedCategory].products!) {
      if (item.name!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase())) {
        //add
        favoriteProducts.add(item);
      }
    }

    return favoriteProducts;
  }

  Future<TopUpAmounts> getTopUpAmounts(Map map) async {
    if (map.isEmpty) {
      return topUpAmounts;
    }
    var res = await topUpController.getTopUpAmounts(map);
    topUpAmounts = res;
    if (res.status == 200) {
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
    favoriteController.reloadShimmer.value = true;
    print({
      "type": "${favoriteController.favoriteCategories.value.categories![selectedCategory].products![selectedNetworkType].type}",
      // "amount": topUpAmounts.amounts![selectedAmt].amount,
      "product_id": "${favoriteController.favoriteCategories.value.categories![selectedCategory].products![selectedNetworkType].productId}",
      "nick_name": nicknameController.text.trim(),
      "account_number": phoneNoController.text.trim(),
      // "reminder": reminderType != null,
      // "reminder_hour": reminderType != null ? 10 : 0,
      // "reminder_minute": 0,
      // "reminder_type": "$reminderType",
      // "reminder_day": reminderType != null
      //     ? reminderType == 'Monthly'
      //         ? reminderDate
      //         : reminderDay
      //     : 0,
      "amount": 0,
      // "product_id": favoriteController.favoriteCategories.value.categories![selectedCategory].products![selectedNetworkType].productId,
      // "account_number": "+6-${phoneNoController.text.trim()}"
    });

    Map<String, dynamic>? res;

    res = await favoriteController.addNewFavorite({
      "type": "${favoriteController.favoriteCategories.value.categories![selectedCategory].products![selectedNetworkType].type}",
      // "amount": topUpAmounts.amounts![selectedAmt].amount,
      "product_id": "${favoriteController.favoriteCategories.value.categories![selectedCategory].products![selectedNetworkType].productId}",
      "nick_name": nicknameController.text.trim(),
      "account_number": phoneNoController.text.trim(),
      // "reminder": reminderType != null,
      // "reminder_hour": reminderType != null ? 10 : 0,
      // "reminder_minute": 0,
      // "reminder_type": "$reminderType",
      // "reminder_day": reminderType != null
      //     ? reminderType == 'Monthly'
      //         ? reminderDate
      //         : reminderDay
      //     : 0,
      "amount": 0,
      // "product_id": favoriteController.favoriteProducts.value.products![selectedNetworkType].productId,
      // "account_number": "+6-${phoneNoController.text.trim()}"
    });

    if (res!['status'] == 200) {
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
      successSnackbar1(title: 'Added to favorite!');
      favoriteController.getAllFavorites({}, refreshing: true, callback: () {
        favoriteController.reloadShimmer.value = false;
      });
      setState(() {
        btnState = ButtonState.idle;
      });
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: res['message']);
    }
  }

  //  showTopupSheetRecent(FavoriteProduct recentTopUpData, int amountIndex) async {
  //   await showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setStateSheetRecent) => Container(
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(25),
  //               topRight: Radius.circular(25),
  //             ),
  //             color: kWhite,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black12,
  //                 spreadRadius: 7,
  //                 blurRadius: 10,
  //               ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Center(
  //                 child: Container(
  //                   width: 60,
  //                   height: 1.5,
  //                   color: Colors.black26,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 25,
  //               ),
  //               Container(
  //                 width: Get.width,
  //                 padding: const EdgeInsets.all(15),
  //                 decoration: BoxDecoration(
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.2),
  //                       blurRadius: 6,
  //                       spreadRadius: 2,
  //                     ),
  //                   ],
  //                   color: kWhite,
  //                   // color: kWhite,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Container(
  //                           width: 50,
  //                           height: 50,
  //                           padding: const EdgeInsets.all(5),
  //                           decoration: BoxDecoration(
  //                             // boxShadow: [
  //                             //   BoxShadow(
  //                             //     color: Colors.black.withOpacity(0.1),
  //                             //     blurRadius: 5,
  //                             //     spreadRadius: 1,
  //                             //   ),
  //                             // ],
  //                             color: kWhite,
  //                             // color: kWhite,
  //                             borderRadius: BorderRadius.circular(100),
  //                           ),
  //                           child: CircleAvatar(
  //                             backgroundColor: kWhite,
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(3.0),
  //                               child: Image.network(
  //                                 recentTopUpData.logo ?? '',
  //                                 errorBuilder: (context, error, stackTrace) =>
  //                                     Image.asset(
  //                                   'assets/images/logo/parrot_logo.png',
  //                                   width: 30,
  //                                   height: 30,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 10,
  //                         ),
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Text(
  //                                 '${recentTopUpData.name}',
  //                                 style: kBlackSmallMediumStyle,
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                               Text(
  //                                 recentTopUpData.,
  //                                 style: kBlackExtraSmallLightMediumStyle,
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const Divider(thickness: 0.30),
  //                     const SizedBox(
  //                       height: 2,
  //                     ),
  //                     Row(
  //                       children: [
  //                         Container(
  //                           width: 20,
  //                           height: 20,
  //                           padding: const EdgeInsets.all(5),
  //                           decoration: BoxDecoration(
  //                             boxShadow: [
  //                               BoxShadow(
  //                                 color: Colors.black.withOpacity(0.1),
  //                                 blurRadius: 5,
  //                                 spreadRadius: 1,
  //                               ),
  //                             ],
  //                             color: kWhite,
  //                             // color: kWhite,
  //                             borderRadius: BorderRadius.circular(100),
  //                           ),
  //                           child: Center(
  //                             child: Image.asset(
  //                               'assets/icons/ic_cashback.png',
  //                               width: 15,
  //                               height: 15,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 10,
  //                         ),
  //                         Row(
  //                           children: [
  //                             Text(
  //                               'Cash Back: ',
  //                               style: kBlackSmallLightMediumStyle,
  //                             ),
  //                             Text(
  //                               '${recentTopUpAmounts!.amounts![amountIndex].currency} ${recentTopUpAmounts!.amounts![amountIndex].cashbackAmount}',
  //                               style: kPrimarySmallDarkMediumStyle,
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 25,
  //               ),
  //               Text(
  //                 'Selected Amount:',
  //                 style: kBlackMediumStyle,
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               SizedBox(
  //                 height: 65,
  //                 // width: double.infinity,
  //                 child: ListView.separated(
  //                   scrollDirection: Axis.horizontal,
  //                   padding:
  //                       const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
  //                   itemBuilder: (context, index) {
  //                     return GestureDetector(
  //                       onTap: () {
  //                         setStateSheetRecent(() {
  //                           amountIndex = index;
  //                         });
  //                       },
  //                       child: Container(
  //                         width: Get.width * 0.18,
  //                         height: 40,
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 10, vertical: 5),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(10),
  //                           color: kWhite,
  //                           gradient: amountIndex == index
  //                               ? const LinearGradient(
  //                                   begin: Alignment.topCenter,
  //                                   end: Alignment.bottomCenter,
  //                                   colors: [
  //                                     kGreenBtnColor1,
  //                                     kGreenBtnColor2,
  //                                   ],
  //                                 )
  //                               : null,
  //                           border: amountIndex == index
  //                               ? Border.all(
  //                                   color: kColorPrimary,
  //                                   width: 1.5,
  //                                 )
  //                               : const Border(),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: amountIndex == index
  //                                   ? kColorPrimary.withOpacity(0.4)
  //                                   : Colors.black.withOpacity(0.2),
  //                               blurRadius: 6,
  //                               spreadRadius: 2,
  //                             ),
  //                           ],
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             '${recentTopUpAmounts!.amounts![index].currency} ${recentTopUpAmounts!.amounts![index].amount}',
  //                             style: amountIndex == index
  //                                 ? kWhiteMediumStyle
  //                                 : kBlackLightMediumStyle,
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                   separatorBuilder: (context, index) => const SizedBox(
  //                     width: 15,
  //                   ),
  //                   itemCount: recentTopUpAmounts!.amounts!.length,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 25,
  //               ),
  //               Text(
  //                 'Payment Method:',
  //                 textAlign: TextAlign.start,
  //                 style: kBlackMediumStyle,
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               GetX<UserProfileController>(
  //                 init: userProfileController,
  //                 builder: (_) {
  //                   return Column(
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 16, vertical: 12),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(15),
  //                           gradient: const LinearGradient(
  //                             begin: Alignment.topCenter,
  //                             end: Alignment.bottomCenter,
  //                             colors: [
  //                               kColorPrimary,
  //                               kColorPrimaryDark,
  //                             ],
  //                           ),
  //                         ),
  //                         child: Stack(
  //                           children: [
  //                             Positioned(
  //                               child: Image.asset(
  //                                 'assets/images/wallet/wallet_bg_shapes.png',
  //                                 width: Get.width * 0.3,
  //                               ),
  //                             ),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Column(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           'Main Wallet',
  //                                           style: kWhiteDarkMediumStyle,
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 10,
  //                                         ),
  //                                         SvgPicture.asset(
  //                                           'assets/images/logo/logo_full.svg',
  //                                           width: Get.width * 0.2,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     Column(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.spaceBetween,
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.end,
  //                                       children: [
  //                                         Text(
  //                                           'Balance',
  //                                           style: kWhiteDarkMediumStyle,
  //                                         ),
  //                                         const SizedBox(
  //                                           height: 10,
  //                                         ),
  //                                         Text(
  //                                           '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
  //                                           style: kWhiteDarkSuperLargeStyle,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   height: 3,
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 25,
  //                       ),
  //                       GradientButton(
  //                         text: 'Top Up Now',
  //                         width: false,
  //                         widthSize: Get.width * 0.7,
  //                         buttonState: ButtonState.idle,
  //                         onTap: () {
  //                           Get.back();

  //                           if (double.parse(_
  //                                   .userProfile.value.data!.mainWalletBalance
  //                                   .toString()) <=
  //                               0) {
  //                             lowWalletBalanceDialog(
  //                                 image:
  //                                     'assets/icons/ic_low_wallet_balance.png',
  //                                 context: context);
  //                           } else {
  //                             processTopupRecent(
  //                                 recentTopUpAmounts!
  //                                     .amounts![amountIndex].amount,
  //                                 recentTopUpData.others!.productId,
  //                                 recentTopUpData.others!.accountNumber);
  //                           }
  //                         },
  //                       ),
  //                       const SizedBox(
  //                         height: 15,
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  processTopupRecent(
    dynamic amt,
    String productId,
    String accountNo,
  ) async {
    // processingDialog(
    //     title: 'Processing topup.. Please wait!', context: context);

    // var res = await topUpController.initiateTopUp(
    //     {"amount": amt, "product_id": productId, "account_number": accountNo});

    // Get.back();

    // if (res!.isEmpty) {
    //   //done
    //   showCompletedTopupDialog(
    //       context: context,
    //       onTap: () {
    //         Get.back();
    //         walletController.getTransactionHistory({});
    //         Get.to(() => const TransactionHistoryScreen());
    //       },
    //       onTapFav: () {});
    //   topUpController.getRecentTopUp({});
    // } else {
    //   //error
    //   errorSnackbar(title: 'Failed', subtitle: res);
    // }
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
          GestureDetector(
            onTap: () async {
              setState(() {
                isList = !isList;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 0,
                      ),
                    ],
                    color: const Color(0xffF6F6F6),
                  ),
                  child: Center(
                    child: Image.asset(
                      isList ? 'assets/icons/bill_payment/ic_grid_view.png' : 'assets/icons/bill_payment/ic_list_view.png',
                      width: 22,
                      height: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
              color: kWhite,
              // color: kWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Search is required';
                  }

                  return null;
                },
                onSaved: (val) {
                  search = val!.trim();
                },
                onChanged: (value) {
                  if (favoriteController.favoriteCategories.value.categories != null) {
                    setState(() {
                      search = value.trim();
                    });
                    _futureProducts = getFilteredCategories();
                  }
                },
                controller: searchController,
                enableInteractiveSelection: true,
                style: kBlackMediumStyle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  helperStyle: kBlackSmallLightMediumStyle,
                  errorStyle: kBlackSmallLightMediumStyle,
                  hintStyle: kBlackSmallLightMediumStyle,
                  hintText: 'Search',
                  labelStyle: kBlackSmallLightMediumStyle,
                  fillColor: Colors.black.withOpacity(0.03),
                  filled: true,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  suffixIcon: search.isNotEmpty
                      ? GestureDetector(
                          onTap: () => setState(() {
                            search = '';
                            searchController.text = '';
                            setState(() {
                              _futureProducts = getFilteredCategories();
                            });
                          }),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black38,
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),
          const Divider(thickness: 0.30),
          Expanded(
            child: GetX<FavoriteController>(
              init: favoriteController,
              builder: (controller) {
                if (controller.isFetchingCategories.value && controller.favoriteCategories.value.categories == null && isLoad.value == true) {
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
                if (controller.favoriteCategories.value.status != 200) {
                  return SizedBox(
                    height: 35,
                    child: Center(
                      child: Text(
                        controller.favoriteCategories.value.message ?? "",
                        style: kBlackSmallMediumStyle,
                      ),
                    ),
                  );
                }

                _futureProducts ??= getFilteredCategories();

                return Column(
                  children: [
                    SizedBox(
                        height: 55,
                        // width: double.infinity,
                        child: StreamBuilder(
                            stream: isLoad.stream,
                            builder: (context, snapshot) {
                              if (isLoad.value == true) {
                                return Center(
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
                              return ListView.separated(
                                controller: autoScroll,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                                itemBuilder: (context, index) {
                                  print("categories!.length+++++++++++ ${controller.favoriteCategories.value.categories!.length}");
                                  return AutoScrollTag(
                                    key: ValueKey(index),
                                    controller: autoScroll,
                                    index: index,
                                    child: GestureDetector(
                                      // key: keyList[index],
                                      onTap: () {
                                        setState(() {
                                          searchController.text = '';
                                          search = '';
                                          selectedCategory = index;
                                          _futureProducts = null;
                                          //   favoriteController.getFavoriteProducts({
                                          //     "category_name": controller.favoriteCategories
                                          //         .value.products![index],
                                          //   });
                                        });
                                      },
                                      child: Container(
                                        // width: Get.width * 0.18,
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: kWhite,
                                          border: selectedCategory == index
                                              ? Border.all(
                                                  color: kColorPrimary,
                                                  width: 1.5,
                                                )
                                              : const Border(),
                                          gradient: selectedCategory == index
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
                                              color: selectedCategory == index ? kColorPrimary.withOpacity(0.4) : Colors.black.withOpacity(0.15),
                                              blurRadius: 3,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            controller.favoriteCategories.value.categories![index].name!.split(' ').map((e) => e.capitalize).join(" "),
                                            style: selectedCategory == index ? kWhiteMediumStyle : kBlackLightMediumStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                  width: 15,
                                ),
                                itemCount: controller.favoriteCategories.value.categories!.length,
                              );
                            })),
                    SizedBox(height: 5),
                    const Divider(
                      thickness: 0.30,
                      height: 1,
                    ),
                    FutureBuilder<List<FavoriteCategoriesProducts>?>(
                      future: _futureProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting && isLoad.value == true) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 30),
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
                        if (snapshot.data!.isEmpty) {
                          return SizedBox(
                            height: 55,
                            child: Center(
                              child: Text(
                                'No products found!',
                                style: kBlackSmallMediumStyle,
                              ),
                            ),
                          );
                        }

                        if (controller.favoriteCategories.value.categories![selectedCategory].name == 'TOPUP') {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => FocusScope.of(context).unfocus(),
                              child: ListView(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      'Select Your Network Type:',
                                      style: isSelectNetworkType ? kRedMediumStyle : kBlackMediumStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 80,
                                    // width: double.infinity,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              selectedNetworkType = index;
                                              isSelectNetworkType = false;
                                              amount = null;
                                              selectedAmt = -1;
                                              // isChooseAmt = false;
                                            });
                                            // _futureTopUpAmts = getTopUpAmounts({
                                            //   "product_id":
                                            //       "${controller.favoriteCategories.value.categories![selectedCategory].products![index].productId}"
                                            // });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: Get.width * 0.25,
                                                height: 42,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite,
                                                  border: selectedNetworkType == index
                                                      ? Border.all(
                                                          color: kColorPrimary,
                                                          width: 1.5,
                                                        )
                                                      : const Border(),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: selectedNetworkType == index ? kColorPrimary.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                                                      blurRadius: 3,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                                ),
                                                child: controller.favoriteCategories.value.categories?[selectedCategory].products?[index].logo?.isNotEmpty ?? false
                                                    ? CachedNetworkImage(
                                                        imageUrl: controller.favoriteCategories.value.categories![selectedCategory].products![index].logo ?? '',
                                                        placeholder: (context, url) {
                                                          return Padding(
                                                            padding: const EdgeInsets.only(top: 19),
                                                            child: Text(
                                                              textAlign: TextAlign.center,
                                                              overflow: TextOverflow.ellipsis,
                                                              '${controller.favoriteCategories.value.categories![selectedCategory].products![index].name}',
                                                              style: kBlackExtraSmallLightMediumStyle,
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
                                                    // Image.network(
                                                    //         '${controller.favoriteCategories.value.categories![selectedCategory].products![index].logo}',
                                                    //         fit: BoxFit.scaleDown,
                                                    //         width: 70,
                                                    //         height: 38,
                                                    //         errorBuilder: (context, error, stackTrace) => Image.asset(
                                                    //           'assets/images/logo/parrot_logo.png',
                                                    //           fit: BoxFit.scaleDown,
                                                    //           width: 70,
                                                    //           height: 38,
                                                    //         ),
                                                    //       )
                                                    : Text(
                                                        '${controller.favoriteCategories.value.categories![selectedCategory].products![index].name}',
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kBlackSmallMediumStyle,
                                                      ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                selectedNetworkType == index ? '${controller.favoriteCategories.value.categories![selectedCategory].products![index].name}' : '',
                                                style: kBlackExtraSmallLightMediumStyle,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => const SizedBox(
                                        width: 15,
                                      ),
                                      itemCount: controller.favoriteCategories.value.categories![selectedCategory].products!.length,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      'Insert Your Phone Number:',
                                      style: kBlackMediumStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
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
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: TextFormField(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                                    ],
                                                    controller: phoneNoController,
                                                    textAlignVertical: TextAlignVertical.center,
                                                    validator: (value) {
                                                      if (value!.trim().isEmpty) {
                                                        return 'Phone number is required';
                                                      }
                                                      if (!value.trim().startsWith('01')) {
                                                        return 'Phone number is invalid';
                                                      }
                                                      if (value.trim().length < 10 || value.trim().length > 11) {
                                                        return 'Phone number is invalid';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        if (isInsertNo) {
                                                          isInsertNo = false;
                                                        }
                                                        if (isInvalidNo) {
                                                          isInvalidNo = false;
                                                        }
                                                      });
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
                                                      suffixIcon: phoneNoController.text.trim().isNotEmpty
                                                          ? GestureDetector(
                                                              onTap: () => setState(() {
                                                                phoneNoController.text = '';
                                                              }),
                                                              child: const Icon(
                                                                Icons.close,
                                                                color: Colors.black38,
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      'Nick Name',
                                      style: kBlackMediumStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 15),
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
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                                              ],
                                              controller: nicknameController,
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
                                                hintText: 'Enter nick name',
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
                                    padding: const EdgeInsets.only(top: 10, right: 20),
                                    child: Text(
                                      isInsertNickname ? 'Enter Nick Name' : '',
                                      textAlign: TextAlign.end,
                                      style: kRedSmallMediumStyle,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    height: 0,
                                    // foregroundDecoration:
                                    //     phoneNoController.text.trim().isEmpty ||
                                    //             isChooseAmt
                                    //         ? const BoxDecoration(
                                    //             color: Colors.white60,
                                    //           )
                                    //         : const BoxDecoration(),
                                    child: FutureBuilder<TopUpAmounts?>(
                                      future: _futureTopUpAmts,
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
                                        if (snapshot.data!.amounts!.isEmpty) {
                                          return Center(
                                            child: Text(
                                              'No Amounts Found!',
                                              style: kBlackMediumStyle,
                                            ),
                                          );
                                        }

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Text(
                                                'Choose your amount:',
                                                style: isChooseAmt ? kRedMediumStyle : kBlackMediumStyle,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 22,
                                                    height: 22,
                                                    padding: const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.1),
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                        ),
                                                      ],
                                                      color: kWhite,
                                                      // color: kWhite,
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                    child: Center(
                                                      child: Image.asset(
                                                        'assets/icons/ic_cashback.png',
                                                        width: 12,
                                                        height: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Cash Back: ',
                                                        style: kBlackMediumStyle,
                                                      ),
                                                      Text(
                                                        selectedAmt == -1 ? 'RM 0.00' : '${snapshot.data!.amounts![selectedAmt].currency} ${snapshot.data!.amounts![selectedAmt].cashbackAmount}',
                                                        style: kPrimaryDarkMediumStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            SizedBox(
                                              height: 60,
                                              // width: double.infinity,
                                              child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedAmt = index;
                                                        amount = snapshot.data!.amounts![selectedAmt].amount.toString();
                                                        cashbackAmt = snapshot.data!.amounts![selectedAmt].cashbackAmount.toString();

                                                        isChooseAmt = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 90,
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: kWhite,
                                                        border: selectedAmt == index
                                                            ? Border.all(
                                                                color: kColorPrimary,
                                                                width: 1.5,
                                                              )
                                                            : const Border(),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: selectedAmt == index ? kColorPrimary.withOpacity(0.4) : Colors.black.withOpacity(0.2),
                                                            blurRadius: 6,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${snapshot.data!.amounts![index].currency} ${snapshot.data!.amounts![index].amount}',
                                                          style: selectedAmt == index ? kBlackMediumStyle : kBlackLightMediumStyle,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (context, index) => const SizedBox(
                                                  width: 15,
                                                ),
                                                itemCount: snapshot.data!.amounts!.length,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: GradientButton(
                                      text: 'Continue',
                                      width: false,
                                      widthSize: Get.width,
                                      buttonState: btnState,
                                      onTap: () {
                                        print(isSelectNetworkType);
                                        print(isInsertNo);
                                        print(isChooseAmt);
                                        print(amount);
                                        if (selectedNetworkType == -1) {
                                          setState(() {
                                            isSelectNetworkType = true;
                                          });
                                          // errorSnackbar(
                                          //     title: 'Failed',
                                          //     subtitle: 'Enter phone number to proceed!');
                                          return;
                                        } else if (phoneNoController.text.trim().isEmpty) {
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

                                        if (nicknameController.text.trim().isEmpty) {
                                          setState(() {
                                            isInsertNickname = true;
                                          });
                                          // errorSnackbar(
                                          //     title: 'Failed',
                                          //     subtitle: 'Enter phone number to proceed!');
                                          return;
                                        }

                                        // if (amount == null) {
                                        //   setState(() {
                                        //     isChooseAmt = true;
                                        //   });
                                        //   // errorSnackbar(
                                        //   //     title: 'Failed',
                                        //   //     subtitle: 'Select amount and network!');
                                        // } else {
                                        // showTopupSheet();
                                        //add to fav

                                        addNewFavorite();
                                        // }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return isList
                            ? Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: kWhite,
                                              borderRadius: BorderRadius.circular(100),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 1,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: Hero(
                                              tag: '${snapshot.data![index].productId}',
                                              child: Center(
                                                child: Image.network(
                                                  '${snapshot.data![index].logo}',
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                                    'assets/images/logo/parrot_logo.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Expanded(
                                            child: Text(
                                              '${snapshot.data![index].name}',
                                              style: kBlackMediumStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 20,
                                      ),
                                      dense: true,
                                      onTap: () {
                                        if (snapshot.data![index].type == 'TOPUP') {
                                          setState(() {
                                            searchController.text = '';
                                            search = '';
                                            selectedCategory = 1;
                                            _futureProducts = null;

                                            // favoriteController
                                            //     .getFavoriteProducts({
                                            //   "category_name": controller
                                            //       .favoriteCategories
                                            //       .value
                                            //       .products![1],
                                            // });
                                          });
                                        }
                                        if (snapshot.data![index].type == 'BILL_PAYMENT') {
                                          Get.to(() => AddNewFavoriteScreen(
                                                favoriteProduct: snapshot.data![index],
                                              ));
                                        }
                                      },
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Hero(
                                          tag: '${snapshot.data![index].productId}',
                                          child: Center(
                                            child: Image.network(
                                              '${snapshot.data![index].logo}',
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                                'assets/images/logo/parrot_logo.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        '${snapshot.data![index].name}',
                                        style: kBlackMediumStyle,
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data!.length,
                                  separatorBuilder: (context, index) => const Divider(
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {
                                      if (snapshot.data![index].type == 'TOPUP') {
                                        setState(() {
                                          searchController.text = '';
                                          search = '';
                                          selectedCategory = 1;
                                          _futureProducts = null;

                                          // favoriteController
                                          //     .getFavoriteProducts({
                                          //   "category_name": controller
                                          //       .favoriteCategories
                                          //       .value
                                          //       .products![1],
                                          // });
                                        });
                                      }
                                      if (snapshot.data![index].type == 'BILL_PAYMENT') {
                                        Get.to(() => AddNewFavoriteScreen(
                                              favoriteProduct: snapshot.data![index],
                                            ));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: kWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 3,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Hero(
                                          tag: '${snapshot.data![index].productId}',
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            height: 50,
                                            width: 50,
                                            imageUrl: snapshot.data![index].logo ?? '',
                                            placeholder: (context, url) {
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 80),
                                                child: Text(
                                                  overflow: TextOverflow.ellipsis,
                                                  '${snapshot.data![index].name}',
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
                                          )

                                          // Center(
                                          //   child: Image.network(
                                          //     '${snapshot.data![index].logo}',
                                          //     fit: BoxFit.contain,
                                          //     errorBuilder: (context, error, stackTrace) => Image.asset(
                                          //       'assets/images/logo/parrot_logo.png',
                                          //       fit: BoxFit.contain,
                                          //     ),
                                          //   ),
                                          // ),
                                          ),
                                    ),
                                  ),
                                  itemCount: snapshot.data!.length,
                                ),
                              );
                      },
                    ),
                    // GetX<FavoriteController>(
                    //   init: favoriteController,
                    //   builder: (controller) {
                    //     if (controller.isFetchingProducts.value) {
                    //       return const Center(
                    //         child: Padding(
                    //           padding: EdgeInsets.only(top: 30),
                    //           child: SizedBox(
                    //             height: 25,
                    //             child: LoadingIndicator(
                    //               indicatorType: Indicator.lineScalePulseOut,
                    //               colors: [
                    //                 kAccentColor,
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //     if (controller.favoriteProducts.value.status != 200) {
                    //       return SizedBox(
                    //         height: 35,
                    //         child: Center(
                    //           child: Text(
                    //             controller.favoriteProducts.value.message!,
                    //             style: kBlackSmallMediumStyle,
                    //           ),
                    //         ),
                    //       );
                    //     }

                    //     if (controller.favoriteProducts.value.products ==
                    //         null) {
                    //       return const SizedBox();
                    //     }
                    //     if (controller
                    //         .favoriteProducts.value.products!.isEmpty) {
                    //       return SizedBox(
                    //         height: 55,
                    //         child: Center(
                    //           child: Text(
                    //             'No products found!',
                    //             style: kBlackSmallMediumStyle,
                    //           ),
                    //         ),
                    //       );
                    //     }
                    //     _futureProducts ??= getFilteredCategories();
                    //     return FutureBuilder<FavoriteProducts?>(
                    //       future: _futureProducts,
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState ==
                    //             ConnectionState.waiting) {
                    //           return const Center(
                    //             child: Padding(
                    //               padding: EdgeInsets.only(top: 30),
                    //               child: SizedBox(
                    //                 height: 25,
                    //                 child: LoadingIndicator(
                    //                   indicatorType:
                    //                       Indicator.lineScalePulseOut,
                    //                   colors: [
                    //                     kAccentColor,
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           );
                    //         }
                    //         if (snapshot.data == null) {
                    //           return const SizedBox();
                    //         }
                    //         if (snapshot.data!.products!.isEmpty) {
                    //           return SizedBox(
                    //             height: 55,
                    //             child: Center(
                    //               child: Text(
                    //                 'No products found!',
                    //                 style: kBlackSmallMediumStyle,
                    //               ),
                    //             ),
                    //           );
                    //         }

                    //         if (controller.favoriteCategories.value
                    //                 .products![selectedCategory] ==
                    //             'TOPUP') {
                    //           return Expanded(
                    //             child: GestureDetector(
                    //               onTap: () => FocusScope.of(context).unfocus(),
                    //               child: ListView(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 0, vertical: 15),
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 15),
                    //                     child: Text(
                    //                       'Select Your Network Type:',
                    //                       style: isSelectNetworkType
                    //                           ? kRedMediumStyle
                    //                           : kBlackMediumStyle,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 15,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 80,
                    //                     // width: double.infinity,
                    //                     child: ListView.separated(
                    //                       scrollDirection: Axis.horizontal,
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 5, horizontal: 20),
                    //                       itemBuilder: (context, index) {
                    //                         return GestureDetector(
                    //                           onTap: () async {
                    //                             setState(() {
                    //                               selectedNetworkType = index;
                    //                               isSelectNetworkType = false;
                    //                               amount = null;
                    //                               selectedAmt = -1;
                    //                               isChooseAmt = false;
                    //                             });
                    //                             _futureTopUpAmts =
                    //                                 getTopUpAmounts({
                    //                               "product_id":
                    //                                   "${controller.favoriteProducts.value.products![index].productId}"
                    //                             });
                    //                           },
                    //                           child: Column(
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               Container(
                    //                                 width: Get.width * 0.25,
                    //                                 height: 42,
                    //                                 padding: const EdgeInsets
                    //                                         .symmetric(
                    //                                     horizontal: 10,
                    //                                     vertical: 5),
                    //                                 decoration: BoxDecoration(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           10),
                    //                                   color: kWhite,
                    //                                   border:
                    //                                       selectedNetworkType ==
                    //                                               index
                    //                                           ? Border.all(
                    //                                               color:
                    //                                                   kColorPrimary,
                    //                                               width: 1.5,
                    //                                             )
                    //                                           : const Border(),
                    //                                   boxShadow: [
                    //                                     BoxShadow(
                    //                                       color: selectedNetworkType ==
                    //                                               index
                    //                                           ? kColorPrimary
                    //                                               .withOpacity(
                    //                                                   0.2)
                    //                                           : Colors.black
                    //                                               .withOpacity(
                    //                                                   0.2),
                    //                                       blurRadius: 6,
                    //                                       spreadRadius: 2,
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                                 child: Image.network(
                    //                                   '${controller.favoriteProducts.value.products![index].logo}',
                    //                                   fit: BoxFit.scaleDown,
                    //                                   width: 70,
                    //                                   height: 38,
                    //                                   errorBuilder: (context,
                    //                                           error,
                    //                                           stackTrace) =>
                    //                                       Image.asset(
                    //                                     'assets/images/logo/parrot_logo.png',
                    //                                     fit: BoxFit.scaleDown,
                    //                                     width: 70,
                    //                                     height: 38,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               const SizedBox(
                    //                                 height: 3,
                    //                               ),
                    //                               Text(
                    //                                 selectedNetworkType == index
                    //                                     ? '${controller.favoriteProducts.value.products![index].name}'
                    //                                     : '',
                    //                                 style:
                    //                                     kBlackExtraSmallLightMediumStyle,
                    //                                 overflow:
                    //                                     TextOverflow.ellipsis,
                    //                                 maxLines: 1,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         );
                    //                       },
                    //                       separatorBuilder: (context, index) =>
                    //                           const SizedBox(
                    //                         width: 15,
                    //                       ),
                    //                       itemCount: controller.favoriteProducts
                    //                           .value.products!.length,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 20,
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 15),
                    //                     child: Text(
                    //                       'Insert Your Phone Number:',
                    //                       style: kBlackMediumStyle,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 20,
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 15),
                    //                     child: Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         GestureDetector(
                    //                           onTap: () async {
                    //                             contact = await Get.to(() =>
                    //                                 const ContactsScreen());
                    //                             if (contact != null) {
                    //                               String coNo = contact!
                    //                                   .phones!.first.value!
                    //                                   .trim();
                    //                               coNo = coNo
                    //                                   .replaceAll('-', '')
                    //                                   .toString();
                    //                               coNo = coNo
                    //                                   .replaceAll(' ', '')
                    //                                   .toString();
                    //                               coNo = coNo
                    //                                   .replaceAll('(', '')
                    //                                   .toString();
                    //                               coNo = coNo
                    //                                   .replaceAll(')', '')
                    //                                   .toString();

                    //                               if (coNo.startsWith('+6')) {
                    //                                 coNo = coNo.substring(2);
                    //                               }

                    //                               phoneNoController.text = coNo;

                    //                               if ((coNo.trim().length <
                    //                                           10 ||
                    //                                       coNo.trim().length >
                    //                                           11) ||
                    //                                   !coNo
                    //                                       .trim()
                    //                                       .startsWith('01')) {
                    //                                 //invalid no
                    //                                 print('INVALID NO');
                    //                                 setState(() {
                    //                                   isInvalidNo = true;
                    //                                   isInsertNo = false;
                    //                                 });

                    //                                 return;
                    //                               }

                    //                               if (isInsertNo ||
                    //                                   isInvalidNo) {
                    //                                 setState(() {
                    //                                   isInsertNo = false;
                    //                                   isInvalidNo = false;
                    //                                 });
                    //                               }
                    //                             }
                    //                           },
                    //                           child: Container(
                    //                             width: 45,
                    //                             height: 47,
                    //                             padding:
                    //                                 const EdgeInsets.all(5),
                    //                             decoration: BoxDecoration(
                    //                               boxShadow: [
                    //                                 BoxShadow(
                    //                                   color: Colors.black
                    //                                       .withOpacity(0.2),
                    //                                   blurRadius: 6,
                    //                                   spreadRadius: 2,
                    //                                 ),
                    //                               ],
                    //                               color: kWhite,
                    //                               // color: kWhite,
                    //                               borderRadius:
                    //                                   BorderRadius.circular(10),
                    //                             ),
                    //                             child: Center(
                    //                               child: Image.asset(
                    //                                 'assets/images/wallet/phonebook.png',
                    //                                 width: 22,
                    //                                 height: 22,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 15,
                    //                         ),
                    //                         Expanded(
                    //                           child: Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment.end,
                    //                             children: [
                    //                               Container(
                    //                                 decoration: BoxDecoration(
                    //                                   boxShadow: [
                    //                                     BoxShadow(
                    //                                       color: Colors.black
                    //                                           .withOpacity(0.2),
                    //                                       blurRadius: 6,
                    //                                       spreadRadius: 2,
                    //                                     ),
                    //                                   ],
                    //                                   color: kWhite,
                    //                                   // color: kWhite,
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           12),
                    //                                 ),
                    //                                 child: ClipRRect(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           15),
                    //                                   child: TextFormField(
                    //                                     controller:
                    //                                         phoneNoController,
                    //                                     textAlignVertical:
                    //                                         TextAlignVertical
                    //                                             .center,
                    //                                     validator: (value) {
                    //                                       if (value!
                    //                                           .trim()
                    //                                           .isEmpty) {
                    //                                         return 'Phone number is required';
                    //                                       }
                    //                                       if (!value
                    //                                           .trim()
                    //                                           .startsWith(
                    //                                               '01')) {
                    //                                         return 'Phone number is invalid';
                    //                                       }
                    //                                       if (value
                    //                                                   .trim()
                    //                                                   .length <
                    //                                               10 ||
                    //                                           value
                    //                                                   .trim()
                    //                                                   .length >
                    //                                               11) {
                    //                                         return 'Phone number is invalid';
                    //                                       }
                    //                                       return null;
                    //                                     },
                    //                                     onChanged: (value) {
                    //                                       setState(() {
                    //                                         if (isInsertNo) {
                    //                                           isInsertNo =
                    //                                               false;
                    //                                         }
                    //                                         if (isInvalidNo) {
                    //                                           isInvalidNo =
                    //                                               false;
                    //                                         }
                    //                                       });
                    //                                     },
                    //                                     enableInteractiveSelection:
                    //                                         true,
                    //                                     style:
                    //                                         kBlackMediumStyle,
                    //                                     textInputAction:
                    //                                         TextInputAction
                    //                                             .done,
                    //                                     keyboardType:
                    //                                         TextInputType
                    //                                             .number,
                    //                                     decoration:
                    //                                         InputDecoration(
                    //                                       contentPadding:
                    //                                           const EdgeInsets
                    //                                                   .symmetric(
                    //                                               horizontal:
                    //                                                   15,
                    //                                               vertical: 14),
                    //                                       helperStyle:
                    //                                           kBlackSmallLightMediumStyle,
                    //                                       errorStyle:
                    //                                           kBlackSmallLightMediumStyle,
                    //                                       hintStyle:
                    //                                           kBlackSmallLightMediumStyle,
                    //                                       hintText:
                    //                                           'Eg: 0123456789',
                    //                                       labelStyle:
                    //                                           kBlackSmallLightMediumStyle,
                    //                                       fillColor: kWhite,
                    //                                       filled: true,
                    //                                       enabledBorder:
                    //                                           InputBorder.none,
                    //                                       errorBorder:
                    //                                           InputBorder.none,
                    //                                       focusedBorder:
                    //                                           InputBorder.none,
                    //                                       border:
                    //                                           InputBorder.none,
                    //                                       suffixIcon: phoneNoController
                    //                                               .text
                    //                                               .trim()
                    //                                               .isNotEmpty
                    //                                           ? GestureDetector(
                    //                                               onTap: () =>
                    //                                                   setState(
                    //                                                       () {
                    //                                                 phoneNoController
                    //                                                     .text = '';
                    //                                               }),
                    //                                               child:
                    //                                                   const Icon(
                    //                                                 Icons.close,
                    //                                                 color: Colors
                    //                                                     .black38,
                    //                                               ),
                    //                                             )
                    //                                           : const SizedBox(),
                    //                                     ),
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               Padding(
                    //                                 padding:
                    //                                     const EdgeInsets.only(
                    //                                         top: 10, right: 5),
                    //                                 child: Text(
                    //                                   isInsertNo
                    //                                       ? 'Enter Phone Number'
                    //                                       : isInvalidNo
                    //                                           ? 'Invalid Phone Number'
                    //                                           : '',
                    //                                   style:
                    //                                       kRedSmallMediumStyle,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 15,
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.symmetric(
                    //                         horizontal: 15),
                    //                     child: Text(
                    //                       'Nick Name',
                    //                       style: kBlackMediumStyle,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 20,
                    //                   ),
                    //                   Container(
                    //                     margin: const EdgeInsets.symmetric(
                    //                         horizontal: 15),
                    //                     decoration: BoxDecoration(
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color:
                    //                               Colors.black.withOpacity(0.2),
                    //                           blurRadius: 6,
                    //                           spreadRadius: 2,
                    //                         ),
                    //                       ],
                    //                       color: kWhite,
                    //                       // color: kWhite,
                    //                       borderRadius:
                    //                           BorderRadius.circular(12),
                    //                     ),
                    //                     child: Row(
                    //                       children: [
                    //                         Expanded(
                    //                           child: ClipRRect(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(15),
                    //                             child: TextFormField(
                    //                               controller:
                    //                                   nicknameController,
                    //                               onChanged: (value) {
                    //                                 if (isInsertNickname) {
                    //                                   if (value.isNotEmpty) {
                    //                                     setState(() {
                    //                                       isInsertNickname =
                    //                                           false;
                    //                                     });
                    //                                   }
                    //                                 }
                    //                               },
                    //                               textAlignVertical:
                    //                                   TextAlignVertical.center,
                    //                               enableInteractiveSelection:
                    //                                   true,
                    //                               style: kBlackMediumStyle,
                    //                               textInputAction:
                    //                                   TextInputAction.done,
                    //                               keyboardType:
                    //                                   TextInputType.text,
                    //                               decoration: InputDecoration(
                    //                                 contentPadding:
                    //                                     const EdgeInsets
                    //                                             .symmetric(
                    //                                         horizontal: 15,
                    //                                         vertical: 14),
                    //                                 helperStyle:
                    //                                     kBlackSmallLightMediumStyle,
                    //                                 errorStyle:
                    //                                     kBlackSmallLightMediumStyle,
                    //                                 hintStyle:
                    //                                     kBlackSmallLightMediumStyle,
                    //                                 hintText: 'Enter nick name',
                    //                                 labelStyle:
                    //                                     kBlackSmallLightMediumStyle,
                    //                                 fillColor: kWhite,
                    //                                 filled: true,
                    //                                 enabledBorder:
                    //                                     InputBorder.none,
                    //                                 errorBorder:
                    //                                     InputBorder.none,
                    //                                 focusedBorder:
                    //                                     InputBorder.none,
                    //                                 border: InputBorder.none,
                    //                                 // suffixIcon: phoneNoController.text.trim().isNotEmpty
                    //                                 //     ? GestureDetector(
                    //                                 //         onTap: () => setState(() {
                    //                                 //           phoneNoController.text = '';
                    //                                 //         }),
                    //                                 //         child: const Icon(
                    //                                 //           Icons.close,
                    //                                 //           color: Colors.black38,
                    //                                 //           size: 18,
                    //                                 //         ),
                    //                                 //       )
                    //                                 //     : const SizedBox(),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 5,
                    //                         ),
                    //                         Container(
                    //                           height: 20,
                    //                           color: Colors.black12,
                    //                           width: 1,
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 5,
                    //                         ),
                    //                         GestureDetector(
                    //                           onTap: () => setState(() {
                    //                             nicknameController.text = '';
                    //                             setState(() {
                    //                               isInsertNickname = false;
                    //                             });
                    //                           }),
                    //                           child: const Icon(
                    //                             Icons.close,
                    //                             color: Colors.black38,
                    //                             size: 18,
                    //                           ),
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 10,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.only(
                    //                         top: 10, right: 20),
                    //                     child: Text(
                    //                       isInsertNickname
                    //                           ? 'Enter Nick Name'
                    //                           : '',
                    //                       textAlign: TextAlign.end,
                    //                       style: kRedSmallMediumStyle,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 15,
                    //                   ),
                    //                   SizedBox(
                    //                     height: 150,
                    //                     // foregroundDecoration:
                    //                     //     phoneNoController.text.trim().isEmpty ||
                    //                     //             isChooseAmt
                    //                     //         ? const BoxDecoration(
                    //                     //             color: Colors.white60,
                    //                     //           )
                    //                     //         : const BoxDecoration(),
                    //                     child: FutureBuilder<TopUpAmounts?>(
                    //                       future: _futureTopUpAmts,
                    //                       builder: (context, snapshot) {
                    //                         if (snapshot.connectionState ==
                    //                             ConnectionState.waiting) {
                    //                           return const Center(
                    //                             child: SizedBox(
                    //                               height: 25,
                    //                               child: LoadingIndicator(
                    //                                 indicatorType: Indicator
                    //                                     .lineScalePulseOut,
                    //                                 colors: [
                    //                                   kAccentColor,
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           );
                    //                         }
                    //                         if (snapshot.data == null) {
                    //                           return const SizedBox();
                    //                         }
                    //                         if (snapshot
                    //                             .data!.amounts!.isEmpty) {
                    //                           return Center(
                    //                             child: Text(
                    //                               'No Amounts Found!',
                    //                               style: kBlackMediumStyle,
                    //                             ),
                    //                           );
                    //                         }

                    //                         return Column(
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             Padding(
                    //                               padding: const EdgeInsets
                    //                                       .symmetric(
                    //                                   horizontal: 15),
                    //                               child: Text(
                    //                                 'Choose your amount:',
                    //                                 style: isChooseAmt
                    //                                     ? kRedMediumStyle
                    //                                     : kBlackMediumStyle,
                    //                               ),
                    //                             ),
                    //                             const SizedBox(
                    //                               height: 20,
                    //                             ),
                    //                             Padding(
                    //                               padding: const EdgeInsets
                    //                                       .symmetric(
                    //                                   horizontal: 15),
                    //                               child: Row(
                    //                                 children: [
                    //                                   Container(
                    //                                     width: 22,
                    //                                     height: 22,
                    //                                     padding:
                    //                                         const EdgeInsets
                    //                                             .all(5),
                    //                                     decoration:
                    //                                         BoxDecoration(
                    //                                       boxShadow: [
                    //                                         BoxShadow(
                    //                                           color: Colors
                    //                                               .black
                    //                                               .withOpacity(
                    //                                                   0.1),
                    //                                           blurRadius: 5,
                    //                                           spreadRadius: 1,
                    //                                         ),
                    //                                       ],
                    //                                       color: kWhite,
                    //                                       // color: kWhite,
                    //                                       borderRadius:
                    //                                           BorderRadius
                    //                                               .circular(
                    //                                                   100),
                    //                                     ),
                    //                                     child: Center(
                    //                                       child: Image.asset(
                    //                                         'assets/icons/ic_cashback.png',
                    //                                         width: 12,
                    //                                         height: 12,
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                   const SizedBox(
                    //                                     width: 10,
                    //                                   ),
                    //                                   Row(
                    //                                     children: [
                    //                                       Text(
                    //                                         'Cash Back: ',
                    //                                         style:
                    //                                             kBlackMediumStyle,
                    //                                       ),
                    //                                       Text(
                    //                                         selectedAmt == -1
                    //                                             ? 'RM 0.00'
                    //                                             : '${snapshot.data!.amounts![selectedAmt].currency} ${snapshot.data!.amounts![selectedAmt].cashbackAmount}',
                    //                                         style:
                    //                                             kPrimaryDarkMediumStyle,
                    //                                       ),
                    //                                     ],
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                             const SizedBox(
                    //                               height: 15,
                    //                             ),
                    //                             SizedBox(
                    //                               height: 60,
                    //                               // width: double.infinity,
                    //                               child: ListView.separated(
                    //                                 scrollDirection:
                    //                                     Axis.horizontal,
                    //                                 padding: const EdgeInsets
                    //                                         .symmetric(
                    //                                     vertical: 7,
                    //                                     horizontal: 20),
                    //                                 itemBuilder:
                    //                                     (context, index) {
                    //                                   return GestureDetector(
                    //                                     onTap: () {
                    //                                       setState(() {
                    //                                         selectedAmt = index;
                    //                                         amount = snapshot
                    //                                             .data!
                    //                                             .amounts![
                    //                                                 selectedAmt]
                    //                                             .amount
                    //                                             .toString();
                    //                                         cashbackAmt = snapshot
                    //                                             .data!
                    //                                             .amounts![
                    //                                                 selectedAmt]
                    //                                             .cashbackAmount
                    //                                             .toString();

                    //                                         isChooseAmt = false;
                    //                                       });
                    //                                     },
                    //                                     child: Container(
                    //                                       width: 90,
                    //                                       height: 40,
                    //                                       padding:
                    //                                           const EdgeInsets
                    //                                                   .symmetric(
                    //                                               horizontal:
                    //                                                   10,
                    //                                               vertical: 5),
                    //                                       decoration:
                    //                                           BoxDecoration(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     10),
                    //                                         color: kWhite,
                    //                                         border: selectedAmt ==
                    //                                                 index
                    //                                             ? Border.all(
                    //                                                 color:
                    //                                                     kColorPrimary,
                    //                                                 width: 1.5,
                    //                                               )
                    //                                             : const Border(),
                    //                                         boxShadow: [
                    //                                           BoxShadow(
                    //                                             color: selectedAmt ==
                    //                                                     index
                    //                                                 ? kColorPrimary
                    //                                                     .withOpacity(
                    //                                                         0.4)
                    //                                                 : Colors
                    //                                                     .black
                    //                                                     .withOpacity(
                    //                                                         0.2),
                    //                                             blurRadius: 6,
                    //                                             spreadRadius: 2,
                    //                                           ),
                    //                                         ],
                    //                                       ),
                    //                                       child: Center(
                    //                                         child: Text(
                    //                                           '${snapshot.data!.amounts![index].currency} ${snapshot.data!.amounts![index].amount}',
                    //                                           style: selectedAmt ==
                    //                                                   index
                    //                                               ? kBlackMediumStyle
                    //                                               : kBlackLightMediumStyle,
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                   );
                    //                                 },
                    //                                 separatorBuilder:
                    //                                     (context, index) =>
                    //                                         const SizedBox(
                    //                                   width: 15,
                    //                                 ),
                    //                                 itemCount: snapshot
                    //                                     .data!.amounts!.length,
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         );
                    //                       },
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 30,
                    //                   ),
                    //                   GradientButton(
                    //                     text: 'Continue',
                    //                     width: false,
                    //                     widthSize: Get.width,
                    //                     buttonState: btnState,
                    //                     onTap: () {
                    //                       if (selectedNetworkType == -1) {
                    //                         setState(() {
                    //                           isSelectNetworkType = true;
                    //                         });
                    //                         // errorSnackbar(
                    //                         //     title: 'Failed',
                    //                         //     subtitle: 'Enter phone number to proceed!');
                    //                         return;
                    //                       } else if (phoneNoController.text
                    //                           .trim()
                    //                           .isEmpty) {
                    //                         setState(() {
                    //                           isInsertNo = true;
                    //                         });
                    //                         // errorSnackbar(
                    //                         //     title: 'Failed',
                    //                         //     subtitle: 'Enter phone number to proceed!');
                    //                         return;
                    //                       } else if (phoneNoController.text
                    //                                   .trim()
                    //                                   .length <
                    //                               10 ||
                    //                           phoneNoController.text
                    //                                   .trim()
                    //                                   .length >
                    //                               11 ||
                    //                           !phoneNoController.text
                    //                               .trim()
                    //                               .startsWith('01')) {
                    //                         setState(() {
                    //                           isInvalidNo = true;
                    //                         });
                    //                         // errorSnackbar(
                    //                         //     title: 'Failed',
                    //                         //     subtitle: 'Phone number is invalid!');
                    //                         return;
                    //                       }

                    //                       if (nicknameController.text
                    //                           .trim()
                    //                           .isEmpty) {
                    //                         setState(() {
                    //                           isInsertNickname = true;
                    //                         });
                    //                         // errorSnackbar(
                    //                         //     title: 'Failed',
                    //                         //     subtitle: 'Enter phone number to proceed!');
                    //                         return;
                    //                       }

                    //                       if (amount == null) {
                    //                         setState(() {
                    //                           isChooseAmt = true;
                    //                         });
                    //                         // errorSnackbar(
                    //                         //     title: 'Failed',
                    //                         //     subtitle: 'Select amount and network!');
                    //                       } else {
                    //                         // showTopupSheet();
                    //                         //add to fav

                    //                         addNewFavorite();
                    //                       }
                    //                     },
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         }

                    //         return isList
                    //             ? Expanded(
                    //                 child: ListView.separated(
                    //                   scrollDirection: Axis.vertical,
                    //                   shrinkWrap: true,
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 10, vertical: 0),
                    //                   itemBuilder:
                    //                       (BuildContext context, int index) {
                    //                     return ListTile(
                    //                       contentPadding:
                    //                           const EdgeInsets.symmetric(
                    //                         vertical: 10,
                    //                         horizontal: 20,
                    //                       ),
                    //                       dense: true,
                    //                       onTap: () {
                    //                         if (snapshot.data!.products![index]
                    //                                 .type ==
                    //                             'TOPUP') {
                    //                           setState(() {
                    //                             searchController.text = '';
                    //                             search = '';
                    //                             selectedCategory = 1;
                    //                             _futureProducts = null;

                    //                             // favoriteController
                    //                             //     .getFavoriteProducts({
                    //                             //   "category_name": controller
                    //                             //       .favoriteCategories
                    //                             //       .value
                    //                             //       .products![1],
                    //                             // });
                    //                           });
                    //                         }
                    //                         if (snapshot.data!.products![index]
                    //                                 .type ==
                    //                             'BILL_PAYMENT') {
                    //                           Get.to(() => AddNewFavoriteScreen(
                    //                                 favoriteProduct: snapshot
                    //                                     .data!.products![index],
                    //                               ));
                    //                         }
                    //                       },
                    //                       leading: Container(
                    //                         width: 50,
                    //                         height: 50,
                    //                         decoration: BoxDecoration(
                    //                           color: kWhite,
                    //                           borderRadius:
                    //                               BorderRadius.circular(100),
                    //                           boxShadow: [
                    //                             BoxShadow(
                    //                               color: Colors.black
                    //                                   .withOpacity(0.2),
                    //                               blurRadius: 6,
                    //                               spreadRadius: 2,
                    //                             ),
                    //                           ],
                    //                         ),
                    //                         padding: const EdgeInsets.all(10),
                    //                         child: Hero(
                    //                           tag:
                    //                               '${snapshot.data!.products![index].productId}',
                    //                           child: Center(
                    //                             child: Image.network(
                    //                               '${snapshot.data!.products![index].logo}',
                    //                               fit: BoxFit.contain,
                    //                               errorBuilder: (context, error,
                    //                                       stackTrace) =>
                    //                                   Image.asset(
                    //                                 'assets/images/logo/parrot_logo.png',
                    //                                 fit: BoxFit.contain,
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       title: Text(
                    //                         '${snapshot.data!.products![index].name}',
                    //                         style: kBlackMediumStyle,
                    //                       ),
                    //                     );
                    //                   },
                    //                   itemCount:
                    //                       snapshot.data!.products!.length,
                    //                   separatorBuilder: (context, index) =>
                    //                       const Divider(
                    //                     indent: 20,
                    //                     endIndent: 20,
                    //                   ),
                    //                 ),
                    //               )
                    //             : Expanded(
                    //                 child: GridView.builder(
                    //                   gridDelegate:
                    //                       const SliverGridDelegateWithFixedCrossAxisCount(
                    //                     crossAxisCount: 3,
                    //                     childAspectRatio: 1,
                    //                     crossAxisSpacing: 15,
                    //                     mainAxisSpacing: 15,
                    //                   ),
                    //                   shrinkWrap: true,
                    //                   // physics: const NeverScrollableScrollPhysics(),
                    //                   padding: const EdgeInsets.symmetric(
                    //                     horizontal: 16,
                    //                     vertical: 6,
                    //                   ),
                    //                   itemBuilder: (context, index) =>
                    //                       GestureDetector(
                    //                     onTap: () {
                    //                       if (snapshot.data!.products![index]
                    //                               .type ==
                    //                           'TOPUP') {
                    //                         setState(() {
                    //                           searchController.text = '';
                    //                           search = '';
                    //                           selectedCategory = 1;
                    //                           _futureProducts = null;

                    //                           favoriteController
                    //                               .getFavoriteProducts({
                    //                             "category_name": controller
                    //                                 .favoriteCategories
                    //                                 .value
                    //                                 .products![1],
                    //                           });
                    //                         });
                    //                       }
                    //                       if (snapshot.data!.products![index]
                    //                               .type ==
                    //                           'BILL_PAYMENT') {
                    //                         Get.to(() => AddNewFavoriteScreen(
                    //                               favoriteProduct: snapshot
                    //                                   .data!.products![index],
                    //                             ));
                    //                       }
                    //                     },
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 10, vertical: 5),
                    //                       decoration: BoxDecoration(
                    //                         borderRadius:
                    //                             BorderRadius.circular(16),
                    //                         color: kWhite,
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                             color: Colors.black
                    //                                 .withOpacity(0.2),
                    //                             blurRadius: 6,
                    //                             spreadRadius: 2,
                    //                           ),
                    //                         ],
                    //                       ),
                    //                       child: Hero(
                    //                         tag:
                    //                             '${snapshot.data!.products![index].productId}',
                    //                         child: Center(
                    //                           child: Image.network(
                    //                             '${snapshot.data!.products![index].logo}',
                    //                             fit: BoxFit.contain,
                    //                             errorBuilder: (context, error,
                    //                                     stackTrace) =>
                    //                                 Image.asset(
                    //                               'assets/images/logo/parrot_logo.png',
                    //                               fit: BoxFit.contain,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   itemCount:
                    //                       snapshot.data!.products!.length,
                    //                 ),
                    //               );
                    //       },
                    //     );
                    //   },
                    // ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
