import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/bill_payment_controller.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_categories.dart';

import 'package:parrotpos/screens/bill_payment/bill_payment_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/shimmer/products_billpayment.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/user_profile_controller.dart';

class MainBillPaymentScreen extends StatefulWidget {
  const MainBillPaymentScreen({Key? key}) : super(key: key);

  @override
  _MainBillPaymentScreenState createState() => _MainBillPaymentScreenState();
}

class _MainBillPaymentScreenState extends State<MainBillPaymentScreen> {
  final BillPaymentController billPaymentController = Get.find();
  final UserProfileController userProfileController = Get.find();
  String search = '';
  TextEditingController searchController = TextEditingController();
  int selectedCategory = 0;
  bool isList = false;
  Future<List<BillPaymentCategoriesProducts>?>? _futureProducts;

  @override
  void initState() {
    super.initState();

    if (billPaymentController.billPaymentCategories.value.categories == null) {
      billPaymentController.getBillPaymentCategories({"country": "MY"});
    }
    // else {
    //   // billPaymentController.getBillPaymentProducts({
    //   //   "category_id": billPaymentController
    //   //       .billPaymentCategories.value.categories![0].categoryId,
    //   //   "country": "MY",
    //   // });
    // }
  }

  Future<List<BillPaymentCategoriesProducts>?> getFilteredCategories() async {
    List<BillPaymentCategoriesProducts> billPaymentProducts = [];

    if (searchController.text.trim().isEmpty) {
      return billPaymentController.billPaymentCategories.value.categories![selectedCategory].products;
    }

    for (var item in billPaymentController.billPaymentCategories.value.categories![selectedCategory].products!) {
      if (item.name!.trim().toLowerCase().contains(searchController.text.trim().toLowerCase())) {
        //add
        billPaymentProducts.add(item);
      }
    }

    return billPaymentProducts;
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
          "Bill Payment",
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
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                    color: const Color(0xffF6F6F6),
                  ),
                  child: Center(
                    child: Image.asset(
                      isList ? 'assets/icons/bill_payment/ic_grid_view.png' : 'assets/icons/bill_payment/ic_list_view.png',
                      width: 20,
                      height: 20,
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
                  if (billPaymentController.billPaymentCategories.value.categories != null) {
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
            child: GetX<BillPaymentController>(
              init: billPaymentController,
              builder: (controller) {
                if (controller.isFetchingCategories.value && controller.billPaymentCategories.value.categories == null) {
                  return const DummyProducts();
                }
                if (controller.billPaymentCategories.value.status != 200) {
                  return SizedBox(
                    height: 35,
                    child: Center(
                      child: Text(
                        controller.billPaymentCategories.value.message!,
                        style: kBlackSmallMediumStyle,
                      ),
                    ),
                  );
                }

                _futureProducts = getFilteredCategories();
                return Column(
                  children: [
                    SizedBox(
                      height: 55,
                      // width: double.infinity,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                searchController.text = '';
                                search = '';
                                selectedCategory = index;
                                _futureProducts = null;

                                // billPaymentController.getBillPaymentProducts({
                                //   "category_id": controller
                                //       .billPaymentCategories
                                //       .value
                                //       .categories![index]
                                //       .categoryId,
                                //   "country": "MY",
                                // });
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
                                  controller.billPaymentCategories.value.categories![index].name!.split(' ').map((e) => e.capitalize).join(" "),
                                  style: selectedCategory == index ? kWhiteMediumStyle : kBlackLightMediumStyle,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(width: 15),
                        itemCount: controller.billPaymentCategories.value.categories!.length,
                      ),
                    ),
                    SizedBox(height: 5),
                    const Divider(
                      // thickness: 0.30,
                      height: 1,
                      // color: Colors.red,
                    ),
                    selectedCategory == -1
                        ? const SizedBox.shrink()
                        : FutureBuilder<List<BillPaymentCategoriesProducts>?>(
                            future: _futureProducts,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
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
                                              Get.to(() => BillPaymentScreen(
                                                    index: index,
                                                    billPaymentProduct: snapshot.data![index],
                                                  ));
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
                                                    blurRadius: 6,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(10),
                                              child: Hero(
                                                tag: '${snapshot.data![index].productId}',
                                                child: Center(
                                                  child: Image.network(
                                                    "${snapshot.data![index].logo}",
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
                                          mainAxisSpacing: 10,
                                        ),
                                        shrinkWrap: true,
                                        // physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          print("snapshot Data ======= ${snapshot.data![index].name}");
                                          print("snapshot Data ++++++++ ${snapshot.data![index].logo}");
                                          return GestureDetector(
                                            onTap: () {
                                              Get.to(() => BillPaymentScreen(
                                                    index: index,
                                                    billPaymentProduct: snapshot.data![index],
                                                  ));
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
                                                child: Center(
                                                  child: snapshot.data?[index].logo?.isNotEmpty ?? false
                                                      ? CachedNetworkImage(
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
                                                          fit: BoxFit.cover,
                                                          width: Get.width,
                                                        )
                                                      // Image.network(
                                                      //         '${snapshot.data![index].logo}',
                                                      //         fit: BoxFit.contain,
                                                      //         loadingBuilder: (context, child, loadingProgress) {
                                                      //           if (loadingProgress == null) {
                                                      //             return child;
                                                      //           } else {
                                                      //             return Text(
                                                      //               '${snapshot.data![index].name}',
                                                      //               style: kBlackSmallMediumStyle,
                                                      //             );
                                                      //           }
                                                      //         },
                                                      //         errorBuilder: (context, error, stackTrace) => Image.asset(
                                                      //           'assets/images/logo/parrot_logo.png',
                                                      //           fit: BoxFit.contain,
                                                      //         ),
                                                      //       )
                                                      : Text(
                                                          textAlign: TextAlign.center,
                                                          '${snapshot.data![index].name}',
                                                          style: kBlackExtraSmallLightMediumStyle,
                                                        ),
                                                ),
                                              ),
                                            ).paddingOnly(top: 5),
                                          );
                                        },
                                      ),
                                    );
                            },
                          ),
                    // selectedCategory == -1
                    //     ? const SizedBox()
                    //     : isList
                    //         ? Expanded(
                    //             child: ListView.separated(
                    //               scrollDirection: Axis.vertical,
                    //               shrinkWrap: true,
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 10, vertical: 0),
                    //               itemBuilder:
                    //                   (BuildContext context, int index) {
                    //                 return ListTile(
                    //                   contentPadding:
                    //                       const EdgeInsets.symmetric(
                    //                     vertical: 10,
                    //                     horizontal: 20,
                    //                   ),
                    //                   dense: true,
                    //                   onTap: () {
                    //                     // Get.to(() => BillPaymentScreen(
                    //                     //       index: index,
                    //                     //       billPaymentProduct:
                    //                     //           snapshot.data!.products![index],
                    //                     //     ));
                    //                   },
                    //                   leading: Container(
                    //                     width: 50,
                    //                     height: 50,
                    //                     decoration: BoxDecoration(
                    //                       color: kWhite,
                    //                       borderRadius:
                    //                           BorderRadius.circular(100),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color:
                    //                               Colors.black.withOpacity(0.2),
                    //                           blurRadius: 6,
                    //                           spreadRadius: 2,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     padding: const EdgeInsets.all(10),
                    //                     child: Hero(
                    //                       tag:
                    //                           '${controller.billPaymentCategories.value.categories![selectedCategory].products![index].productId}',
                    //                       child: Center(
                    //                         child: Image.network(
                    //                           '${controller.billPaymentCategories.value.categories![selectedCategory].products![index].logo}',
                    //                           fit: BoxFit.contain,
                    //                           errorBuilder: (context, error,
                    //                                   stackTrace) =>
                    //                               Image.asset(
                    //                             'assets/images/logo/parrot_logo.png',
                    //                             fit: BoxFit.contain,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   title: Text(
                    //                     '${controller.billPaymentCategories.value.categories![selectedCategory].products![index].name}',
                    //                     style: kBlackMediumStyle,
                    //                   ),
                    //                 );
                    //               },
                    //               itemCount: controller
                    //                   .billPaymentCategories
                    //                   .value
                    //                   .categories![selectedCategory]
                    //                   .products!
                    //                   .length,
                    //               separatorBuilder: (context, index) =>
                    //                   const Divider(
                    //                 indent: 20,
                    //                 endIndent: 20,
                    //               ),
                    //             ),
                    //           )
                    //         : Expanded(
                    //             child: GridView.builder(
                    //               gridDelegate:
                    //                   const SliverGridDelegateWithFixedCrossAxisCount(
                    //                 crossAxisCount: 3,
                    //                 childAspectRatio: 1,
                    //                 crossAxisSpacing: 15,
                    //                 mainAxisSpacing: 15,
                    //               ),
                    //               shrinkWrap: true,
                    //               // physics: const NeverScrollableScrollPhysics(),
                    //               padding: const EdgeInsets.symmetric(
                    //                 horizontal: 16,
                    //                 vertical: 6,
                    //               ),
                    //               itemBuilder: (context, index) =>
                    //                   GestureDetector(
                    //                 onTap: () {
                    //                   Get.to(() => BillPaymentScreen(
                    //                         index: index,
                    //                         billPaymentProduct: controller
                    //                             .billPaymentCategories
                    //                             .value
                    //                             .categories![selectedCategory]
                    //                             .products![index],
                    //                       ));
                    //                 },
                    //                 child: Container(
                    //                   padding: const EdgeInsets.symmetric(
                    //                       horizontal: 10, vertical: 5),
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(16),
                    //                     color: kWhite,
                    //                     boxShadow: [
                    //                       BoxShadow(
                    //                         color:
                    //                             Colors.black.withOpacity(0.2),
                    //                         blurRadius: 6,
                    //                         spreadRadius: 2,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   child: Hero(
                    //                     tag:
                    //                         '${controller.billPaymentCategories.value.categories![selectedCategory].products![index].productId}',
                    //                     child: Center(
                    //                       child: Image.network(
                    //                         '${controller.billPaymentCategories.value.categories![selectedCategory].products![index].logo}',
                    //                         fit: BoxFit.contain,
                    //                         errorBuilder:
                    //                             (context, error, stackTrace) =>
                    //                                 Image.asset(
                    //                           'assets/images/logo/parrot_logo.png',
                    //                           fit: BoxFit.contain,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //               itemCount: controller
                    //                   .billPaymentCategories
                    //                   .value
                    //                   .categories![selectedCategory]
                    //                   .products!
                    //                   .length,
                    //             ),
                    //           ),
                    // GetX<BillPaymentController>(
                    //   init: billPaymentController,
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
                    //     if (controller.billPaymentProducts.value.status !=
                    //         200) {
                    //       return SizedBox(
                    //         height: 35,
                    //         child: Center(
                    //           child: Text(
                    //             controller.billPaymentProducts.value.message!,
                    //             style: kBlackSmallMediumStyle,
                    //           ),
                    //         ),
                    //       );
                    //     }

                    //     if (controller.billPaymentProducts.value.products ==
                    //         null) {
                    //       return const SizedBox();
                    //     }
                    //     if (controller
                    //         .billPaymentProducts.value.products!.isEmpty) {
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
                    //     return FutureBuilder<BillPaymentCategoriesProducts?>(
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
                    //                         Get.to(() => BillPaymentScreen(
                    //                               index: index,
                    //                               billPaymentProduct: snapshot
                    //                                   .data!.products![index],
                    //                             ));
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
                    //                               '${snapshot.data!.products![index].id}',
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
                    //                       Get.to(() => BillPaymentScreen(
                    //                             index: index,
                    //                             billPaymentProduct: snapshot
                    //                                 .data!.products![index],
                    //                           ));
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
                    //                             '${snapshot.data!.products![index].id}',
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
