import 'dart:async';

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../style/colors.dart';
import '../../style/style.dart';
import '../../widgets/buttons/gradient_button.dart';

class EnableAccessScreen extends StatefulWidget {
  final bool? camera;
  final bool? photo;

  const EnableAccessScreen({super.key, this.camera, this.photo});

  @override
  State<EnableAccessScreen> createState() => _EnableAccessScreenState();
}

class _EnableAccessScreenState extends State<EnableAccessScreen> {
  final PageController _pageController = PageController();

  RxBool isCameraOn = false.obs; // Tracks whether camera permission is on or off
  // Timer? _timer;

  // @override
  // void initState() {
  //   super.initState();
  //   _startImageToggleTimer();
  // }
  //
  // void _startImageToggleTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     // setState(() {
  //     isCameraOn.value = !isCameraOn.value; // Toggle between camera on/off image
  //     // });
  //   });
  // }

  // @override
  // void dispose() {
  //   // Cancel the timer when the widget is disposed to prevent memory leaks
  //   _timer?.cancel();
  //   super.dispose();
  // }
  int _currentIndex = 0;
  int _cameraAppleIndex = 0;
  int _photoIndex = 0;
  int _photoAppleIndex = 0;
  int _contactIndex = 0;
  int _contactAppleIndex = 0;
  late Timer _timer;

  // List of images to display
  final List<String> _images = [
    'assets/images/permission.png',
    'assets/images/android_camera.png',
    'assets/images/camera_allow_new.png',
  ];

  final List<Map<String, String>> _camera = [
    {
      'title': 'Step-1',
      'description': 'Go to permissions in ParrotPos app info',
      'image': 'assets/images/permission.png',
    },
    {
      'title': 'Step-2',
      'description': 'In App Permissions, click on Camera',
      'image': 'assets/images/android_camera.png',
    },
    {
      'title': 'Step-3',
      'description': 'In Camera Permission, Allow the permission',
      'image': 'assets/images/camera_allow_new.png',
    },
  ];

  final List<Map<String, String>> _cameraApple = [
    {
      'title': 'Step-1',
      'description': 'Go to ParrotPos app settings Turn On Camera',
      'image': 'assets/images/apple_camera_off.png',
    },
    {
      'title': 'Step-2',
      'description': 'In App Permissions click on Camera',
      'image': 'assets/images/apple_camera_on.png',
    },
    {
      'title': 'Step-3',
      'description': 'In Camera Permission click on ParrotPos',
      'image': 'assets/images/camer_allow_back.png',
    },
  ];

  final List<Map<String, String>> _photo = [
    {
      'title': 'Step-1',
      'description': 'Go to permissions In ParrotPos app info',
      'image': 'assets/images/permission.png',
    },
    {
      'title': 'Step-2',
      'description': 'In App Permissions click on Photo',
      'image': 'assets/images/photos_permission.png',
    },
    {
      'title': 'Step-3',
      'description': 'In Photo Permission Allow the permission',
      'image': 'assets/images/photo_permission_allow.png',
    },
  ];

  final List<Map<String, String>> _photoApple = [
    {
      'title': 'Step-1',
      'description': 'Go to Parrots pos app settings Select Photos',
      'image': 'assets/images/apple_photo.png',
    },
    {
      'title': 'Step-2',
      'description': 'In Photos Select Full Access',
      'image': 'assets/images/full_access_photo.png',
    },
    {
      'title': 'Step-3',
      'description': 'Select Allow Full Access',
      'image': 'assets/images/allow_full_access_photo.png',
    },
    {
      'title': 'Step-4',
      'description': 'Go to Parrots pos app.',
      'image': 'assets/images/go_app_photo.png',
    },
  ];

  final List<Map<String, String>> _contact = [
    {
      'title': 'Step-1',
      'description': 'Go to permissions In ParrotPos app info',
      'image': 'assets/images/permission.png',
    },
    {
      'title': 'Step-2',
      'description': 'In App Permissions click on Contacts',
      'image': 'assets/images/contact_permission.png',
    },
    {
      'title': 'Step-3',
      'description': 'In Contacts Permission Allow the permission',
      'image': 'assets/images/contact_allow.png',
    },
  ];

  final List<Map<String, String>> _contactApple = [
    {
      'title': 'Step-1',
      'description': 'Go to ParrotPos app settings Turn On Contact',
      'image': 'assets/images/apple_contact_off.png',
    },
    {
      'title': 'Step-2',
      'description': 'In App Permissions click on Contacts',
      'image': 'assets/images/apple_contact_on.png',
    },
    {
      'title': 'Step-3',
      'description': 'In Contacts Permission click on ParrotPos',
      'image': 'assets/images/allow_contact_allow.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Timer to change image every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _camera.length;
        _cameraAppleIndex = (_cameraAppleIndex + 1) % _cameraApple.length;
        _photoIndex = (_photoIndex + 1) % _photo.length;
        _photoAppleIndex = (_photoAppleIndex + 1) % _photoApple.length;
        _contactIndex = (_contactIndex + 1) % _contact.length;
        _contactAppleIndex = (_contactAppleIndex + 1) % _contactApple.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("---- Camera IS ${widget.camera}");
    print("---- Photos IS ${widget.photo}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.camera == true
              ? "Enable camera Access"
              : widget.photo == true
                  ? "Enable Photo Access"
                  : "Enable Contact Access",
          style: kBlackLargeStyle,
        ),
      ),
      body: Column(
        children: [
          widget.camera == true
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Follow these steps to allow ParrotPos access to camera in order to upload selfie & ID.",
                      style: kBlackLargeStyle.copyWith(
                        fontSize: 14,
                        color: kBlack61,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Platform.isAndroid
                        ? Column(
                            children: [
                              Center(
                                child: GestureDetector(
                                  onHorizontalDragEnd: (val) {
                                    if (_currentIndex == 2) {
                                      _currentIndex = 0;
                                    } else {
                                      _currentIndex = _currentIndex + 1;
                                    }

                                    setState(() {});
                                  },
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 10), // Animation duration
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      // return FadeTransition(opacity: animation, child: child);
                                      // Add a curve for smooth zoom-out then zoom-in effect
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.ease, // Smooth transition
                                      );

                                      // Scale transition for zoom out and zoom in effect
                                      return ScaleTransition(
                                        scale: curvedAnimation,
                                        child: child,
                                      );
                                    },
                                    child: Column(
                                      key: ValueKey<int>(_currentIndex), // Unique key for each step
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonShadeContainer(title: _camera[_currentIndex]['title']!),
                                        const SizedBox(height: 4),
                                        Text(
                                          _camera[_currentIndex]['description']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Corresponding Image
                                        Image.asset(
                                          _camera[_currentIndex]['image']!,
                                          key: ValueKey<int>(_currentIndex), // Ensure unique key for each image
                                          // width: 300, // Set width as required
                                          // height: 300, // Set height as required
                                        ),
                                      ],
                                    ),
                                    // Column(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     const CommonShadeContainer(title: "Step-1"),
                                    //     const SizedBox(height: 4),
                                    //     Text(
                                    //       "Go to permissions In ParrotPos app info",
                                    //       style: kBlackLargeStyle.copyWith(
                                    //         fontSize: 14,
                                    //         color: kBlack61,
                                    //       ),
                                    //     ),
                                    //     Image.asset(
                                    //       _images[_currentIndex],
                                    //       key: ValueKey<int>(_currentIndex), // Ensure unique key for each image
                                    //       // width: 300, // Set width as required
                                    //       // height: 300, // Set height as required
                                    //     ),
                                    //   ],
                                    // ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   height: 400,
                              //   child: CarouselSlider.builder(
                              //     itemCount: _camera.length,
                              //     itemBuilder: (context, index, realIdx) {
                              //       return Center(
                              //         child: AnimatedSwitcher(
                              //           duration: Duration(milliseconds: 200), // Animation duration
                              //           transitionBuilder: (Widget child, Animation<double> animation) {
                              //             // Add a curve for smooth zoom-out then zoom-in effect
                              //             final curvedAnimation = CurvedAnimation(
                              //               parent: animation,
                              //               curve: Curves.easeInOut, // Smooth transition
                              //             );
                              //
                              //             // Scale transition for zoom out and zoom in effect
                              //             return ScaleTransition(
                              //               scale: curvedAnimation,
                              //               child: child,
                              //             );
                              //           },
                              //           child: Column(
                              //             key: ValueKey<int>(_currentIndex), // Unique key for each step
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               // Step Title (e.g., Step 1, Step 2)
                              //               // Text(
                              //               //   _steps[_currentIndex]['title']!,
                              //               //   style: TextStyle(
                              //               //     fontSize: 24,
                              //               //     fontWeight: FontWeight.bold,
                              //               //   ),
                              //               // ),
                              //               CommonShadeContainer(title: _camera[_currentIndex]['title']!),
                              //               const SizedBox(height: 4),
                              //               // Step Description (e.g., Go to permissions in ParrotPos app info)
                              //               Text(
                              //                 _camera[_currentIndex]['description']!,
                              //                 style: TextStyle(
                              //                   fontSize: 14,
                              //                   color: Colors.black.withOpacity(0.6),
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 10),
                              //               // Corresponding Image
                              //               Image.asset(
                              //                 _camera[_currentIndex]['image']!,
                              //                 key: ValueKey<int>(_currentIndex), // Ensure unique key for each image
                              //                 // width: 300, // Set width as required
                              //                 // height: 300, // Set height as required
                              //               ),
                              //             ],
                              //           ),
                              //           // Column(
                              //           //   crossAxisAlignment: CrossAxisAlignment.start,
                              //           //   children: [
                              //           //     const CommonShadeContainer(title: "Step-1"),
                              //           //     const SizedBox(height: 4),
                              //           //     Text(
                              //           //       "Go to permissions In ParrotPos app info",
                              //           //       style: kBlackLargeStyle.copyWith(
                              //           //         fontSize: 14,
                              //           //         color: kBlack61,
                              //           //       ),
                              //           //     ),
                              //           //     Image.asset(
                              //           //       _images[_currentIndex],
                              //           //       key: ValueKey<int>(_currentIndex), // Ensure unique key for each image
                              //           //       // width: 300, // Set width as required
                              //           //       // height: 300, // Set height as required
                              //           //     ),
                              //           //   ],
                              //           // ),
                              //         ),
                              //       ); // Builds the animated step item
                              //     },
                              //     options: CarouselOptions(
                              //       reverse: false,
                              //       // padEnds: true,
                              //       height: 500, // Adjust the height as needed
                              //       viewportFraction: 1.0, // Full screen carousel effect
                              //       onPageChanged: (index, reason) {
                              //         setState(() {
                              //           _currentIndex = index; // Update the current index when scrolling
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _camera.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () => setState(() {
                                      _currentIndex = entry.key;
                                    }),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (_currentIndex == entry.key) ? Colors.green : Color(0xFFD1D1D1),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Center(
                                child: GestureDetector(
                                  onHorizontalDragEnd: (val) {
                                    if (_cameraAppleIndex == 2) {
                                      _cameraAppleIndex = 0;
                                    } else {
                                      _cameraAppleIndex = _cameraAppleIndex + 1;
                                    }

                                    setState(() {});
                                  },
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 10), // Animation duration
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      // return FadeTransition(opacity: animation, child: child);
                                      // Add a curve for smooth zoom-out then zoom-in effect
                                      final curvedAnimation = CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.ease, // Smooth transition
                                      );

                                      // Scale transition for zoom out and zoom in effect
                                      return ScaleTransition(
                                        scale: curvedAnimation,
                                        child: child,
                                      );
                                    },
                                    child: Column(
                                      key: ValueKey<int>(_cameraAppleIndex), // Unique key for each step
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonShadeContainer(title: _cameraApple[_cameraAppleIndex]['title']!),
                                        const SizedBox(height: 4),
                                        Text(
                                          _cameraApple[_cameraAppleIndex]['description']!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Corresponding Image
                                        Image.asset(
                                          _cameraApple[_cameraAppleIndex]['image']!,
                                          key: ValueKey<int>(_cameraAppleIndex), // Ensure unique key for each image
                                          // width: 300, // Set width as required
                                          // height: 300, // Set height as required
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   height: 400,
                              //   child: CarouselSlider.builder(
                              //     itemCount: _camera.length,
                              //     itemBuilder: (context, index, realIdx) {
                              //       return Center(
                              //         child: AnimatedSwitcher(
                              //           duration: Duration(milliseconds: 200), // Animation duration
                              //           transitionBuilder: (Widget child, Animation<double> animation) {
                              //             // Add a curve for smooth zoom-out then zoom-in effect
                              //             final curvedAnimation = CurvedAnimation(
                              //               parent: animation,
                              //               curve: Curves.easeInOut, // Smooth transition
                              //             );
                              //
                              //             // Scale transition for zoom out and zoom in effect
                              //             return ScaleTransition(
                              //               scale: curvedAnimation,
                              //               child: child,
                              //             );
                              //           },
                              //           child: Column(
                              //             key: ValueKey<int>(_currentIndex), // Unique key for each step
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               // Step Title (e.g., Step 1, Step 2)
                              //               // Text(
                              //               //   _steps[_currentIndex]['title']!,
                              //               //   style: TextStyle(
                              //               //     fontSize: 24,
                              //               //     fontWeight: FontWeight.bold,
                              //               //   ),
                              //               // ),
                              //               CommonShadeContainer(title: _camera[_currentIndex]['title']!),
                              //               const SizedBox(height: 4),
                              //               // Step Description (e.g., Go to permissions in ParrotPos app info)
                              //               Text(
                              //                 _camera[_currentIndex]['description']!,
                              //                 style: TextStyle(
                              //                   fontSize: 14,
                              //                   color: Colors.black.withOpacity(0.6),
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 10),
                              //               // Corresponding Image
                              //               Image.asset(
                              //                 _camera[_currentIndex]['image']!,
                              //                 key: ValueKey<int>(_currentIndex), // Ensure unique key for each image
                              //                 // width: 300, // Set width as required
                              //                 // height: 300, // Set height as required
                              //               ),
                              //             ],
                              //           ),
                              //           // Column(
                              //           //   crossAxisAlignment: CrossAxisAlignment.start,
                              //           //   children: [
                              //           //     const CommonShadeContainer(title: "Step-1"),
                              //           //     const SizedBox(height: 4),
                              //           //     Text(
                              //           //       "Go to permissions In ParrotPos app info",
                              //           //       style: kBlackLargeStyle.copyWith(
                              //           //         fontSize: 14,
                              //           //         color: kBlack61,
                              //           //       ),
                              //           //     ),
                              //           //     Image.asset(
                              //           //       _images[_currentIndex],
                              //           //       key: ValueKey<int>(_currentIndex), // Ensure unique key for each image
                              //           //       // width: 300, // Set width as required
                              //           //       // height: 300, // Set height as required
                              //           //     ),
                              //           //   ],
                              //           // ),
                              //         ),
                              //       ); // Builds the animated step item
                              //     },
                              //     options: CarouselOptions(
                              //       reverse: false,
                              //       // padEnds: true,
                              //       height: 500, // Adjust the height as needed
                              //       viewportFraction: 1.0, // Full screen carousel effect
                              //       onPageChanged: (index, reason) {
                              //         setState(() {
                              //           _currentIndex = index; // Update the current index when scrolling
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _cameraApple.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () => setState(() {
                                      _cameraAppleIndex = entry.key;
                                    }),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (_cameraAppleIndex == entry.key) ? Colors.green : Color(0xFFD1D1D1),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                    // Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           CommonShadeContainer(title: "Steps-1"),
                    //           const SizedBox(height: 4),
                    //           Text(
                    //             "Go to ParrotPos app settings Turn On Camera",
                    //             style: kBlackLargeStyle.copyWith(
                    //               fontSize: 14,
                    //               color: kBlack61,
                    //             ),
                    //           ),
                    //           StreamBuilder(
                    //               stream: isCameraOn.stream,
                    //               builder: (context, snapshot) {
                    //                 return Container(height: 300, width: 410, child: Image.asset("assets/images/apple_camera_off.png", fit: BoxFit.fill));
                    //               }),
                    //         ],
                    //       ),
                    // Platform.isAndroid
                    //     ? Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const CommonShadeContainer(title: "Step-2"),
                    //           SizedBox(height: 4),
                    //           Text(
                    //             "In App Permissions click on Camera",
                    //             style: kBlackLargeStyle.copyWith(
                    //               fontSize: 14,
                    //               color: kBlack61,
                    //             ),
                    //           ),
                    //           // Image.asset("assets/images/android_camera.png", fit: BoxFit.fill),
                    //         ],
                    //       )
                    //     : Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           CommonShadeContainer(title: "Step-2"),
                    //           const SizedBox(height: 4),
                    //           Text(
                    //             "In App Permissions click on Camera",
                    //             style: kBlackLargeStyle.copyWith(
                    //               fontSize: 14,
                    //               color: kBlack61,
                    //             ),
                    //           ),
                    //           StreamBuilder(
                    //               stream: isCameraOn.stream,
                    //               builder: (context, snapshot) {
                    //                 return Container(height: 300, width: 410, child: Image.asset("assets/images/apple_camera_on.png", fit: BoxFit.fill));
                    //               }),
                    //         ],
                    //       ),
                    // Platform.isAndroid
                    //     ? Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const CommonShadeContainer(title: "Step-3"),
                    //           SizedBox(height: 4),
                    //           Text(
                    //             "In Camera Permission Allow the permission",
                    //             style: kBlackLargeStyle.copyWith(
                    //               fontSize: 14,
                    //               color: kBlack61,
                    //             ),
                    //           ),
                    //           // Image.asset("assets/images/camera_allow_new.png", fit: BoxFit.fill),
                    //         ],
                    //       )
                    //     : SizedBox.shrink(),

                    ///
                    // SmoothPageIndicator(
                    //   key: ValueKey<int>(_currentIndex),
                    //   controller: _pageController,
                    //   count: 3,
                    //   effect: const ScaleEffect(
                    //     dotHeight: 6,
                    //     dotWidth: 6,
                    //     activeDotColor: Colors.green,
                    //     dotColor: Color(0xFFD1D1D1),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                  ],
                ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.05)
              : widget.photo == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Follow these steps to allow ParrotPos access to Photo",
                          style: kBlackLargeStyle.copyWith(
                            fontSize: 14,
                            color: kBlack61,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Platform.isAndroid
                            ? Column(
                                children: [
                                  Center(
                                    child: GestureDetector(
                                      onHorizontalDragEnd: (val) {
                                        if (_photoIndex == 2) {
                                          _photoIndex = 0;
                                        } else {
                                          _photoIndex = _photoIndex + 1;
                                        }

                                        setState(() {});
                                      },
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 10), // Animation duration
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          // return FadeTransition(opacity: animation, child: child);
                                          // Add a curve for smooth zoom-out then zoom-in effect
                                          final curvedAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.ease, // Smooth transition
                                          );

                                          // Scale transition for zoom out and zoom in effect
                                          return ScaleTransition(
                                            scale: curvedAnimation,
                                            child: child,
                                          );
                                        },
                                        child: Column(
                                          key: ValueKey<int>(_photoIndex), // Unique key for each step
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonShadeContainer(title: _photo[_photoIndex]['title']!),
                                            const SizedBox(height: 4),
                                            Text(
                                              _photo[_photoIndex]['description']!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            // Corresponding Image
                                            Image.asset(
                                              _photo[_photoIndex]['image']!,
                                              key: ValueKey<int>(_photoIndex), // Ensure unique key for each image
                                              // width: 300, // Set width as required
                                              // height: 300, // Set height as required
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _photo.asMap().entries.map((entry) {
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          _photoIndex = entry.key;
                                        }),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (_photoIndex == entry.key) ? Colors.green : Color(0xFFD1D1D1),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Center(
                                    child: GestureDetector(
                                      onHorizontalDragEnd: (val) {
                                        if (_photoAppleIndex == 2) {
                                          _photoAppleIndex = 0;
                                        } else {
                                          _photoAppleIndex = _photoAppleIndex + 1;
                                        }

                                        setState(() {});
                                      },
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds:10), // Animation duration
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          // return FadeTransition(opacity: animation, child: child);
                                          // Add a curve for smooth zoom-out then zoom-in effect
                                          final curvedAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.ease, // Smooth transition
                                          );

                                          // Scale transition for zoom out and zoom in effect
                                          return ScaleTransition(
                                            scale: curvedAnimation,
                                            child: child,
                                          );
                                        },
                                        child: Column(
                                          key: ValueKey<int>(_photoAppleIndex), // Unique key for each step
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonShadeContainer(title: _photoApple[_photoAppleIndex]['title']!),
                                            const SizedBox(height: 4),
                                            Text(
                                              _photoApple[_photoAppleIndex]['description']!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            // Corresponding Image
                                            Image.asset(
                                              _photoApple[_photoAppleIndex]['image']!,
                                              key: ValueKey<int>(_photoAppleIndex), // Ensure unique key for each image
                                              // width: 300, // Set width as required
                                              // height: 300, // Set height as required
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _photoApple.asMap().entries.map((entry) {
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          _photoAppleIndex = entry.key;
                                        }),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (_photoAppleIndex == entry.key) ? Colors.green : Color(0xFFD1D1D1),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                        // Container(
                        //   height: 400,
                        //   child: PageView(
                        //     controller: _pageController,
                        //     children: [
                        //       Platform.isAndroid
                        //           ? Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-1"),
                        //                 const SizedBox(height: 4),
                        //                 // Text(
                        //                 //   "Go to permissions In ParrotPos app info",
                        //                 //   style: kBlackLargeStyle.copyWith(
                        //                 //     fontSize: 14,
                        //                 //     color: kBlack61,
                        //                 //   ),
                        //                 // ),
                        //                 // Image.asset("assets/images/permission.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //           : Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-1"),
                        //                 const SizedBox(height: 4),
                        //                 Text(
                        //                   "Go to Parrots pos app settings Select Photos",
                        //                   style: kBlackLargeStyle.copyWith(
                        //                     fontSize: 14,
                        //                     color: kBlack61,
                        //                   ),
                        //                 ),
                        //                 StreamBuilder(
                        //                     stream: isCameraOn.stream,
                        //                     builder: (context, snapshot) {
                        //                       return Container(height: 300, width: 410, child: Image.asset("assets/images/apple_photo.png", fit: BoxFit.fill));
                        //                     }),
                        //               ],
                        //             ),
                        //       Platform.isAndroid
                        //           ? Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-2"),
                        //                 SizedBox(height: 4),
                        //                 // Text(
                        //                 //   "In App Permissions click on Photo",
                        //                 //   style: kBlackLargeStyle.copyWith(
                        //                 //     fontSize: 14,
                        //                 //     color: kBlack61,
                        //                 //   ),
                        //                 // ),
                        //                 // Image.asset("assets/images/photos_permission.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //           : Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-2"),
                        //                 SizedBox(height: 4),
                        //                 Text(
                        //                   "In Photos Select Full Access",
                        //                   style: kBlackLargeStyle.copyWith(
                        //                     fontSize: 14,
                        //                     color: kBlack61,
                        //                   ),
                        //                 ),
                        //                 Image.asset("assets/images/full_access_photo.png", fit: BoxFit.fill),
                        //               ],
                        //             ),
                        //       Platform.isAndroid
                        //           ? Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-3"),
                        //                 SizedBox(height: 4),
                        //                 // Text(
                        //                 //   "In Photo Permission Allow the permission",
                        //                 //   style: kBlackLargeStyle.copyWith(
                        //                 //     fontSize: 14,
                        //                 //     color: kBlack61,
                        //                 //   ),
                        //                 // ),
                        //                 // Image.asset("assets/images/photo_permission_allow.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //           : Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-3"),
                        //                 SizedBox(height: 4),
                        //                 Text(
                        //                   "Select Allow Full Access",
                        //                   style: kBlackLargeStyle.copyWith(
                        //                     fontSize: 14,
                        //                     color: kBlack61,
                        //                   ),
                        //                 ),
                        //                 Image.asset("assets/images/allow_full_access_photo.png", fit: BoxFit.fill),
                        //               ],
                        //             ),
                        //       if (Platform.isIOS)
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             const CommonShadeContainer(title: "Step-4"),
                        //             SizedBox(height: 4),
                        //             Text(
                        //               "Go to Parrots pos app. ",
                        //               style: kBlackLargeStyle.copyWith(
                        //                 fontSize: 14,
                        //                 color: kBlack61,
                        //               ),
                        //             ),
                        //             Image.asset("assets/images/go_app_photo.png", fit: BoxFit.fill),
                        //           ],
                        //         )
                        //     ],
                        //   ),
                        // ),
                        // SmoothPageIndicator(
                        //   controller: _pageController,
                        //   count: Platform.isAndroid ? 3 : 4,
                        //   effect: const ScaleEffect(
                        //     dotHeight: 6,
                        //     dotWidth: 6,
                        //     activeDotColor: Colors.green,
                        //     dotColor: Color(0xFFD1D1D1),
                        //   ),
                        // ),
                      ],
                    ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.05)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Follow these steps to allow ParrotPos access to your contacts for easier phone number selection.",
                          style: kBlackLargeStyle.copyWith(
                            fontSize: 14,
                            color: kBlack61,
                          ),
                        ),
                        const SizedBox(height: 20),

                        !Platform.isAndroid
                            ? Column(
                                children: [
                                  Center(
                                    child: GestureDetector(
                                      onHorizontalDragEnd: (val) {
                                        if (_contactIndex == 2) {
                                          _contactIndex = 0;
                                        } else {
                                          _contactIndex = _contactIndex + 1;
                                        }

                                        setState(() {});
                                      },
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 10), // Animation duration
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          // return FadeTransition(opacity: animation, child: child);
                                          // Add a curve for smooth zoom-out then zoom-in effect
                                          final curvedAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.ease, // Smooth transition
                                          );

                                          // Scale transition for zoom out and zoom in effect
                                          return ScaleTransition(
                                            scale: curvedAnimation,
                                            child: child,
                                          );
                                        },
                                        child: Column(
                                          key: ValueKey<int>(_contactIndex), // Unique key for each step
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonShadeContainer(title: _contact[_contactIndex]['title']!),
                                            const SizedBox(height: 4),
                                            Text(
                                              _contact[_contactIndex]['description']!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            // Corresponding Image
                                            Container(
                                              width: 400, // Set width as required
                                              height: 300,
                                              child: Image.asset(
                                                _contact[_contactIndex]['image']!,
                                                key: ValueKey<int>(_contactIndex),
                                                fit: BoxFit.cover, // Ensure unique key for each image
                                                // width: 300, // Set width as required
                                                // height: 300, // Set height as required
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _contact.asMap().entries.map((entry) {
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          _contactIndex = entry.key;
                                        }),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (_contactIndex == entry.key) ? Colors.green : Color(0xFFD1D1D1),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Center(
                                    child: GestureDetector(
                                      onHorizontalDragEnd: (val) {
                                        if (_contactAppleIndex == 2) {
                                          _contactAppleIndex = 0;
                                        } else {
                                          _contactAppleIndex = _contactAppleIndex + 1;
                                        }

                                        setState(() {});
                                      },
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 10), // Animation duration
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          // return FadeTransition(opacity: animation, child: child);
                                          // Add a curve for smooth zoom-out then zoom-in effect
                                          final curvedAnimation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.ease, // Smooth transition
                                          );

                                          // Scale transition for zoom out and zoom in effect
                                          return ScaleTransition(
                                            scale: curvedAnimation,
                                            child: child,
                                          );
                                        },
                                        child: Column(
                                          key: ValueKey<int>(_contactAppleIndex), // Unique key for each step
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonShadeContainer(title: _contactApple[_contactAppleIndex]['title']!),
                                            const SizedBox(height: 4),
                                            Text(
                                              _contactApple[_contactAppleIndex]['description']!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.6),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            // Corresponding Image
                                            Container(
                                              width: 400, // Set width as required
                                              height: 300,
                                              child: Image.asset(
                                                _contactApple[_contactAppleIndex]['image']!,
                                                key: ValueKey<int>(_photoAppleIndex), // Ensure unique key for each image
                                                // width: 400, // Set width as required
                                                // height: 400,
                                                fit: BoxFit.fill, // Set height as required
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: _contactApple.asMap().entries.map((entry) {
                                      return GestureDetector(
                                        onTap: () => setState(() {
                                          _contactAppleIndex = entry.key;
                                        }),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (_contactAppleIndex == entry.key) ? Colors.green : Color(0xFFD1D1D1),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              )

                        // Container(
                        //   height: 400,
                        //   child: PageView(
                        //     controller: _pageController,
                        //     children: [
                        //       Platform.isAndroid
                        //           ? Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-1"),
                        //                 const SizedBox(height: 4),
                        //                 // Text(
                        //                 //   "Go to permissions In ParrotPos app info",
                        //                 //   style: kBlackLargeStyle.copyWith(
                        //                 //     fontSize: 14,
                        //                 //     color: kBlack61,
                        //                 //   ),
                        //                 // ),
                        //                 // Image.asset("assets/images/permission.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //           : Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-1"),
                        //                 const SizedBox(height: 4),
                        //                 Text(
                        //                   "Go to ParrotPos app settings Turn On Contact",
                        //                   style: kBlackLargeStyle.copyWith(
                        //                     fontSize: 14,
                        //                     color: kBlack61,
                        //                   ),
                        //                 ),
                        //                 Image.asset("assets/images/apple_contact_off.png", fit: BoxFit.fill),
                        //               ],
                        //             ),
                        //       Platform.isAndroid
                        //           ? Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-2"),
                        //                 SizedBox(height: 4),
                        //                 // Text(
                        //                 //   "In App Permissions click on Contacts",
                        //                 //   style: kBlackLargeStyle.copyWith(
                        //                 //     fontSize: 14,
                        //                 //     color: kBlack61,
                        //                 //   ),
                        //                 // ),
                        //                 // Image.asset("assets/images/contact_permission.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //           : Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-2"),
                        //                 SizedBox(height: 4),
                        //                 Text(
                        //                   "In App Permissions click on Contacts",
                        //                   style: kBlackLargeStyle.copyWith(
                        //                     fontSize: 14,
                        //                     color: kBlack61,
                        //                   ),
                        //                 ),
                        //                 Image.asset("assets/images/apple_contact_on.png", fit: BoxFit.fill),
                        //               ],
                        //             ),
                        //       Platform.isAndroid
                        //           ? Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-3"),
                        //                 // SizedBox(height: 4),
                        //                 // Text(
                        //                 //   "In Contacts Permission Allow the permission",
                        //                 //   style: kBlackLargeStyle.copyWith(
                        //                 //     fontSize: 14,
                        //                 //     color: kBlack61,
                        //                 //   ),
                        //                 // ),
                        //                 // Image.asset("assets/images/contact_allow.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //           : Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 const CommonShadeContainer(title: "Step-3"),
                        //                 SizedBox(height: 4),
                        //                 Text(
                        //                   "In Contacts Permission click on ParrotPos",
                        //                   style: kBlackLargeStyle.copyWith(
                        //                     fontSize: 14,
                        //                     color: kBlack61,
                        //                   ),
                        //                 ),
                        //                 Image.asset("assets/images/allow_contact_allow.png", fit: BoxFit.fill),
                        //               ],
                        //             )
                        //     ],
                        //   ),
                        // ),
                        // SmoothPageIndicator(
                        //   controller: _pageController,
                        //   count: 3,
                        //   effect: const ScaleEffect(
                        //     dotHeight: 6,
                        //     dotWidth: 6,
                        //     activeDotColor: Colors.green,
                        //     dotColor: Color(0xFFD1D1D1),
                        //   ),
                        // ),
                      ],
                    ).paddingSymmetric(horizontal: Get.mediaQuery.size.width * 0.05),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: WhiteBluBtn(
              width: Get.width,
              onTap: () {
                openAppSettings().then((value) {
                  Get.back();
                });
              },
              text: "Allow",
              widthSize: Get.width,
            ),
          )
        ],
      ),
    );
  }
}

class CommonShadeContainer extends StatelessWidget {
  final String title;

  const CommonShadeContainer({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kGreenBtnColor1,
                kGreenBtnColor2,
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0.5),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFd9eedb),
                // Colors.white,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(
            "${title}",
            style: kBlackDarkSuperLargeStyle,
          ),
        ),
      ],
    );
  }
}
