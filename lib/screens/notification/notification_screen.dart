import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

import '../../controllers/notification_controller.dart';
import '../../style/colors.dart';
import '../../style/colors.dart';
import '../../style/colors.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/dialogs/common_dialogs.dart';
import 'fullnotifcation_show.dart';
import 'model_notification.dart';
import 'server_maintainance_screen.dart';

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as image;

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   final NotificationController notificationController = Get.put(NotificationController());
//
//   @override
//   void initState() {
//     // notificationController.getNotification(context);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.5,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey)),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           "Notification",
//           // "Contact Support",
//           style: kBlackLargeStyle,
//         ),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 30,
//             ),
//             // SvgPicture.asset("assets/icons/notification/notification_bell.svg"),
//             Image.asset(
//               "assets/icons/notification/notification_bell_new.png",
//               width: 343,
//               height: 198,
//               fit: BoxFit.cover,
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             Text(
//               "No notification yet !",
//               style: kBlackDarkSuperLargeStyle,
//             ),
//             const SizedBox(
//               height: 17,
//             ),
//             Text(
//               "Stay in touch !\nYou will find all new updates here.",
//               // "We'll notify you when something arrives.",
//               style: kBlackLightMediumStyle,
//               textAlign: TextAlign.center,
//             ),
//             const Spacer(),
//             GradientButton(
//                 // text: "Return to home page",
//                 text: "Back",
//                 width: false,
//                 onTap: () {
//                   Get.back();
//                   // Get.to(() => ServerMaintenanceScreen());
//                 },
//                 widthSize: Get.width,
//                 buttonState: null),
//             const Spacer()
//           ],
//         ),
//       ),
//     );
//   }
// }

/// New Code
class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  final NotificationController notificationController = Get.put(NotificationController());

  List<bool> isExpandedList = List.generate(10, (index) => false);
  List<bool> showCheckboxList = List.generate(10, (index) => false);
  RxList<String> selectedList = <String>[].obs;
  // RxList<String> idSelect = <>[].obs;

  final int truncatedLength = 75;
  bool isShowAll = true;
  bool isUnread = false;

  static const double _singleLayerAnimationLength = 0.6;
  static const double _lastLayerAnimationStart = 1 - _singleLayerAnimationLength;

  bool get isGone => _animationController.isCompleted;
  bool get isInProgress => _animationController.isAnimating;

  /// Main snap effect controller
  late AnimationController _animationController;

  /// Key to get image of a [widget.child]
  final GlobalKey _globalKey = GlobalKey();

  /// Layers of image
  List<Uint8List> _layers = [];

  /// Values from -1 to 1 to dislocate the layers a bit
  late List<double> _randoms;

  /// Size of child widget
  late Size size;

  // late final VoidCallback onSnapped;

  @override
  void initState() {
    getNotificationData();
    super.initState();

    selectedList.forEach((item) {
      // for (int i = 0; i < selectedList.length; i++) {
      //   snappableKeys[i] = GlobalKey<SnappableState>();
      // }
      snappableKeys[0] = GlobalKey<SnappableState>();
      // snappableKeys[int.parse(item.toString())] = GlobalKey<SnappableState>();
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onSnapped(0);
      }
    });
  }

  onSnapped(int index) async {
    final key = snappableKeys[0];
    print("snappableKeys ++++ ${key}");
    if (key != null && key.currentState != null) {
      key.currentState!.snap();
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        selectedList.remove(index);
        // notificationController.userNotificationDelete(
        //   id: "${selectedList.toList()}",
        // );
        snappableKeys.remove(index); // Clean up the key for the removed item
      });
    }
  }

  // void deleteItem(int index) async {
  //   final key = snappableKeys[index];
  //   if (key != null && key.currentState != null) {
  //     // Trigger snap animation
  //     key.currentState!.snap();
  //     // Wait for the animation duration
  //     await Future.delayed(const Duration(milliseconds: 500));
  //     // Remove the item from the list
  //     setState(() {
  //       selectedList.remove(0);
  //       snappableKeys.remove(index); // Clean up the key for the removed item
  //     });
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getNotificationData() async {
    await notificationController.getNotification().then((value) {
      final List<GetNotificationModelNotifications> unreadData = notificationController.getNotificationModel.value.notifications ?? [];

      notificationController.unreadList.value = unreadData.where((element) => element.read == false).toList();
    });
    print("Appppp  +++++ Status${notificationController.getNotificationModel.value.message}");
  }

  Map<int, GlobalKey<SnappableState>> snappableKeys = {};

  Future<void> snap() async {
    //get image from child
    final fullImage = await _getImageFromWidget();

    //create an image for every bucket
    List<image.Image> images = List<image.Image>.generate(
      16,
      (i) => image.Image(fullImage.width, fullImage.height),
    );

    //for every line of pixels
    for (int y = 0; y < fullImage.height; y++) {
      //generate weight list of probabilities determining
      //to which bucket should given pixels go
      List<int> weights = List.generate(
        16,
        (bucket) => _gauss(
          y / fullImage.height,
          bucket / 16,
        ),
      );
      int sumOfWeights = weights.fold(0, (sum, el) => sum + el);

      //for every pixel in a line
      for (int x = 0; x < fullImage.width; x++) {
        //get the pixel from fullImage
        int pixel = fullImage.getPixel(x, y);
        //choose a bucket for a pixel
        int imageIndex = _pickABucket(weights, sumOfWeights);
        //set the pixel from chosen bucket
        images[imageIndex].setPixel(x, y, pixel);
      }
    }

    //* compute allows us to run _encodeImages in separate isolate
    //* as it's too slow to work on the main thread
    _layers = await compute<List<image.Image>, List<Uint8List>>(_encodeImages, images);
    if (!mounted) return;
    //prepare random dislocations and set state
    setState(() {
      _randoms = List.generate(
        16,
        (i) => (math.Random().nextDouble() - 0.5) * 2,
      );
    });

    //give a short delay to draw images
    await Future.delayed(const Duration(milliseconds: 100));

    //start the snap!

    if (mounted) {
      _animationController.forward();
      onSnapped(0);
      // deleteItem(0);
    }
  }

  /// I am... IRON MAN   ~Tony Stark
  void reset() {
    setState(() {
      _layers = [];
      _animationController.reset();
    });
  }

  Widget _imageToWidget(Uint8List layer) {
    //get layer's index in the list
    int index = _layers.indexOf(layer);

    //based on index, calculate when this layer should start and end
    double animationStart = (index / _layers.length) * _lastLayerAnimationStart;
    double animationEnd = animationStart + _singleLayerAnimationLength;

    //create interval animation using only part of whole animation
    CurvedAnimation animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        animationStart,
        animationEnd,
        curve: Curves.easeOut,
      ),
    );

    Offset randomOffset = Offset(64, 32).scale(
      _randoms[index],
      _randoms[index],
    );

    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(64, -32) + randomOffset,
    ).animate(animation);

    return AnimatedBuilder(
      animation: _animationController,
      child: Image.memory(layer),
      builder: (context, child) {
        return Transform.translate(
          offset: offsetAnimation.value,
          child: Opacity(
            opacity: math.cos(animation.value * math.pi / 2),
            child: child,
          ),
        );
      },
    );
  }

  /// Returns index of a randomly chosen bucket
  int _pickABucket(List<int> weights, int sumOfWeights) {
    int rnd = math.Random().nextInt(sumOfWeights);
    int chosenImage = 0;
    for (int i = 0; i < 16; i++) {
      if (rnd < weights[i]) {
        chosenImage = i;
        break;
      }
      rnd -= weights[i];
    }
    return chosenImage;
  }

  /// Gets an Image from a [child] and caches [size] for later us
  Future<image.Image> _getImageFromWidget() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 50));
    });

    // await Future.delayed(Duration(milliseconds: 50));
    RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //cache image for later
    size = boundary.size;
    var img = await boundary.toImage();
    ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    return image.decodeImage(pngBytes!)!;
  }

  int _gauss(double center, double value) => (1000 * math.exp(-(math.pow((value - center), 2) / 0.14))).round();

  @override
  Widget build(BuildContext context) {
    print("Status +++++ Status${notificationController.getNotificationModel.value.message}");
    return DefaultTabController(
      length: 2, // Two tabs: "All" and "Unread"
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.grey)),
          title: Builder(builder: (context) {
            // bool isinfo = false;
            // int indexs = 0;
            // selectedList.forEach((element) {
            //   if (element) {
            //     isinfo = true;
            //     indexs++;
            //   }
            // });
            return selectedList.isNotEmpty
                ? Text(
                    "${selectedList.length} Selected",
                    style: kBlackLargeStyle,
                  )
                : Text(
                    "Notification",
                    style: kBlackLargeStyle,
                  );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Builder(builder: (context) {
                // bool isinfo = false;
                // selectedList.forEach((element) {
                //   if (element) {
                //     isinfo = true;
                //   }
                // });
                return selectedList.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          notificationDeleteDialog(
                            onTap: () {
                              print("Selected Id +++++ ${selectedList.toList()}");
                              // notificationController.userNotificationDelete(
                              //     id: "id",
                              // );
                              Get.back();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                snap();
                              });
                              // onSnapped(0);
                              print("9898989898 ${onSnapped(0)}");
                            },
                            context: context,
                            title1: "Delete ${selectedList.length} Notification !",
                            title2: "Are you sure you want to delete selected notifications.",
                          );
                        },
                        child: SvgPicture.asset(
                          "assets/icons/notification_delete.svg",
                          height: 20,
                          width: 20,
                        ),
                      )
                    : SizedBox.shrink();
              }),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: notificationController.getNotificationModel.stream,
            builder: (context, snapshot) {
              if (notificationController.getNotificationModel.value.notifications?.length == 0) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // SvgPicture.asset("assets/icons/notification/notification_bell.svg"),
                      Image.asset(
                        "assets/icons/notification/notification_bell_new.png",
                        width: 343,
                        height: 198,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "No notification yet !",
                        style: kBlackDarkSuperLargeStyle,
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Text(
                        "Stay in touch !\nYou will find all new updates here.",
                        // "We'll notify you when something arrives.",
                        style: kBlackLightMediumStyle,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      GradientButton(
                          // text: "Return to home page",
                          text: "Back",
                          width: false,
                          onTap: () {
                            Get.back();
                            // Get.to(() => ServerMaintenanceScreen());
                          },
                          widthSize: Get.width,
                          buttonState: null),
                      const Spacer()
                    ],
                  ),
                );
              }

              if (notificationController.getNotificationModel.value.notifications == null) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        // margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 5),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade200,
                                    highlightColor: Colors.grey.shade50,
                                    child: Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        color: kWhite,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(color: Colors.grey.shade50, width: 1.3),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade50,
                                          child: Container(
                                            height: 10,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey.shade50,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade200,
                                          highlightColor: Colors.grey.shade50,
                                          child: Container(
                                            height: 10,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.grey.shade50,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              isShowAll = true;
                              setState(() {});
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "All",
                                      style: kBlackDarkLargeStyle.copyWith(color: isShowAll == true ? kBlack : Color(0xFF757474)),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      height: 20,
                                      width: 24,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: Color(0xffF3F7F2), borderRadius: BorderRadius.circular(9)),
                                      child: Text("${notificationController.getNotificationModel.value.notifications?.length}"),
                                    )
                                  ],
                                ),
                                SizedBox(height: 5),
                                isShowAll
                                    ? Container(
                                        height: 4,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              kGreenBtnColor1,
                                              kGreenBtnColor2,
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(height: 4, width: 80)
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              isShowAll = false;
                              setState(() {});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 90,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Unread",
                                        style: kBlackDarkLargeStyle.copyWith(color: isShowAll == false ? kBlack : Color(0xFF757474)),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        height: 20,
                                        width: 24,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Color(0xffF3F7F2), borderRadius: BorderRadius.circular(9)),
                                        child: Text("${notificationController.unreadList.length}"),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                isShowAll
                                    ? SizedBox(height: 4, width: 95)
                                    : Container(
                                        height: 4,
                                        width: 95,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5),
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              kGreenBtnColor1,
                                              kGreenBtnColor2,
                                            ],
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                  isShowAll
                      ? Expanded(
                          child: StreamBuilder(
                              stream: notificationController.getNotificationModel.stream,
                              builder: (context, snapshot) {
                                return ListView.builder(
                                  itemCount: notificationController.getNotificationModel.value.notifications?.length,
                                  itemBuilder: (context, index) {
                                    final notificationData = notificationController.getNotificationModel.value.notifications?[index];
                                    final String fullText = "${notificationData?.message}";
                                    String formatNotificationTime(String? createdAt) {
                                      if (createdAt == null) {
                                        return "Invalid date";
                                      }

                                      DateTime notificationTime = DateTime.parse(createdAt);

                                      // Get the current time
                                      DateTime now = DateTime.now();

                                      // Calculate the difference
                                      Duration difference = now.difference(notificationTime);

                                      // Display the difference in a user-friendly way
                                      if (difference.inDays > 0) {
                                        return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
                                      } else if (difference.inHours > 0) {
                                        return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
                                      } else if (difference.inMinutes > 0) {
                                        return "${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago";
                                      } else {
                                        return "Just now";
                                      }
                                    }

                                    // if (_layers != []) ..._layers.map(_imageToWidget);
                                    return Stack(
                                      children: [
                                        if (_layers != []) ..._layers.map(_imageToWidget),
                                        AnimatedBuilder(
                                          animation: _animationController,
                                          builder: (context, child) {
                                            return _animationController.isDismissed ? child! : Container();
                                          },
                                          child: RepaintBoundary(
                                            key: _globalKey,
                                            child: GestureDetector(
                                              onLongPress: () {
                                                setState(() {
                                                  showCheckboxList[index] = true;
                                                  // selectedList.value[index] = true;
                                                  if (selectedList.contains(notificationData?.id)) {
                                                    selectedList.remove(notificationData?.id);
                                                  } else {
                                                    if (notificationData?.id != null && notificationData?.id != "") {
                                                      selectedList.add(notificationData?.id ?? "");
                                                    }
                                                  }
                                                  // isLongPress = true;
                                                  // Show checkbox on long press
                                                });
                                              },
                                              onTap: () {
                                                // bool isinfo = false;
                                                // selectedList.forEach((element) {
                                                //   if (element) {
                                                //     isinfo = true;
                                                //   }
                                                // });
                                                if (selectedList.contains(notificationData?.id)) {
                                                  // print("898989899898 ${isinfo} ${selectedList[index]}");
                                                  if (selectedList.contains(notificationData?.id)) {
                                                    setState(() {
                                                      selectedList.remove(notificationData?.id);
                                                      showCheckboxList[index] = false;
                                                    });
                                                  } else {
                                                    // print("12121212121212 ${isinfo}");
                                                    setState(() {
                                                      // selectedList[index] = true;
                                                      if (notificationData?.id != null && notificationData?.id != "") {
                                                        selectedList.add(notificationData?.id ?? "");
                                                      }
                                                      showCheckboxList[index] = true;
                                                    });
                                                  }
                                                } else {
                                                  Get.to(() => FullNotificationScreen(id: "${notificationData?.id}"));
                                                }
                                                // if (selectedList[index] = true) {
                                                //   showCheckboxList[index] = true;
                                                //   selectedList[index] = true;
                                                //   setState(() {});
                                                // }
                                              },
                                              child: Container(
                                                height: 97,
                                                margin: const EdgeInsets.symmetric(vertical: 5),
                                                child: Slidable(
                                                  endActionPane: ActionPane(
                                                    motion: const ScrollMotion(),
                                                    extentRatio: 0.2,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          notificationDeleteDialog(
                                                            onTap: () async {
                                                              Get.back();
                                                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                snap();
                                                              });
                                                            },
                                                            context: context,
                                                            title1: "Delete Notification !",
                                                            title2: "Are you sure you want to delete selected notifications.",
                                                          );
                                                        },
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.all(28),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFFFAEBEA),
                                                          ),
                                                          child: SvgPicture.asset(
                                                            'assets/icons/notification_delete.svg',
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10),
                                                    // margin: const EdgeInsets.symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          notificationData?.read == true ? Colors.white : Color(0xFFEDF5EB),
                                                          notificationData?.read == true ? Colors.white : Color(0xFFEDF5EB),
                                                        ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 20),
                                                          child: Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  notificationData?.read == true ? Colors.white : Color(0xff0E76BC),
                                                                  notificationData?.read == true ? Colors.white : Color(0xff283891),
                                                                ],
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(width: 5),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 5),
                                                                child: Container(
                                                                  height: 44,
                                                                  width: 44,
                                                                  padding: EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                    color: kWhite,
                                                                    borderRadius: BorderRadius.circular(22),
                                                                    border: Border.all(color: Colors.grey.shade100, width: 1.3),
                                                                  ),
                                                                  child: Image.asset(
                                                                    notificationData?.type == "SERVER_UPDATE" ? "assets/images/server_update.png" : "assets/images/earning _wallet.png",
                                                                    // height: 24,
                                                                    // width: 24,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(width: 8),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          "${notificationData?.title}",
                                                                          style: kBlackLargeStyle,
                                                                        ),
                                                                        Text(
                                                                          formatNotificationTime(notificationData?.createdAt),
                                                                          style: kBlackSmall.copyWith(
                                                                            fontSize: 11,
                                                                            color: Color(0xFF575757),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 4,
                                                                          child: Text(
                                                                            isExpandedList[index]
                                                                                ? fullText
                                                                                : fullText.length > truncatedLength
                                                                                    ? fullText.substring(0, truncatedLength) + '...'
                                                                                    : fullText,
                                                                            style: kBlackSmall, // Your text style
                                                                          ),
                                                                        ),
                                                                        // if (showCheckboxList[index]) // Show checkbox only when long pressed

                                                                        Expanded(
                                                                          child: Builder(builder: (context) {
                                                                            // bool isShow = false;
                                                                            // selectedList.forEach((element) {
                                                                            //   if (element) {
                                                                            //     isShow = true;
                                                                            //   }
                                                                            // });
                                                                            return Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: selectedList.contains(notificationData?.id)
                                                                                  ? Obx(() {
                                                                                      return GestureDetector(
                                                                                        onTap: () {
                                                                                          setState(() {});
                                                                                          if (selectedList.contains(notificationData?.id)) {
                                                                                            selectedList.remove(notificationData?.id);
                                                                                          } else {
                                                                                            if (notificationData?.id != null && notificationData?.id != "") {
                                                                                              selectedList.add(notificationData?.id ?? "");
                                                                                            }
                                                                                          }
                                                                                          // selectedList.value[index] = !selectedList.value[index];
                                                                                        },
                                                                                        child: Container(
                                                                                          // color: Colors.red,
                                                                                          child: (selectedList.contains(notificationData?.id))
                                                                                              ? Icon(CupertinoIcons.checkmark_square_fill, color: kColorPrimary)
                                                                                              : Icon(Icons.check_box_outline_blank_rounded, color: Colors.grey.shade400),
                                                                                          // child: Checkbox(
                                                                                          //   value: selectedList.value[index],
                                                                                          //   activeColor: kColorPrimary,
                                                                                          //   onChanged: (value) {
                                                                                          //     setState(() {
                                                                                          //       selectedList.value[index] = value ?? false;
                                                                                          //     });
                                                                                          //   },
                                                                                          // ),
                                                                                        ),
                                                                                      );
                                                                                    })
                                                                                  : SizedBox(height: 24),
                                                                            );
                                                                          }),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          Get.to(() => FullNotificationScreen(id: "${notificationData?.id}"));
                                                                          // isExpandedList[index] = !isExpandedList[index];
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                        isExpandedList[index] ? 'View Less' : 'View More',
                                                                        style: kBlackSmall.copyWith(
                                                                          color: Colors.blue,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }),
                        )
                      : Expanded(
                          child: StreamBuilder(
                              stream: notificationController.getNotificationModel.stream,
                              builder: (context, snapshot) {
                                return ListView.builder(
                                  itemCount: notificationController.unreadList.length,
                                  itemBuilder: (context, index) {
                                    final unreadData = notificationController.unreadList[index];
                                    final String fullTextUnread = "${unreadData.message}";
                                    String formatNotificationTime(String? createdAt) {
                                      if (createdAt == null) {
                                        return "Invalid date";
                                      }

                                      DateTime notificationTime = DateTime.parse(createdAt);

                                      // Get the current time
                                      DateTime now = DateTime.now();

                                      // Calculate the difference
                                      Duration difference = now.difference(notificationTime);

                                      // Display the difference in a user-friendly way
                                      if (difference.inDays > 0) {
                                        return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
                                      } else if (difference.inHours > 0) {
                                        return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
                                      } else if (difference.inMinutes > 0) {
                                        return "${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago";
                                      } else {
                                        return "Just now";
                                      }
                                    }

                                    return GestureDetector(
                                      onLongPress: () {
                                        setState(() {
                                          showCheckboxList[index] = true;
                                          if (unreadData.id != null && unreadData.id != "") {
                                            selectedList.add(unreadData.id ?? "");
                                          }
                                          // selectedList.value[index] = true;
                                          // isLongPress = true;
                                          // Show checkbox on long press
                                        });
                                      },
                                      onTap: () {
                                        // bool isinfo = false;
                                        // selectedList.forEach((element) {
                                        //   if (element) {
                                        //     isinfo = true;
                                        //   }
                                        // });
                                        if (selectedList.contains(unreadData.id)) {
                                          // print("898989899898 ${isinfo} ${selectedList[index]}");
                                          if (selectedList[index] == true) {
                                            setState(() {
                                              // selectedList[index] = false;
                                              selectedList.remove(unreadData.id);
                                              showCheckboxList[index] = false;
                                            });
                                          } else {
                                            // print("12121212121212 ${isinfo}");
                                            setState(() {
                                              // selectedList[index] = true;
                                              if (unreadData.id != null && unreadData.id != "") {
                                                selectedList.add(unreadData.id ?? "");
                                              }
                                              showCheckboxList[index] = true;
                                            });
                                          }
                                        } else {
                                          Get.to(() => FullNotificationScreen(id: "${unreadData.id}"));
                                        }
                                        // if (selectedList[index] = true) {
                                        //   showCheckboxList[index] = true;
                                        //   selectedList[index] = true;
                                        //   setState(() {});
                                        // }
                                      },
                                      child: Container(
                                        height: 97,
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        child: Slidable(
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            extentRatio: 0.2,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  notificationDeleteDialog(
                                                    onTap: () {},
                                                    context: context,
                                                    title1: "Delete Notification !",
                                                    title2: "Are you sure you want to delete selected notifications.",
                                                  );
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.all(28),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFAEBEA),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/notification_delete.svg',
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                              // SlidableAction(
                                              //   onPressed: (context) {},
                                              //   backgroundColor: Color(0xFFFAEBEA),
                                              //   foregroundColor: Colors.white,
                                              //   icon: Icons.delete,
                                              //   // label: 'Delete',
                                              // ),
                                            ],
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            // margin: const EdgeInsets.symmetric(vertical: 5),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  unreadData?.read == true ? Colors.white : Color(0xFFEDF5EB),
                                                  unreadData?.read == true ? Colors.white : Color(0xFFEDF5EB),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        unreadData?.read == true ? Colors.white : Color(0xff0E76BC),
                                                        unreadData?.read == true ? Colors.white : Color(0xff283891),
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Container(
                                                        height: 44,
                                                        width: 44,
                                                        decoration: BoxDecoration(
                                                          color: kWhite,
                                                          borderRadius: BorderRadius.circular(22),
                                                          border: Border.all(color: Colors.grey, width: 1.3),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${unreadData.title}",
                                                                  style: kBlackLargeStyle,
                                                                ),
                                                                Text(
                                                                  formatNotificationTime(unreadData.createdAt),
                                                                  style: kBlackSmall.copyWith(
                                                                    fontSize: 11,
                                                                    color: Color(0xFF575757),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(
                                                                    isExpandedList[index]
                                                                        ? fullTextUnread
                                                                        : fullTextUnread.length > truncatedLength
                                                                            ? fullTextUnread.substring(0, truncatedLength) + '...'
                                                                            : fullTextUnread,
                                                                    style: kBlackSmall, // Your text style
                                                                  ),
                                                                ),
                                                                if (showCheckboxList[index]) // Show checkbox only when long pressed

                                                                  Expanded(
                                                                    child: Builder(builder: (context) {
                                                                      // bool isShow = false;
                                                                      // selectedList.forEach((element) {
                                                                      //   if (element) {
                                                                      //     isShow = true;
                                                                      //   }
                                                                      // });
                                                                      return Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: selectedList.contains(unreadData.id)
                                                                            ? Obx(() {
                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {});
                                                                                    if (selectedList.contains(unreadData.id)) {
                                                                                      selectedList.remove(unreadData.id);
                                                                                    } else {
                                                                                      if (unreadData.id != null && unreadData.id != "") {
                                                                                        selectedList.add(unreadData.id ?? "");
                                                                                      }
                                                                                    }
                                                                                    // selectedList[index].add() = !selectedList.value[index];
                                                                                  },
                                                                                  child: Container(
                                                                                    // color: Colors.red,
                                                                                    child: (selectedList.contains(unreadData.id))
                                                                                        ? Icon(CupertinoIcons.checkmark_square_fill, color: kColorPrimary)
                                                                                        : Icon(Icons.check_box_outline_blank_rounded, color: Colors.grey.shade400),
                                                                                  ),
                                                                                );
                                                                              })
                                                                            : SizedBox(height: 24),
                                                                      );
                                                                    }),
                                                                  ),
                                                              ],
                                                            ),
                                                            fullTextUnread.length > 15
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        isExpandedList[index] = !isExpandedList[index];
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      isExpandedList[index] ? 'View Less' : 'View More',
                                                                      style: kBlackSmall.copyWith(
                                                                        color: Colors.blue,
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        ),
                ],
              );
            }),
      ),
    );
  }
}

class Snappable extends StatefulWidget {
  /// Widget to be snapped
  final Widget child;

  /// Direction and range of snap effect
  /// (Where and how far will particles go)
  final Offset offset;

  /// Duration of whole snap animation
  final Duration duration;

  /// How much can particle be randomized,
  /// For example if [offset] is (100, 100) and [randomDislocationOffset] is (10,10),
  /// Each layer can be moved to maximum between 90 and 110.
  final Offset randomDislocationOffset;

  /// Number of layers of images,
  /// The more of them the better effect but the more heavy it is for CPU
  final int numberOfBuckets;

  /// Quick helper to snap widgets when touched
  /// If true wraps the widget in [GestureDetector] and starts [snap] when tapped
  /// Defaults to false
  final bool snapOnTap;

  /// Function that gets called when snap ends
  final VoidCallback onSnapped;

  const Snappable({
    Key? key,
    required this.child,
    this.offset = const Offset(64, -32),
    this.duration = const Duration(milliseconds: 5000),
    this.randomDislocationOffset = const Offset(64, 32),
    this.numberOfBuckets = 16,
    this.snapOnTap = false,
    required this.onSnapped,
  }) : super(key: key);

  @override
  SnappableState createState() => SnappableState();
}

class SnappableState extends State<Snappable> with SingleTickerProviderStateMixin {
  static const double _singleLayerAnimationLength = 0.6;
  static const double _lastLayerAnimationStart = 1 - _singleLayerAnimationLength;

  bool get isGone => _animationController.isCompleted;
  bool get isInProgress => _animationController.isAnimating;

  /// Main snap effect controller
  late AnimationController _animationController;

  /// Key to get image of a [widget.child]
  final GlobalKey _globalKey = GlobalKey();

  /// Layers of image
  List<Uint8List> _layers = [];

  /// Values from -1 to 1 to dislocate the layers a bit
  late List<double> _randoms;

  /// Size of child widget
  late Size size;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onSnapped();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: widget.snapOnTap ? () => isGone ? reset() : snap() : null,
      child: Stack(
        children: <Widget>[
          // if (_layers != []) ..._layers.map(_imageToWidget),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return _animationController.isDismissed ? child! : Container();
            },
            child: RepaintBoundary(
              key: _globalKey,
              child: widget.child,
            ),
          )
        ],
      ),
    );
  }

  /// I am... INEVITABLE      ~Thanos
  Future<void> snap() async {
    //get image from child
    final fullImage = await _getImageFromWidget();

    //create an image for every bucket
    List<image.Image> images = List<image.Image>.generate(
      widget.numberOfBuckets,
      (i) => image.Image(fullImage.width, fullImage.height),
    );

    //for every line of pixels
    for (int y = 0; y < fullImage.height; y++) {
      //generate weight list of probabilities determining
      //to which bucket should given pixels go
      List<int> weights = List.generate(
        widget.numberOfBuckets,
        (bucket) => _gauss(
          y / fullImage.height,
          bucket / widget.numberOfBuckets,
        ),
      );
      int sumOfWeights = weights.fold(0, (sum, el) => sum + el);

      //for every pixel in a line
      for (int x = 0; x < fullImage.width; x++) {
        //get the pixel from fullImage
        int pixel = fullImage.getPixel(x, y);
        //choose a bucket for a pixel
        int imageIndex = _pickABucket(weights, sumOfWeights);
        //set the pixel from chosen bucket
        images[imageIndex].setPixel(x, y, pixel);
      }
    }

    //* compute allows us to run _encodeImages in separate isolate
    //* as it's too slow to work on the main thread
    _layers = await compute<List<image.Image>, List<Uint8List>>(_encodeImages, images);
    if (!mounted) return;
    //prepare random dislocations and set state
    setState(() {
      _randoms = List.generate(
        widget.numberOfBuckets,
        (i) => (math.Random().nextDouble() - 0.5) * 2,
      );
    });

    //give a short delay to draw images
    await Future.delayed(const Duration(milliseconds: 100));

    //start the snap!

    if (mounted) {
      _animationController.forward();
      widget.onSnapped();
    }
  }

  // / I am... IRON MAN   ~Tony Stark
  void reset() {
    setState(() {
      _layers = [];
      _animationController.reset();
    });
  }

  Widget _imageToWidget(Uint8List layer) {
    //get layer's index in the list
    int index = _layers.indexOf(layer);

    //based on index, calculate when this layer should start and end
    double animationStart = (index / _layers.length) * _lastLayerAnimationStart;
    double animationEnd = animationStart + _singleLayerAnimationLength;

    //create interval animation using only part of whole animation
    CurvedAnimation animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        animationStart,
        animationEnd,
        curve: Curves.easeOut,
      ),
    );

    Offset randomOffset = widget.randomDislocationOffset.scale(
      _randoms[index],
      _randoms[index],
    );

    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.offset + randomOffset,
    ).animate(animation);

    return AnimatedBuilder(
      animation: _animationController,
      child: Image.memory(layer),
      builder: (context, child) {
        return Transform.translate(
          offset: offsetAnimation.value,
          child: Opacity(
            opacity: math.cos(animation.value * math.pi / 2),
            child: child,
          ),
        );
      },
    );
  }

  /// Returns index of a randomly chosen bucket
  int _pickABucket(List<int> weights, int sumOfWeights) {
    int rnd = math.Random().nextInt(sumOfWeights);
    int chosenImage = 0;
    for (int i = 0; i < widget.numberOfBuckets; i++) {
      if (rnd < weights[i]) {
        chosenImage = i;
        break;
      }
      rnd -= weights[i];
    }
    return chosenImage;
  }

  /// Gets an Image from a [child] and caches [size] for later us
  Future<image.Image> _getImageFromWidget() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 50));
    });

    // await Future.delayed(Duration(milliseconds: 50));
    RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //cache image for later
    size = boundary.size;
    var img = await boundary.toImage();
    ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    return image.decodeImage(pngBytes!)!;
  }

  int _gauss(double center, double value) => (1000 * math.exp(-(math.pow((value - center), 2) / 0.14))).round();
}

/// This is slow! Run it in separate isolate
List<Uint8List> _encodeImages(List<image.Image> images) {
  return images.map((img) => Uint8List.fromList(image.encodePng(img))).toList();
}
