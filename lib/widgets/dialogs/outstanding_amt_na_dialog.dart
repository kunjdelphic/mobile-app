import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_text/styled_text.dart';

import '../../style/colors.dart';

class OutstandingAmtNaDialog extends StatefulWidget {
  const OutstandingAmtNaDialog({Key? key}) : super(key: key);

  @override
  _OutstandingAmtNaDialogState createState() => _OutstandingAmtNaDialogState();
}

class _OutstandingAmtNaDialogState extends State<OutstandingAmtNaDialog> {
  bool isChecked = false;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();

    initialiseSP();
  }

  initialiseSP() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var res = sharedPreferences!.getBool('outstanding_amt');
    if (res != null) {
      setState(() {
        isChecked = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      // insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Image.asset(
                  'assets/icons/favorite/due_amt_na.png',
                  width: Get.width * 0.2,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Due amount for this bill is currently unavailable.',
                  textAlign: TextAlign.center,
                  style: kBlackDarkExtraLargeStyle,
                ),

                const SizedBox(
                  height: 12.0,
                ),
                StyledText(
                  text: 'But you can still <fail>pay your bills!</fail>',
                  textAlign: TextAlign.center,
                  style: kBlackDarkLargeStyle,
                  tags: {
                    'fail': StyledTextActionTag(
                      (_, attrs) {},
                      style: kGreenDarkLargeStyle,
                    ),
                  },
                ),
                const Divider(thickness: 0.30),
                Text(
                  'Unforeseen technical error from our payees may sometimes not show the outstanding amount, but you may continue to pay your bills as usual.',
                  style: kBlackSmallLightMediumStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 6,
                ),
                CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.all(0),
                    value: isChecked,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: kGreenColor,
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    title: Text(
                      'Don’t show this message again.',
                      style: kRedDarkMediumStyle,
                    ),
                    onChanged: (val) async {
                      setState(() {
                        isChecked = val!;
                      });

                      await sharedPreferences!.setBool('outstanding_amt', isChecked);
                    }),
                // const SizedBox(
                //   height: 6,
                // ),
                const Divider(thickness: 0.30),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'Close',
                        width: false,
                        widthSize: 0,
                        onTap: () {
                          Get.back();
                        },
                        buttonState: ButtonState.idle,
                      ),
                    ),
                  ],
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
  }
}
