import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'
//     as example;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as example;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/controllers/referral_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';

class LevelReferralsFilterScreen extends StatefulWidget {
  Map? filterMap;
  LevelReferralsFilterScreen({
    Key? key,
    required this.filterMap,
  }) : super(key: key);

  @override
  _LevelReferralsFilterScreenState createState() =>
      _LevelReferralsFilterScreenState();
}

class _LevelReferralsFilterScreenState
    extends State<LevelReferralsFilterScreen> {
  ReferralController referralController = Get.find();
  UserProfileController userProfileController = Get.find();

  int selectedArrangeBy = 0;
  bool isSearchByDate = false;
  late DateTime fromDate, endDate;

  @override
  void initState() {
    super.initState();

    // print('${widget.filterMap}');

    if (widget.filterMap != null) {
      if (widget.filterMap!['fromDate'] != null) {
        isSearchByDate = true;
      }
      fromDate = widget.filterMap!['fromDate'] != null
          ? DateTime.parse(widget.filterMap!['fromDate'])
          : DateTime.now().subtract(const Duration(days: 15));
      endDate = widget.filterMap!['endDate'] != null
          ? DateTime.parse(widget.filterMap!['endDate'])
          : DateTime.now();
      selectedArrangeBy = widget.filterMap!['sort'] == null
          ? 0
          : widget.filterMap!['sort'] == 'ASC'
              ? 0
              : 1;
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
        children: [
          RadioListTile(
            value: true,
            groupValue: isSearchByDate,
            activeColor: kColorPrimaryDark,
            toggleable: true,
            onChanged: (value) {
              print(value);
              if (value == null) {
                setState(() {
                  isSearchByDate = false;
                });
              } else {
                setState(() {
                  isSearchByDate = true;
                });
              }
              print(isSearchByDate);
            },
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              'Search By Date',
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
                  'From:',
                  textAlign: TextAlign.end,
                  style: kBlackMediumStyle,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  example.DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime.now(),
                    onChanged: (date) {
                      print('change $date');
                    },
                    onConfirm: (date) {
                      print('confirm $date');

                      setState(() {
                        fromDate = date;
                      });
                    },
                    currentTime: DateTime.now(),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd').format(fromDate),
                      ),
                      Container(
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.black12,
                        width: 1,
                      ),
                      Text(
                        DateFormat('MM').format(fromDate),
                      ),
                      Container(
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.black12,
                        width: 1,
                      ),
                      Text(
                        DateFormat('yyyy').format(fromDate),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: Get.width * 0.15,
                child: Text(
                  'To:',
                  style: kBlackMediumStyle,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  example.DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: fromDate,
                    maxTime: DateTime.now(),
                    onChanged: (date) {
                      print('change $date');
                    },
                    onConfirm: (date) {
                      print('confirm $date');

                      setState(() {
                        endDate = date;
                      });
                    },
                    currentTime: DateTime.now(),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd').format(endDate),
                      ),
                      Container(
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.black12,
                        width: 1,
                      ),
                      Text(
                        DateFormat('MM').format(endDate),
                      ),
                      Container(
                        height: 20,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.black12,
                        width: 1,
                      ),
                      Text(
                        DateFormat('yyyy').format(endDate),
                      ),
                    ],
                  ),
                ),
              ),
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
          GradientButton(
            text: 'Show',
            width: true,
            onTap: () async {
              Get.back(
                result: {
                  // 'kyaListClearKru': 'hakrdo',
                  'sort': selectedArrangeBy == 0 ? 'ASC' : 'DSC',
                  "fromDate":
                      isSearchByDate ? fromDate.toIso8601String() : null,
                  "endDate": isSearchByDate ? endDate.toIso8601String() : null,
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
