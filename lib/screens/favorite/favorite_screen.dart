import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/screens/favorite/edit_favorite_screen.dart';
import 'package:parrotpos/screens/favorite/edit_recurring_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:parrotpos/widgets/favorite/favorite_item.dart';
import 'package:parrotpos/widgets/favorite/recurring_item.dart';

import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/shimmer/dummy_favourite.dart';
import 'main_add_new_favorite_scren.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int selectedTab = 0;
  String appbarName = 'Favorite';
  FavoriteController favoriteController = Get.find();
  final sc = ScrollController();
  int selectedCategory = 0;
  @override
  void initState() {
    super.initState();
    _insertItems();
    // if (favoriteController.allFavorites.value.data == null) {}
    favoriteController.getAllFavorites({});
    favoriteController.getAllRecurring({});
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        log('reached');
        favoriteController.pageNumber.value++;

        // walletController.pageNumber.value++;

        favoriteController.getAllFavorites({});

        // log(walletController.pageNumber.value.toString());
      }
    });

    // if (favoriteController.transactionHistory.value.data == null) {
    //   favoriteController.getTransactionHistory({});
    // }
  }

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  void _insertItems() async {
    for (int i = 0; i < favoriteController.allFavorites!.value.data!.length; i++) {
      await Future.delayed(Duration(milliseconds: 300));
      _listKey.currentState?.insertItem(i);
    }
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
          appbarName,
          style: kBlackLargeStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // Get.to(() => const MainAddNewFavoriteScreen());

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return SizedBox(
                    // height: 350,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Add New Favorites",
                              style: kBlackStyle,
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                'assets/icons/favorite/closeround.svg',
                                // width: Get.width * 0.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 31),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonFavoriteBtn(
                              onTap: () {
                                Get.back();
                                Get.to(() => const MainAddNewFavoriteScreen(fromCategory: 1));
                              },
                              height: 28,
                              width: 31,
                              image: "assets/icons/favorite/prepaid.png",
                              title: "Prepaid \n Top Up",
                            ),
                            CommonFavoriteBtn(
                              onTap: () {
                                Get.back();
                                Get.to(() => const MainAddNewFavoriteScreen(fromCategory: 2));
                              },
                              height: 32,
                              width: 32,
                              image: "assets/icons/favorite/mobile.png",
                              title: "Mobile \n Postpaid",
                            ),
                            CommonFavoriteBtn(
                              onTap: () {
                                Get.back();
                                Get.to(() => const MainAddNewFavoriteScreen(fromCategory: 3));
                              },
                              height: 32,
                              width: 32,
                              image: "assets/icons/favorite/utility.png",
                              title: "Utility \n Bills",
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonFavoriteBtn(
                              onTap: () {
                                Get.back();
                                Get.to(() => const MainAddNewFavoriteScreen(fromCategory: 4));
                              },
                              height: 34,
                              width: 34,
                              image: "assets/icons/favorite/electric.png",
                              title: "Electric \n Bills",
                            ),
                            CommonFavoriteBtn(
                              onTap: () {
                                Get.back();
                                Get.to(() => const MainAddNewFavoriteScreen(fromCategory: 5));
                              },
                              height: 32,
                              width: 32,
                              image: "assets/icons/favorite/water.png",
                              title: "Water \n Bills",
                            ),
                            CommonFavoriteBtn(
                              onTap: () {
                                Get.back();
                                Get.to(() => const MainAddNewFavoriteScreen(fromCategory: 6));
                              },
                              height: 32,
                              width: 32,
                              image: "assets/icons/favorite/localcouncil.png",
                              title: "Local Council \n Bills",
                            ),
                          ],
                        ),
                        const SizedBox(height: 40), //I download Svg icons but few icons Not show and png icon show Blure
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 15);
                },
              );
            },
            child: Center(
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      kBlueBtnColor1,
                      kBlueBtnColor2,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add,
                  color: kWhite,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.info_outline,
          //     color: Colors.black54,
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          // const SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Row(
          //           children: [
          //             selectedTab == 0
          //                 ? GestureDetector(
          //                     onTap: () async {
          //                       Get.to(() => const MainAddNewFavoriteScreen());
          //                     },
          //                     child: Container(
          //                       height: 45,
          //                       width: 45,
          //                       decoration: BoxDecoration(
          //                         gradient: const LinearGradient(
          //                           colors: [
          //                             kBlueBtnColor1,
          //                             kBlueBtnColor2,
          //                           ],
          //                           begin: Alignment.topCenter,
          //                           end: Alignment.bottomCenter,
          //                         ),
          //                         boxShadow: [
          //                           BoxShadow(
          //                             color: Colors.black.withOpacity(0.1),
          //                             spreadRadius: 2,
          //                             blurRadius: 5,
          //                             offset: const Offset(0, 4),
          //                           ),
          //                         ],
          //                         borderRadius: BorderRadius.circular(10),
          //                       ),
          //                       child: const Icon(
          //                         Icons.add,
          //                         color: kWhite,
          //                         size: 20,
          //                       ),
          //                     ),
          //                   )
          //                 : const SizedBox(
          //                     width: 45,
          //                     height: 45,
          //                   ),
          //             const SizedBox(
          //               width: 5,
          //             ),
          //             Expanded(
          //               child: GestureDetector(
          //                 onTap: () {
          //                   setState(() {
          //                     selectedTab = 0;
          //                     appbarName = 'Favorite';
          //                   });
          //                 },
          //                 child: Container(
          //                   height: 45,
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 10, vertical: 10),
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(10),
          //                     gradient: LinearGradient(
          //                       begin: Alignment.topCenter,
          //                       end: Alignment.bottomCenter,
          //                       colors: selectedTab == 0
          //                           ? [
          //                               kColorPrimary,
          //                               kColorPrimaryDark,
          //                             ]
          //                           : [
          //                               const Color(0xffEDEDED),
          //                               const Color(0xffEDEDED),
          //                             ],
          //                     ),
          //                     boxShadow: [
          //                       BoxShadow(
          //                         color: Colors.black.withOpacity(0.2),
          //                         blurRadius: 4,
          //                         spreadRadius: 1,
          //                         offset: const Offset(0, 0),
          //                       ),
          //                     ],
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       // Image.asset(
          //                       //   selectedTab == 0
          //                       //       ? 'assets/icons/ic_topup.png'
          //                       //       : 'assets/icons/ic_topup_dark.png',
          //                       //   height: 18,
          //                       //   width: 18,
          //                       // ),
          //                       // const Spacer(),
          //                       Text(
          //                         'Favorite',
          //                         overflow: TextOverflow.ellipsis,
          //                         style: selectedTab == 0
          //                             ? kWhiteMediumStyle
          //                             : kBlackLightMediumStyle,
          //                       ),
          //                       // const Spacer(),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          // const SizedBox(
          //   width: 10,
          // ),
          // Expanded(
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               selectedTab = 1;
          //               appbarName = 'Recurring';

          //               // topUpController.getRecentTopUp({});
          //             });
          //           },
          //           child: Container(
          //             height: 45,
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 10, vertical: 10),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               gradient: LinearGradient(
          //                 begin: Alignment.topCenter,
          //                 end: Alignment.bottomCenter,
          //                 colors: selectedTab == 1
          //                     ? [
          //                         kColorPrimary,
          //                         kColorPrimaryDark,
          //                       ]
          //                     : [
          //                         const Color(0xffEDEDED),
          //                         const Color(0xffEDEDED),
          //                       ],
          //               ),
          //               boxShadow: [
          //                 BoxShadow(
          //                   color: Colors.black.withOpacity(0.2),
          //                   blurRadius: 4,
          //                   spreadRadius: 1,
          //                   offset: const Offset(0, 0),
          //                 ),
          //               ],
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 // Image.asset(
          //                 //   selectedTab == 1
          //                 //       ? 'assets/icons/ic_topup.png'
          //                 //       : 'assets/icons/ic_topup_dark.png',
          //                 //   height: 18,
          //                 //   width: 18,
          //                 // ),
          //                 // const Spacer(),
          //                 Text(
          //                   'Recurring',
          //                   overflow: TextOverflow.ellipsis,
          //                   style: selectedTab == 1
          //                       ? kWhiteMediumStyle
          //                       : kBlackLightMediumStyle,
          //                 ),
          //                 // const Spacer(),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       selectedTab == 1
          //           ? GestureDetector(
          //               onTap: () async {
          //                 Get.to(() => const AddNewRecurringScreen());
          //               },
          //               child: Container(
          //                 height: 45,
          //                 width: 45,
          //                 decoration: BoxDecoration(
          //                   gradient: const LinearGradient(
          //                     colors: [
          //                       kBlueBtnColor1,
          //                       kBlueBtnColor2,
          //                     ],
          //                     begin: Alignment.topCenter,
          //                     end: Alignment.bottomCenter,
          //                   ),
          //                   boxShadow: [
          //                     BoxShadow(
          //                       color: Colors.black.withOpacity(0.1),
          //                       spreadRadius: 2,
          //                       blurRadius: 5,
          //                       offset: const Offset(0, 4),
          //                     ),
          //                   ],
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //                 child: const Icon(
          //                   Icons.add,
          //                   color: kWhite,
          //                   size: 20,
          //                 ),
          //               ),
          //             )
          //           : const SizedBox(
          //               width: 45,
          //               height: 45,
          //             ),
          //     ],
          //   ),
          // ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // const Divider(thickness: 0.30),
          selectedTab == 0
              ? GetX<FavoriteController>(
                  init: favoriteController,
                  builder: (controller) {
                    if (controller.firstTimeLoading.value) {
                      return SizedBox(
                        height: Get.height * 0.8,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: const [DummyFavoritesItem(), DummyFavoritesItem()],
                        ),
                      );
                    }
                    if (controller.allFavorites!.value.data == null) {
                      return Center(
                        child: SizedBox(
                          height: 35,
                          child: Text(
                            controller.allFavorites!.value.message.toString(),
                            style: kBlackSmallMediumStyle,
                          ),
                        ),
                      );
                    }

                    if (controller.allFavorites!.value.data!.isEmpty) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Spacer(),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  'Add your favorite here.',
                                  style: kBlueSuperLargeStyle,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Image.asset(
                                  'assets/images/favorite/add_recurring_arrow.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/favorite/add_favorite.png',
                            width: Get.width * 0.6,
                            height: Get.width * 0.55,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'You do not have any favorite bills at the moment. Simply click on the ‘+’ icon above to start listing your favorite bills.',
                              textAlign: TextAlign.center,
                              style: kBlackLightMediumStyle,
                            ),
                          ),
                        ],
                      );
                    }

                    return Expanded(
                      child: RefreshIndicator(
                          onRefresh: () async {
                            favoriteController.getAllFavorites({});
                            return;
                          },
                          child: Theme(
                            data: ThemeData(canvasColor: Colors.white10),
                            child: ReorderableListView.builder(
                              scrollController: sc,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              itemBuilder: (context, index) {
                                if (index == controller.allFavorites!.value.data!.length) {
                                  log(controller.isFetchingFavorites.value.toString());
                                  return Opacity(
                                    key: Key(index.toString()),
                                    opacity: controller.isFetchingFavorites.value ? 1 : 0,
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return StreamBuilder(
                                      key: Key(controller.allFavorites!.value.data![index].favoriteId!),
                                      stream: controller.reloadShimmer.stream,
                                      builder: (context, snapshot) {
                                        return Column(
                                          children: [
                                            if (controller.reloadShimmer.isTrue && index == 0) DummyFavoritesItem(),
                                            // DummyFavoritesItem(),
                                            FavoriteItem(
                                              // key: Key(controller.allFavorites!.value.data![index].favoriteId!),
                                              index: index,
                                              allFavoritesData: controller.allFavorites!.value.data![index],
                                              onDelete: () async {
                                                await deleteDialog(
                                                  title: 'Are you sure you wish to remove ${controller.allFavorites!.value.data![index].nickName} from favorite list?',
                                                  buttonTitle: 'Yes',
                                                  buttonTitle2: 'No',
                                                  image: 'assets/icons/ic_remove.png',
                                                  context: context,
                                                  onTapYes: () async {
                                                    Get.back();

                                                    processingDialog(title: 'Removing from favorite...\nPlease wait', context: context);

                                                    var res = await favoriteController.removeFavorite({"favorite_id": "${controller.allFavorites!.value.data![index].favoriteId}"});

                                                    Get.back();
                                                    if (res!.isEmpty) {
                                                      //added
                                                      favoriteController.allFavorites!.update((val) {
                                                        val!.data!.removeAt(index);
                                                      });
                                                    } else {
                                                      errorSnackbar(title: 'Failed', subtitle: res);
                                                    }
                                                  },
                                                );
                                              },
                                              onEdit: () {
                                                Get.to(() => EditFavoriteScreen(index: index, favoriteProduct: controller.allFavorites!.value.data![index]));
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }
                                return AnimatedList(
                                  key: _listKey,
                                  initialItemCount: controller.allFavorites!.value.data!.length + 1,
                                  itemBuilder: (context, index, animation) {
                                    if (index == controller.allFavorites!.value.data!.length) {
                                      log(controller.isFetchingFavorites.value.toString());
                                      return Opacity(
                                        key: Key(index.toString()),
                                        opacity: controller.isFetchingFavorites.value ? 1 : 0,
                                        child: const Center(child: CircularProgressIndicator()),
                                      );
                                    } else {
                                      return SizeTransition(
                                        key: ValueKey(controller.allFavorites!.value.data![index].favoriteId!),
                                        sizeFactor: animation,
                                        child: StreamBuilder(
                                            key: Key(controller.allFavorites!.value.data![index].favoriteId!),
                                            stream: controller.reloadShimmer.stream,
                                            builder: (context, snapshot) {
                                              return Column(
                                                children: [
                                                  if (controller.reloadShimmer.isTrue && index == 0) DummyFavoritesItem(),
                                                  FavoriteItem(
                                                    // key: Key(controller.allFavorites!.value.data![index].favoriteId!),
                                                    index: index,
                                                    allFavoritesData: controller.allFavorites!.value.data![index],
                                                    onDelete: () async {
                                                      await deleteDialog(
                                                        title: 'Are you sure you wish to remove ${controller.allFavorites!.value.data![index].nickName} from favorite list?',
                                                        buttonTitle: 'Yes',
                                                        buttonTitle2: 'No',
                                                        image: 'assets/icons/ic_remove.png',
                                                        context: context,
                                                        onTapYes: () async {
                                                          Get.back();

                                                          processingDialog(title: 'Removing from favorite...\nPlease wait', context: context);

                                                          var res = await favoriteController.removeFavorite({"favorite_id": "${controller.allFavorites!.value.data![index].favoriteId}"});

                                                          Get.back();
                                                          if (res!.isEmpty) {
                                                            //added
                                                            favoriteController.allFavorites!.update((val) {
                                                              val!.data!.removeAt(index);
                                                            });
                                                          } else {
                                                            errorSnackbar(title: 'Failed', subtitle: res);
                                                          }
                                                        },
                                                      );
                                                    },
                                                    onEdit: () {
                                                      Get.to(() => EditFavoriteScreen(index: index, favoriteProduct: controller.allFavorites!.value.data![index]));
                                                    },
                                                  ),
                                                ],
                                              );
                                            }),
                                      );
                                    }
                                  },
                                );
                              },
                              itemCount: controller.allFavorites!.value.data!.length + 1,
                              onReorder: (int oldIndex, int newIndex) {
                                print(oldIndex);
                                print(newIndex);

                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }

                                // print('OLD :: ');
                                // for (var item
                                //     in controller.allFavorites.value.data!) {
                                //   print('${item.favoriteId}');
                                // }
                                // print('NEW :: ');
                                final oldItem = controller.allFavorites!.value.data![oldIndex];
                                final newItem = controller.allFavorites!.value.data![newIndex];
                                log(oldItem.favoriteId.toString());
                                log(newItem.favoriteId.toString());
                                final items = controller.allFavorites!.value.data!.removeAt(oldIndex);
                                controller.allFavorites!.value.data!.insert(newIndex, items);

                                List favByUser = [];
                                for (int i = 0; i < controller.allFavorites!.value.data!.length; i++) {
                                  favByUser.add("${controller.allFavorites!.value.data![i].favoriteId}");
                                }

                                print({
                                  'favorites': favByUser,
                                });
                                favoriteController.updateFavoriteOrder({
                                  "favorites": favByUser,
                                });
                              },
                            ),
                          )),
                    );
                  },
                )
              : GetX<FavoriteController>(
                  init: favoriteController,
                  builder: (controller) {
                    if (controller.isFetchingAllRecurring.value) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
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
                    if (controller.allRecurring.value.recurring == null) {
                      return Center(
                        child: SizedBox(
                          height: 35,
                          child: Text(
                            controller.allRecurring.value.message!,
                            style: kBlackSmallMediumStyle,
                          ),
                        ),
                      );
                    }

                    if (controller.allRecurring.value.recurring!.isEmpty) {
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  'Add your recurring here.',
                                  style: kRedSuperLargeStyle,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Image.asset(
                                'assets/images/favorite/add_recurring_arrow.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            'assets/images/favorite/add_recurring.png',
                            width: Get.width * 0.6,
                            height: Get.width * 0.6,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'You do not have any recurring payments at the moment. Simply click on the ‘+’ icon above to start listing your recurring payments.',
                              textAlign: TextAlign.center,
                              style: kBlackLightMediumStyle,
                            ),
                          ),
                        ],
                      );
                    }

                    // return Text(
                    //     '${controller.allRecurring.value.recurring!.length}');
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          favoriteController.getAllRecurring({});

                          return;
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          itemBuilder: (context, index) {
                            return RecurringItem(
                              key: Key(controller.allRecurring.value.recurring![index].favoriteId!),
                              recurringData: controller.allRecurring.value.recurring![index],
                              onDelete: () async {
                                await deleteDialog(
                                  title: 'Are you sure you wish to remove ${controller.allRecurring.value.recurring![index].nickName} from recurring list?',
                                  buttonTitle: 'Yes',
                                  buttonTitle2: 'No',
                                  image: 'assets/icons/ic_remove.png',
                                  context: context,
                                  onTapYes: () async {
                                    Get.back();

                                    processingDialog(title: 'Removing from recurring...\nPlease wait', context: context);

                                    var res = await favoriteController.removeRecurring({"favorite_id": "${controller.allRecurring.value.recurring![index].favoriteId}"});

                                    Get.back();
                                    if (res!.isEmpty) {
                                      //added
                                      favoriteController.getAllRecurring({});
                                    } else {
                                      errorSnackbar(title: 'Failed', subtitle: res);
                                    }
                                  },
                                );
                              },
                              onEdit: () {
                                Get.to(() => EditRecurringScreen(recurringData: controller.allRecurring.value.recurring![index]));
                              },
                            );
                          },
                          itemCount: controller.allRecurring.value.recurring!.length,
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
