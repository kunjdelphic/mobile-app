import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:shimmer/shimmer.dart';

class DummyFavoritesItem extends StatefulWidget {
  const DummyFavoritesItem({super.key});

  @override
  State<DummyFavoritesItem> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<DummyFavoritesItem> {
  // late TopUpAmounts topUpAmounts;
  // Future<TopUpAmounts?>? _futureTopUpAmts;

  // while (widget.allFavoritesData.lastTransactionStatus == 'PENDING') {
  //   Future.delayed(const Duration(seconds: 5), () {});
  // }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      direction: Axis.horizontal,
      closeOnScroll: true,
      // endActionPane: ActionPane(
      //   motion: const ScrollMotion(),
      //   extentRatio: 0.45,
      //   children: [],
      // ),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: Get.width,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
          color: kWhite,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade200,
                          highlightColor: Colors.grey.shade50,
                          child: Container(
                              height: 62,
                              width: 77,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              )),
                        ),
                        // CachedNetworkImage(
                        //   fit: BoxFit.contain,
                        //   width: 50,
                        //   height: 50,
                        //   imageUrl: '${widget.allFavoritesData.productImage}',
                        //   placeholder: (context, url) {
                        //     return Shimmer.fromColors(
                        //       baseColor: Colors.grey.shade200,
                        //       highlightColor: Colors.grey.shade50,
                        //       child: Container(
                        //         height: 30,
                        //         width: 30,
                        //         margin: EdgeInsets.symmetric(horizontal: 5),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(12),
                        //           image: DecorationImage(
                        //               image: Image.asset(
                        //                 'assets/images/logo/parrot_logo.png',
                        //                 fit: BoxFit.cover,
                        //                 color: Colors.grey,
                        //                 height: 30,
                        //                 width: 30,
                        //               ).image),
                        //         ),
                        //       ),
                        //     );
                        //     // return Image.asset(
                        //     //   'assets/images/logo/parrot_logo.png',
                        //     //   fit: BoxFit.contain,
                        //     //   height: 50,
                        //     //   width: 50,
                        //     // );
                        //   },
                        //   errorWidget: (context, error, stackTrace) {
                        //     return Image.asset(
                        //       'assets/images/logo/parrot_logo.png',
                        //       fit: BoxFit.contain,
                        //     );
                        //   },
                        // ),
                        // CachedNetworkImage(
                        //     imageUrl: widget.allFavoritesData.productImage.toString(),
                        //     errorWidget: (context, url, error) {
                        //       return Padding(
                        //         padding: const EdgeInsets.all(4.0),
                        //         // child: Image.asset("assets/images/logo/parrot_logo.png"),
                        //         child: Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white)),
                        //       );
                        //     },
                        //     placeholder: (c, s) {
                        //       return Shimmer.fromColors(baseColor: Colors.grey.shade200, highlightColor: Colors.grey.shade50, child: Container(color: Colors.white));
                        //     })

                        // Image.network(
                        //   '${widget.allFavoritesData.productImage}',
                        //   fit: BoxFit.contain,
                        //   width: 50,
                        //   height: 50,
                        //   errorBuilder: (context, error, stackTrace) => Image.asset(
                        //     'assets/images/logo/parrot_logo.png',
                        //     fit: BoxFit.contain,
                        //     width: 50,
                        //     height: 50,
                        //   ),
                        // ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.grey.shade50,
                                child: Container(
                                  height: 23,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.grey.shade50,
                                child: Container(
                                  height: 10,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.grey.shade50,
                                child: Container(
                                  height: 10,
                                  width: Get.width * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.30,
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade50,
                      child: Container(
                        height: 12,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              height: 114,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey.shade200,
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.black26,
                child: Icon(
                  Icons.more_vert,
                  // color: Colors.black26,
                  size: 18,
                ),
              ),
              // child: const Icon(
              //  Icons.more_vert,
              //  color: Colors.black26,
              //  size: 18,
              //               ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () {},
      child: Slidable(
          key: widget.key,
          direction: Axis.horizontal,
          closeOnScroll: true,
          child: Container(
            margin: const EdgeInsets.all(8),
            width: Get.width,
            height: 130,
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.2),
              //     blurRadius: 6,
              //     spreadRadius: 2,
              //   ),
              // ],
              color: kWhite,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade50,
              child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  )),
            ),
          )),
    );
  }
}
