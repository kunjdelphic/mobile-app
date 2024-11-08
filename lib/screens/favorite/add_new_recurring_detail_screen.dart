import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/controllers/favorite_controller.dart';
import 'package:parrotpos/models/favorite/recurring.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

class AddNewRecurringDetailScreen extends StatefulWidget {
  final RecurringData recurringData;
  const AddNewRecurringDetailScreen({Key? key, required this.recurringData})
      : super(key: key);

  @override
  State<AddNewRecurringDetailScreen> createState() =>
      _AddNewRecurringDetailScreenState();
}

class _AddNewRecurringDetailScreenState
    extends State<AddNewRecurringDetailScreen> {
  int selectedReminderType = 0;
  int selectedWeekday = -1;
  int selectedDate = -1;
  ButtonState btnState = ButtonState.idle;
  bool selectDay = false;
  bool selectMonth = false;
  bool selectTime = false;
  bool selectAmount = false;
  DateTime? selectedTime;
  TextEditingController amountController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final FavoriteController favoriteController = Get.find();

  showAddRecurringSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) setBottomSheetState) {
            return SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 7,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 1.5,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: Get.width,
                          // padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                spreadRadius: 2,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  '${widget.recurringData.productImage}',
                                  fit: BoxFit.contain,
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/logo/parrot_logo.png',
                                    fit: BoxFit.contain,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.recurringData.nickName ?? 'NA',
                                        style: kBlackMediumStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '${widget.recurringData.productName}',
                                        style: kBlackExtraSmallMediumStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        widget.recurringData.accountNumber ??
                                            'NA',
                                        style: kBlackExtraSmallMediumStyle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Image.asset(
                                  'assets/icons/favorite/ic_recurring.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Payment Amount:',
                          textAlign: TextAlign.start,
                          style: kBlackMediumStyle,
                        ),
                        Text(
                          amountController.text,
                          textAlign: TextAlign.start,
                          style: kBlackLightMediumStyle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Recurring Type:',
                          textAlign: TextAlign.start,
                          style: kBlackMediumStyle,
                        ),
                        Text(
                          selectedReminderType == 0 ? 'Monthly' : 'Weekly',
                          textAlign: TextAlign.start,
                          style: kBlackLightMediumStyle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Payment Date/Day:',
                          textAlign: TextAlign.start,
                          style: kBlackMediumStyle,
                        ),
                        Text(
                          selectedReminderType == 0
                              ? '${selectedDate + 1}'
                              : Config().weekdays[selectedWeekday],
                          textAlign: TextAlign.start,
                          style: kBlackLightMediumStyle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Payment Time:',
                          textAlign: TextAlign.start,
                          style: kBlackMediumStyle,
                        ),
                        Text(
                          DateFormat('hh:mm a').format(selectedTime!),
                          textAlign: TextAlign.start,
                          style: kBlackLightMediumStyle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GradientButton(
                          text: 'Confirm',
                          width: false,
                          widthSize: Get.width * 0.7,
                          buttonState: ButtonState.idle,
                          onTap: () {
                            Get.back();

                            addRecurring();
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  addRecurring() async {
    setState(() {
      btnState = ButtonState.loading;
    });

    var res;

    res = await favoriteController.addNewRecurring({
      "amount": amountController.text.trim(),
      "favorite_id": "${widget.recurringData.favoriteId}",
      "recurring_type": selectedReminderType == 0 ? 'Monthly' : 'Weekly',
      "recurring_day":
          selectedReminderType == 0 ? selectedDate + 1 : selectedWeekday,
      "recurring_hour": selectedTime!.hour,
      "recurring_minute": selectedTime!.minute,
    });

    setState(() {
      btnState = ButtonState.idle;
    });

    if (res!.isEmpty) {
      //done
      favoriteController.getAllRecurring({});
      Get.back();
      Get.back();
      // successSnackbar(title: 'Success', subtitle: 'Recurring added!');
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: res);
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
          'Recurring',
          style: kBlackLargeStyle,
        ),
      ),
      body: ListView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        children: [
          Container(
            width: Get.width,
            // padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    '${widget.recurringData.productImage}',
                    fit: BoxFit.contain,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/logo/parrot_logo.png',
                      fit: BoxFit.contain,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.recurringData.nickName ?? 'NA',
                          style: kBlackMediumStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          '${widget.recurringData.productName}',
                          style: kBlackExtraSmallMediumStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          widget.recurringData.accountNumber ?? 'NA',
                          style: kBlackExtraSmallMediumStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    'assets/icons/favorite/ic_recurring.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Payment amount:',
            style: kBlackDarkMediumStyle,
          ),
          const SizedBox(
            height: 25,
          ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'RM',
                      style: kBlackMediumStyle,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 20,
                    color: Colors.black12,
                    width: 1,
                  ),
                  Expanded(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: amountController,
                      onChanged: (value) {
                        setState(() {
                          selectAmount = false;
                        });
                      },
                      enableInteractiveSelection: true,
                      style: kBlackMediumStyle,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 14),
                        helperStyle: kBlackSmallLightMediumStyle,
                        errorStyle: kBlackSmallLightMediumStyle,
                        hintStyle: kBlackSmallLightMediumStyle,
                        // hintText: 'Min. 10 | Max. 10,000',
                        labelStyle: kBlackSmallLightMediumStyle,
                        fillColor: kWhite,
                        filled: true,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        // suffixIcon: amountController.text.trim().isNotEmpty
                        //     ? Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(left: 20),
                        //             child: Text(
                        //               'Min. 10 | Max. 10,000',
                        //               style: kBlackSmallLightMediumStyle,
                        //             ),
                        //           ),
                        //           const SizedBox(
                        //             width: 10,
                        //           ),
                        //           Container(
                        //             height: 20,
                        //             color: Colors.black12,
                        //             width: 1,
                        //           ),
                        //           GestureDetector(
                        //             onTap: () => setState(() {
                        //               amountController.text = '';
                        //             }),
                        //             child: const Icon(
                        //               Icons.close,
                        //               color: Colors.black38,
                        //             ),
                        //           ),
                        //         ],
                        //       )
                        //     : const SizedBox(),
                      ),
                    ),
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
                      amountController.text = '';
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
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
            child: selectAmount
                ? Text(
                    'Insert Payment Amount',
                    textAlign: TextAlign.end,
                    style: kRedSmallMediumStyle,
                  )
                : const SizedBox(),
          ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Recurring type:',
            style: kBlackDarkMediumStyle,
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedReminderType = 0;
                      });
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: selectedReminderType == 0
                              ? [
                                  kColorPrimary,
                                  kColorPrimaryDark,
                                ]
                              : [
                                  const Color(0xffEDEDED),
                                  const Color(0xffEDEDED),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Monthly',
                          overflow: TextOverflow.ellipsis,
                          style: selectedReminderType == 0
                              ? kWhiteMediumStyle
                              : kBlackLightMediumStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedReminderType = 1;
                      });
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: selectedReminderType == 1
                              ? [
                                  kColorPrimary,
                                  kColorPrimaryDark,
                                ]
                              : [
                                  const Color(0xffEDEDED),
                                  const Color(0xffEDEDED),
                                ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Weekly',
                          overflow: TextOverflow.ellipsis,
                          style: selectedReminderType == 1
                              ? kWhiteMediumStyle
                              : kBlackLightMediumStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 10,
          ),
          Text(
            selectedReminderType == 0
                ? 'Select the payment date:'
                : 'Select the payment day:',
            style: kBlackDarkMediumStyle,
          ),
          const SizedBox(
            height: 25,
          ),
          selectedReminderType == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: Get.width * 0.15,
                          mainAxisExtent: Get.width * 0.15,
                          // crossAxisCount: 6,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 0,
                        ),
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            if (index >= 28) {
                              return;
                            }
                            setState(() {
                              selectedDate = index;
                              selectMonth = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: kWhite,
                              border: selectedDate == index
                                  ? Border.all(
                                      color: kColorPrimary,
                                      width: 1.5,
                                    )
                                  : const Border(),
                              gradient: selectedDate == index
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
                                  color: selectedDate == index
                                      ? Colors.black.withOpacity(0.2)
                                      : Colors.transparent,
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: index == 28 || index == 29 || index == 30
                                    ? kBlackExtraLightMediumStyle
                                    : selectedDate == index
                                        ? kWhiteDarkMediumStyle
                                        : kBlackMediumStyle,
                              ),
                            ),
                          ),
                        ),
                        itemCount: 31,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: selectMonth
                          ? Text(
                              'Date Not Selected',
                              textAlign: TextAlign.end,
                              style: kRedSmallMediumStyle,
                            )
                          : const SizedBox(),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedWeekday = index;
                              selectDay = false;
                            });
                          },
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: selectedWeekday == index
                                      ? kColorPrimary
                                      : Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius:
                                      selectedWeekday == index ? 2 : 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                Config().weekdays[index],
                                overflow: TextOverflow.ellipsis,
                                style: selectedWeekday == index
                                    ? kBlackDarkMediumStyle
                                    : kBlackLightMediumStyle,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: Config().weekdays.length,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                      child: selectDay
                          ? Text(
                              'Day Not Selected',
                              textAlign: TextAlign.end,
                              style: kRedSmallMediumStyle,
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Select the payment time:',
            style: kBlackDarkMediumStyle,
          ),
          const SizedBox(
            height: 25,
          ),
          TimePickerSpinner(
            is24HourMode: false,
            isForce2Digits: true,
            highlightedTextStyle: kBlackDarkLargeStyle,
            normalTextStyle: kBlackLightLargeStyle,
            spacing: 15,
            itemHeight: 45,
            onTimeChange: (p0) {
              setState(() {
                selectedTime = p0;
                selectTime = false;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 20,
            child: selectTime
                ? Text(
                    'Time Not Selected',
                    textAlign: TextAlign.end,
                    style: kRedSmallMediumStyle,
                  )
                : const SizedBox(),
          ),
          const Divider(thickness: 0.30),
          const SizedBox(
            height: 10,
          ),
          GradientButton(
            text: 'Next',
            width: false,
            widthSize: Get.width,
            buttonState: btnState,
            onTap: () {
              if (amountController.text.trim().isEmpty) {
                setState(() {
                  selectAmount = true;
                  scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                });
                return;
              }
              if (selectedReminderType == 0
                  ? selectedDate == -1
                  : selectedWeekday == -1) {
                setState(() {
                  selectMonth = true;
                  selectDay = true;
                });
                return;
              }
              if (selectedTime == null) {
                setState(() {
                  selectTime = true;
                });
                return;
              }
              showAddRecurringSheet();
            },
          ),
        ],
      ),
    );
  }
}
