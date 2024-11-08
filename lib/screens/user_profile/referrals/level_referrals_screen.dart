import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/config/common_tools.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/models/referral/my_level_referral_users.dart';
import 'package:parrotpos/screens/user_profile/referrals/level_referrals_filter_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';

class LevelReferralsScreen extends StatefulWidget {
  final String level;
  const LevelReferralsScreen({
    Key? key,
    required this.level,
  }) : super(key: key);

  @override
  _LevelReferralsScreenState createState() => _LevelReferralsScreenState();
}

class _LevelReferralsScreenState extends State<LevelReferralsScreen> {
  TextEditingController searchController = TextEditingController();
  ReferralController referralController = Get.find();
  UserProfileController userProfileController = Get.find();
  String search = '';
  MyLevelReferralUsers? myLevelReferralUsers;
  late Future<MyLevelReferralUsers?> _future;
  Map filterMap = {};
  int page_no = 0;
  @override
  void initState() {
    super.initState();
    sc.addListener(() {
      if (sc.position.pixels == sc.position.maxScrollExtent) {
        page_no++;
        _isloadingmore = true;
        setState(() {
          _future = getAllMyLevelReferralUsers(map: {});
        });
      }
    });

    _future = getAllMyLevelReferralUsers();
  }

  Future<MyLevelReferralUsers?> getAllMyLevelReferralUsers({Map? map}) async {
    //  print('now lenght is ${myLevelReferralUsers?.data!.length}');
    if (myLevelReferralUsers != null && map == null) {
      //  print('NON NULL');
      if (search.isNotEmpty) {
        //  print('SEARCH');

        //search
        MyLevelReferralUsers? searchUsers =
            MyLevelReferralUsers(message: 'Success', status: 200, data: []);

        for (var item in myLevelReferralUsers!.data!) {
          if (item.name!.toLowerCase().contains(search.toLowerCase().trim())) {
            searchUsers.data!.add(item);
          }
        }
        return searchUsers;
      } else {
        //  print('NO SEARCH');

        return myLevelReferralUsers;
      }
    } else {
      print('NEW');

      // setState(() {
      //   myLevelReferralUsers = null;
      // });

      if (map != null) {
        //  print('map hu mai $map');
        var res = await referralController.getMyLevelReferralUsers({
          "level": int.parse(widget.level),
          "filter": {"from_date": map['fromDate'], "end_date": map['endDate']},
          "sort": map['sort'],
          'page_no': page_no
        });

        if (res.status == 200) {
          //got it
          if (myLevelReferralUsers == null) {
            myLevelReferralUsers = res;
          } else {
            myLevelReferralUsers!.data!.addAll(res.data!);
          }
          _isloadingmore = false;
          setState(() {});
        } else {
          //error
          errorSnackbar(title: 'Failed', subtitle: '${res.message}');
        }

        return myLevelReferralUsers;
      } else {
        //  print("2 number chala");
        var res = await referralController.getMyLevelReferralUsers({
          "level": int.parse(widget.level),
          "filter": {"from_date": null, "end_date": null},
          "sort": "DSC",
          'page_no': page_no
        });
        if (res.status == 200) {
          //got it          _isloadingmore = false;
          setState(() {});
          if (myLevelReferralUsers == null) {
            myLevelReferralUsers = res;
          } else {
            myLevelReferralUsers!.data!.addAll(res.data!);
          }
        } else {
          //error
          errorSnackbar(title: 'Failed', subtitle: '${res.message}');
        }

        return myLevelReferralUsers;
      }
    }
  }

  bool _isloadingmore = false;
  getUsers(Map map) async {
    referralController.getMyLevelReferralUsers({
      "level": int.parse(widget.level),
      "filter": {"from_date": map['fromDate'], "end_date": map['toDate']},
      "sort": map['sort']
    });
  }

  final sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Level ${widget.level} Referrals",
          style: kBlackLargeStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              // myLevelReferralUsers?.data!.clear();
              var res = await Get.to(() => LevelReferralsFilterScreen(
                    filterMap: filterMap,
                  ));
              // print(res);
              if (res != null) {
                filterMap = res;

                // getAllMyLevelReferralUsers(map: res);
                _future = getAllMyLevelReferralUsers(map: res);
              }
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
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                    color: kWhite,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/ic_filter.png',
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
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
                  setState(() {
                    search = value.trim();
                  });
                  _future = getAllMyLevelReferralUsers();
                },
                controller: searchController,
                enableInteractiveSelection: true,
                style: kBlackMediumStyle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
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
          // const SizedBox(
          //   height: 0,
          // ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<MyLevelReferralUsers?>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
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
                if (snapshot.data!.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No Users Found!',
                      style: kBlackMediumStyle,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.separated(
                      shrinkWrap: true,
                      controller: sc,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data!.data!.length) {
                          log(_isloadingmore.toString());
                          return Opacity(
                            opacity: _isloadingmore ? 1 : 0,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                              color: kWhite,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: Get.width * 0.1,
                                  height: Get.width * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: kWhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      // gradient: const LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     kGreenBtnColor1,
                                      //     kGreenBtnColor2,
                                      //   ],
                                      // ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: snapshot.data!.data![index]
                                                      .profileImage !=
                                                  null &&
                                              snapshot.data!.data![index]
                                                  .profileImage!.isNotEmpty
                                          ? Image.asset(
                                              'assets/images/referral/ic_profile.png',
                                              // 'assets/icons/referrals_white.png',
                                              width: Get.width * 0.08,
                                            )
                                          : Image.network(
                                              snapshot.data!.data![index]
                                                  .profileImage!,
                                              // width: Get.width * 0.08,
                                              fit: BoxFit.cover,
                                              // errorBuilder: (context, error,
                                              //         stackTrace) =>
                                              //     Image.network(
                                              //   'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                                              //   // width: Get.width * 0.08,
                                              //   fit: BoxFit.cover,
                                              // ),
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.4,
                                            child: Text(
                                              '${snapshot.data!.data![index].name}',
                                              style: kBlackMediumStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            CommonTools().getDate(snapshot
                                                .data!
                                                .data![index]
                                                .joiningTimestamp!),
                                            style:
                                                kBlackExtraSmallLightMediumStyle,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${userProfileController.userProfile.value.data!.currency} ${double.parse(snapshot.data!.data![index].earning.toString()).toStringAsFixed(2)}',
                                        style: kBlackDarkLargeStyle,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                      itemCount: snapshot.data!.data!.length + 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
