import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/internet_controller.dart';
import 'package:parrotpos/screens/login/main_login_screen.dart';
import 'package:parrotpos/services/remote_service.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/onboarding_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // void initState() {
  //   RemoteService.checkServer();
  //   super.initState();
  // }

  setIntro() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setBool("onboarding", true);
      Get.offAll(() => const MainLoginScreen());
    });
  }

  final SwiperController _controller = SwiperController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final _internet = Get.put(InternetController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Swiper(
            scrollDirection: Axis.vertical,
            loop: false,
            containerHeight: size.height,
            containerWidth: size.width,
            index: _currentIndex,
            onIndexChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            controller: _controller,
            pagination: SwiperPagination(
              alignment: Alignment.bottomRight,
              builder: DotSwiperPaginationBuilder(
                color: Colors.grey[300],
                activeColor: Colors.blue,
                activeSize: 10.0,
              ),
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return OnboardingItem(
                title: Config().onboardingTitles[index],
                subtitle: Config().onboardingSubtitles[index],
                imageUrl: Config().onboardingImages[index],
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: _currentIndex != 4
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: MaterialButton(
                        child: Text(
                          "Skip",
                          style: kBlackMediumStyle,
                        ),
                        onPressed: () {
                          setIntro();
                        },
                      ),
                    )
                  : Container(),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _currentIndex != 4
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              child: Ink(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff1B75BB),
                                      Color(0xff1B75BB),
                                      Color(0xff2B388F),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                // alignment: Alignment.center,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    if (_currentIndex != 4) {
                                      _controller.next();
                                    } else {
                                      setIntro();
                                    }
                                  },
                                  child: const Icon(Icons.keyboard_arrow_down, size: 35, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Next",
                            style: kBlackMediumStyle,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Card(
                        elevation: 5,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Ink(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff1B75BB),
                                Color(0xff1B75BB),
                                Color(0xff2B388F),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // alignment: Alignment.center,
                          child: InkWell(
                            autofocus: true,
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              await Future.delayed(const Duration(milliseconds: 500));
                              if (_currentIndex != 4) {
                                _controller.next();
                              } else {
                                setIntro();
                              }
                            },
                            child: Center(
                              child: Text(
                                "Get Started",
                                style: kWhiteMediumStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
