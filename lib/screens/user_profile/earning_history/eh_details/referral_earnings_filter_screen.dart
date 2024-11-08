import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
//     as example;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as example;
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/models/wallet/day_referral_earning.dart';
import 'package:parrotpos/models/wallet/earning_history.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class ReferralEarningsFilterScreen extends StatefulWidget {
  final Map? filterMap;
  final EarningHistoryData? earningHistoryData;
  const ReferralEarningsFilterScreen({
    Key? key,
    required this.filterMap,
    required this.earningHistoryData,
  }) : super(key: key);

  @override
  _ReferralEarningsFilterScreenState createState() =>
      _ReferralEarningsFilterScreenState();
}

class _ReferralEarningsFilterScreenState
    extends State<ReferralEarningsFilterScreen> {
  // ReferralController referralController = Get.find();
  // UserProfileController userProfileController = Get.find();
  List keywords = [];
  TextEditingController searchController = TextEditingController();

  int selectedArrangeBy = 0;
  bool isSearchByTime = false;
  late DateTime startTime, endTime;

  @override
  void initState() {
    super.initState();

    // print('${widget.filterMap}');

    if (widget.filterMap != null) {
      keywords = widget.filterMap!['keywords'];
      if (widget.filterMap!['start_time'] != null) {
        isSearchByTime = true;
      }
      startTime = widget.filterMap!['start_time'] != null
          ? DateTime.parse(widget.filterMap!['start_time'])
          : DateTime.parse(widget.earningHistoryData!.timestamp);
      endTime = widget.filterMap!['end_time'] != null
          ? DateTime.parse(widget.filterMap!['end_time'])
          : DateTime.parse(widget.earningHistoryData!.timestamp);
      selectedArrangeBy = widget.filterMap!['arrange_by'] == null
          ? 0
          : widget.filterMap!['arrange_by'] == 'HIGHEST_TO_LOWEST'
              ? 0
              : 1;
    } else {
      startTime = DateTime.parse(widget.earningHistoryData!.timestamp);
      endTime = DateTime.parse(widget.earningHistoryData!.timestamp);
      selectedArrangeBy = 0;
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
          "Filter",
          style: kBlackLargeStyle,
        ),
        actions: [
          Padding(
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
                    'assets/icons/ic_filter_active.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Text(
            'Only show Referral Earnings for the following keywords:',
            style: kBlackMediumStyle,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
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
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      if (keywords.length == 3) {
                        return;
                      }
                      keywords.add(value.trim());
                    });
                  }
                  searchController.clear();
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
                  hintText: 'Add Keyword',
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
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.next_plan,
                      color: kColorPrimary,
                    ),
                    onPressed: () {
                      if (searchController.text.trim().isNotEmpty) {
                        setState(() {
                          if (keywords.length == 3) {
                            return;
                          }
                          keywords.add(searchController.text.trim());
                        });
                        searchController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          keywords.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: keywords
                          .map((val) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      kGreenBtnColor1,
                                      kGreenBtnColor2,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$val',
                                      style: kWhiteSmallMediumStyle,
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: InkWell(
                                          onTap: () {
                                            print('del');
                                            setState(() {
                                              keywords.remove(val);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: kWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
              : const SizedBox(),
          const Divider(thickness: 0.30),
          RadioListTile(
            value: true,
            groupValue: isSearchByTime,
            activeColor: kColorPrimaryDark,
            toggleable: true,
            onChanged: (value) {
              print(value);
              if (value == null) {
                setState(() {
                  isSearchByTime = false;
                });
              } else {
                setState(() {
                  isSearchByTime = true;
                });
              }
              print(isSearchByTime);
            },
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              'Search By Time',
              style: kBlackMediumStyle,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              SizedBox(
                width: Get.width * 0.15,
                child: Text(
                  'Start:',
                  textAlign: TextAlign.end,
                  style: isSearchByTime
                      ? kBlackDarkMediumStyle
                      : kBlackLightMediumStyle,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  example.DatePicker.showTimePicker(
                    context,
                    showTitleActions: true,

                    // minTime: DateTime(2000, 1, 1),
                    // maxTime: DateTime.now(),
                    showSecondsColumn: false,
                    onChanged: (date) {
                      print('change $date');
                    },
                    onConfirm: (date) {
                      print('confirm $date');

                      DateTime timestamp =
                          DateTime.parse(widget.earningHistoryData!.timestamp);

                      setState(() {
                        startTime = DateTime(
                          timestamp.year,
                          timestamp.month,
                          timestamp.day,
                          date.hour,
                          date.minute,
                        );
                      });
                    },
                    currentTime: startTime,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hour:',
                          style: isSearchByTime
                              ? kBlackSmallMediumStyle
                              : kBlackSmallLightMediumStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kWhite,
                          ),
                          child: Text(
                            DateFormat('HH').format(startTime),
                            style: isSearchByTime
                                ? kBlackDarkMediumStyle
                                : kBlackLightMediumStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Minutes:',
                          style: isSearchByTime
                              ? kBlackSmallMediumStyle
                              : kBlackSmallLightMediumStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kWhite,
                          ),
                          child: Text(
                            DateFormat('mm').format(startTime),
                            style: isSearchByTime
                                ? kBlackDarkMediumStyle
                                : kBlackLightMediumStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              SizedBox(
                width: Get.width * 0.15,
                child: Text(
                  'End:',
                  textAlign: TextAlign.end,
                  style: isSearchByTime
                      ? kBlackDarkMediumStyle
                      : kBlackLightMediumStyle,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  example.DatePicker.showTimePicker(
                    context,
                    showTitleActions: true,
                    showSecondsColumn: false,
                    onChanged: (date) {
                      print('change $date');
                    },
                    onConfirm: (date) {
                      print('confirm $date');

                      DateTime timestamp =
                          DateTime.parse(widget.earningHistoryData!.timestamp);

                      setState(() {
                        endTime = DateTime(
                          timestamp.year,
                          timestamp.month,
                          timestamp.day,
                          date.hour,
                          date.minute,
                        );
                      });

                      print(endTime);
                    },
                    currentTime: endTime,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hour:',
                          style: isSearchByTime
                              ? kBlackSmallMediumStyle
                              : kBlackSmallLightMediumStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kWhite,
                          ),
                          child: Text(
                            DateFormat('HH').format(endTime),
                            style: isSearchByTime
                                ? kBlackDarkMediumStyle
                                : kBlackLightMediumStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Minutes:',
                          style: isSearchByTime
                              ? kBlackSmallMediumStyle
                              : kBlackSmallLightMediumStyle,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                            color: kWhite,
                          ),
                          child: Text(
                            DateFormat('mm').format(endTime),
                            style: isSearchByTime
                                ? kBlackDarkMediumStyle
                                : kBlackLightMediumStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Arrange By:',
            style: kBlackMediumStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
            value: 0,
            activeColor: kColorPrimaryDark,
            groupValue: selectedArrangeBy,
            onChanged: (value) {
              setState(() {
                selectedArrangeBy = 0;
              });
            },
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              'Highest to Lowest Earnings',
              style: kBlackMediumStyle,
            ),
          ),
          RadioListTile(
            value: 1,
            activeColor: kColorPrimaryDark,
            groupValue: selectedArrangeBy,
            onChanged: (value) {
              setState(() {
                selectedArrangeBy = 1;
              });
            },
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              'Lowest to Highest Earnings',
              style: kBlackMediumStyle,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          widget.filterMap != null
              ? !widget.filterMap!['keywords'].isNotEmpty ||
                      widget.filterMap!['start_time'] != null
                  ? GradientButton(
                      text: 'Remove Filter',
                      width: true,
                      onTap: () async {
                        keywords = [];
                        isSearchByTime = false;

                        Get.back(
                          result: {
                            "keywords": keywords,
                            "arrange_by": selectedArrangeBy == 0
                                ? "HIGHEST_TO_LOWEST"
                                : "LOWEST_TO_HIGHEST",
                            "start_time": isSearchByTime
                                ? startTime.toIso8601String()
                                : null,
                            "end_time": isSearchByTime
                                ? endTime.toIso8601String()
                                : null,
                            "day": widget.earningHistoryData!.timestamp
                          },
                        );
                      },
                      widthSize: Get.width,
                      buttonState: ButtonState.idle,
                    )
                  : GradientButton(
                      text: 'Show',
                      width: true,
                      onTap: () async {
                        print(
                          {
                            "keywords": keywords,
                            "arrange_by": selectedArrangeBy == 0
                                ? 'HIGHEST_TO_LOWEST'
                                : 'LOWEST_TO_HIGHEST',
                            "start_time": isSearchByTime
                                ? startTime.toIso8601String()
                                : null,
                            "end_time": isSearchByTime
                                ? endTime.toIso8601String()
                                : null,
                            "day": widget.earningHistoryData!.timestamp
                          },
                        );

                        Get.back(
                          result: {
                            "keywords": keywords,
                            "arrange_by": selectedArrangeBy == 0
                                ? "HIGHEST_TO_LOWEST"
                                : "LOWEST_TO_HIGHEST",
                            "start_time": isSearchByTime
                                ? startTime.toIso8601String()
                                : null,
                            "end_time": isSearchByTime
                                ? endTime.toIso8601String()
                                : null,
                            "day": widget.earningHistoryData!.timestamp
                          },
                        );
                      },
                      widthSize: Get.width,
                      buttonState: ButtonState.idle,
                    )
              : GradientButton(
                  text: 'Show',
                  width: true,
                  onTap: () async {
                    print(
                      {
                        "keywords": keywords,
                        "arrange_by": selectedArrangeBy == 0
                            ? 'HIGHEST_TO_LOWEST'
                            : 'LOWEST_TO_HIGHEST',
                        "start_time":
                            isSearchByTime ? startTime.toIso8601String() : null,
                        "end_time":
                            isSearchByTime ? endTime.toIso8601String() : null,
                        "day": widget.earningHistoryData!.timestamp
                      },
                    );

                    Get.back(
                      result: {
                        "keywords": keywords,
                        "arrange_by": selectedArrangeBy == 0
                            ? "HIGHEST_TO_LOWEST"
                            : "LOWEST_TO_HIGHEST",
                        "start_time":
                            isSearchByTime ? startTime.toIso8601String() : null,
                        "end_time":
                            isSearchByTime ? endTime.toIso8601String() : null,
                        "day": widget.earningHistoryData!.timestamp
                      },
                    );
                  },
                  widthSize: Get.width,
                  buttonState: ButtonState.idle,
                ),
        ],
      ),
    );
  }
}
