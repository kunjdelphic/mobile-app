import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:parrotpos/controllers/bill_payment_controller.dart';
import 'package:parrotpos/controllers/user_profile_controller.dart';
import 'package:parrotpos/controllers/wallet_controller.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_categories.dart';
import 'package:parrotpos/screens/bill_payment/bill_pdf_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/wallet_reloade_info_screen.dart';
import 'package:parrotpos/screens/user_profile/transaction_history/transaction_history_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/main_wallet_reload_screen.dart';
import 'package:parrotpos/screens/user_profile/wallet/send_money/contacts_screen.dart';
import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/style.dart';
import 'package:parrotpos/widgets/buttons/gradient_button.dart';
import 'package:parrotpos/widgets/dialogs/common_dialogs.dart';
import 'package:parrotpos/widgets/dialogs/snackbars.dart';
import 'package:progress_state_button/progress_button.dart';

import 'bill_payment _info_screen.dart';

class BillPaymentScreen extends StatefulWidget {
  final int index;
  final BillPaymentCategoriesProducts billPaymentProduct;
  const BillPaymentScreen({Key? key, required this.index, required this.billPaymentProduct}) : super(key: key);

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final BillPaymentController billPaymentController = Get.find();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController accountOwnerController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  BillPaymentAmounts? billPaymentAmounts;
  ButtonState btnState = ButtonState.idle;
  bool isInsertNo = false;
  Contact? contact;
  bool isInvalidNo = false;
  Future<BillPaymentAmounts?>? _futureBillPaymentAmts;
  String cashbackAmt = '0.00';
  final UserProfileController userProfileController = Get.find();
  WalletController walletController = Get.find();
  bool isExceed = false;
  final FocusNode inputNode = FocusNode();
  final FocusNode _focusNode = FocusNode();

  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    inputNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(inputNode);
      });
    } else if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FocusScope.of(context).requestFocus(_focusNode);
    //   FocusScope.of(context).requestFocus(inputNode);
    // });
    print(widget.billPaymentProduct.name);
    for (var element in widget.billPaymentProduct.amounts!) {
      print('MIN :: ${element.minAmount}');
      print('MAX :: ${element.maxAmount}');
      print('CASHBACK :: ${element.cashbackAmount}');
      print('');
    }

    // billPaymentController.getRecentTopUp({});
    // billPaymentController.getTopUpProducts({
    //   "country": "MY",
    // });

    // // _futureBillPaymentAmts = getTopUpAmounts({});
  }

  Future<BillPaymentAmounts?> getTopUpAmounts(Map map) async {
    if (map.isEmpty) {
      return null;
    }
    var res = await billPaymentController.getBillPaymentAmounts(map);
    billPaymentAmounts = res;
    if (res.status == 200) {
      //got it
      return res;
    } else {
      //error
      errorSnackbar(title: 'Failed', subtitle: '${res.message}');
      return res;
    }
  }

  processBillPayment() async {
    setState(() {
      btnState = ButtonState.loading;
    });

    String? res;

    if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')) {
      //send phone no.
      res = await billPaymentController
          .initiateBillPayment({"amount": amountController.text.trim(), "product_id": widget.billPaymentProduct.productId, "account_number": "+6-${phoneNoController.text.trim()}"});
    } else {
      //send account no.
      res = await billPaymentController.initiateBillPayment({
        "amount": amountController.text.trim(),
        "product_id": widget.billPaymentProduct.productId,
        "account_number": accountNoController.text.trim(),
        "account_name": accountOwnerController.text.trim(),
      });
    }

    setState(() {
      btnState = ButtonState.idle;
    });

    if (res!.isEmpty) {
      //done
      await showCompletedTopupDialog(
        context: context,
        onTap: () {
          Get.back();
          Get.back();
          // walletController.getTransactionHistory({}, refreshing: true);
          Get.to(() => const TransactionHistoryScreen());
        },
        onClose: () {
          Get.back();
          Get.back();
        },
        onTapFav: () {},
      );

      userProfileController.getUserDetails();
    } else {
      if (res != 'Server Maintenance InProgress') {
        print(res.toString());

        errorSnackbar(title: 'Failed', subtitle: res);
      }
    }
  }

  showBillPaymentSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setBottomSheetState) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          padding: const EdgeInsets.all(15),
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
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.1),
                                      //     blurRadius: 5,
                                      //     spreadRadius: 1,
                                      //   ),
                                      // ],
                                      color: kWhite,
                                      // color: kWhite,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: kWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Image.network(
                                          widget.billPaymentProduct.logo ?? '',
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            'assets/images/logo/parrot_logo.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.billPaymentProduct.name}',
                                          style: kBlackSmallMediumStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER') ? phoneNoController.text.trim() : accountNoController.text.trim(),
                                          style: kBlackExtraSmallLightMediumStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              FutureBuilder<BillPaymentAmounts?>(
                                future: _futureBillPaymentAmts,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                  if (snapshot.data == null) {
                                    return const SizedBox();
                                  }
                                  if (snapshot.data!.status != 200) {
                                    return const SizedBox();
                                  }

                                  if (snapshot.data!.amounts!.isEmpty) {
                                    return const SizedBox();
                                  }

                                  return snapshot.data!.bill != null
                                      ? Column(
                                          children: [
                                            const Divider(thickness: 0.30),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Outstanding ',
                                                  style: kBlackSmallMediumStyle,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.red,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                  child: Text(
                                                    '${snapshot.data!.amounts!.first.currency} ${snapshot.data!.bill!.outstandingAmount}',
                                                    style: kWhiteSmallMediumStyle,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        FutureBuilder<BillPaymentAmounts?>(
                          future: _futureBillPaymentAmts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (snapshot.data == null) {
                              return const SizedBox();
                            }
                            if (snapshot.data!.status != 200) {
                              return const SizedBox();
                            }

                            if (snapshot.data!.amounts!.isEmpty) {
                              return const SizedBox();
                            }

                            if (snapshot.data!.bill != null && billPaymentAmounts == null) {
                              if (snapshot.data!.bill!.outstandingAmount!.contains('-')) {
                                //skip
                              } else {
                                amountController.text = double.parse(snapshot.data!.bill!.outstandingAmount!.toString()).toInt().toString();
                              }
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Payment Amount',
                                      style: kBlackMediumStyle,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                            color: kWhite,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/icons/ic_cashback.png',
                                              width: 12,
                                              height: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Cash Back: ',
                                              style: kBlackSmallMediumStyle,
                                            ),
                                            Text(
                                              '${snapshot.data!.amounts!.first.currency} $cashbackAmt',
                                              style: kPrimarySmallDarkMediumStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: isExceed ? Colors.red : Colors.black.withOpacity(0.2),
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
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                                            ],
                                            textAlignVertical: TextAlignVertical.center,
                                            controller: amountController,
                                            onChanged: (value) {
                                              // print('$value ---');
                                              // print(widget.billPaymentProduct
                                              //     .amountType);
                                              if (widget.billPaymentProduct.amountType == 'INTEGER' && value.trim().contains('.')) {
                                                print('object');
                                                decimalNotAllowedDialog(context: context);
                                                amountController.text = value.replaceAll('.', '');
                                                amountController.selection = TextSelection.fromPosition(
                                                  TextPosition(offset: amountController.text.length),
                                                );
                                                return;
                                              }

                                              setState(() {});

                                              setBottomSheetState(() {
                                                if (value.trim().isEmpty) {
                                                  cashbackAmt = '0.00';

                                                  isExceed = false;

                                                  return;
                                                }
                                                //check min
                                                if (double.parse(value.trim()) < double.parse(widget.billPaymentProduct.minimumAmount.toString())) {
                                                  //make red

                                                  isExceed = true;
                                                }
                                                //check max
                                                if (double.parse(value.trim()) > double.parse(widget.billPaymentProduct.maximumAmount.toString())) {
                                                  //make red

                                                  isExceed = true;
                                                }

                                                if (double.parse(value.trim()) <= double.parse(widget.billPaymentProduct.maximumAmount.toString())) {
                                                  for (var item in widget.billPaymentProduct.amounts!) {
                                                    if (double.parse(value.trim()) >= double.parse(item.minAmount.toString()) &&
                                                        double.parse(value.trim()) <= double.parse(item.maxAmount.toString())) {
                                                      print('${item.cashbackAmount}');
                                                      cashbackAmt = item.cashbackAmount.toString();

                                                      isExceed = false;

                                                      return;
                                                    }
                                                  }
                                                }
                                              });
                                            },
                                            enableInteractiveSelection: true,
                                            style: kBlackMediumStyle,
                                            textInputAction: TextInputAction.done,
                                            keyboardType: TextInputType.numberWithOptions(
                                              decimal: widget.billPaymentProduct.amountType == 'INTEGER' ? false : true,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
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
                                              suffixIcon: Padding(
                                                padding: const EdgeInsets.only(top: 15, left: 20),
                                                child: Text(
                                                  'Min. ${double.parse(snapshot.data!.info!.minimumAmount).toInt()} | Max. ${double.parse(snapshot.data!.info!.maximumAmount).toInt()}',
                                                  style: kBlackSmallLightMediumStyle,
                                                ),
                                              ),
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
                                        const SizedBox(
                                          width: 5,
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
                                          onTap: () {
                                            setState(() {});
                                            setBottomSheetState(() {
                                              amountController.text = '';
                                              cashbackAmt = '0.00';
                                              isExceed = false;
                                            });
                                          },
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
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Payment Method:',
                          textAlign: TextAlign.start,
                          style: kBlackMediumStyle,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetX<UserProfileController>(
                          init: userProfileController,
                          builder: (_) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kColorPrimary,
                                        kColorPrimaryDark,
                                      ],
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        child: Image.asset(
                                          'assets/images/wallet/wallet_bg_shapes.png',
                                          width: Get.width * 0.3,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Main Wallet',
                                                    style: kWhiteDarkMediumStyle,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SvgPicture.asset(
                                                    'assets/images/logo/logo_full.svg',
                                                    width: Get.width * 0.2,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Balance',
                                                    style: kWhiteDarkMediumStyle,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '${_.userProfile.value.data?.currency} ${_.userProfile.value.data?.mainWalletBalance}',
                                                    style: kWhiteDarkSuperLargeStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                GradientButton(
                                  text: 'Pay Now',
                                  width: false,
                                  widthSize: Get.width * 0.7,
                                  buttonState: ButtonState.idle,
                                  onTap: () {
                                    Get.back();

                                    if (double.parse(_.userProfile.value.data!.mainWalletBalance.toString()) < double.parse(amountController.text.trim())) {
                                      lowWalletBalanceDialog(
                                        image: 'assets/icons/ic_low_wallet_balance.png',
                                        context: context,
                                        onTap: () {
                                          Get.back();
                                          Get.to(() => const MainWalletReloadScreen());
                                        },
                                      );
                                      return;
                                    } else if (widget.billPaymentProduct.amountType == 'INTEGER' && amountController.text.trim().contains('.')) {
                                      decimalNotAllowedDialog(context: context);
                                      return;
                                    }

                                    if (double.parse(amountController.text.trim()) < double.parse(widget.billPaymentProduct.minimumAmount.toString()) ||
                                        double.parse(amountController.text.trim()) > double.parse(widget.billPaymentProduct.maximumAmount.toString())) {
                                      errorSnackbar(
                                          title: 'Failed', subtitle: 'Payment amount should be Min. ${widget.billPaymentProduct.minimumAmount} | Max. ${widget.billPaymentProduct.maximumAmount}');
                                      return;
                                    }

                                    processBillPayment();
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          },
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
          IconButton(
            onPressed: () {
              Get.to(() => BillInfoScreen(billPaymentProduct: widget.billPaymentProduct));
              // widget.billPaymentProduct.helpText == ""
              //     ? errorSnackbar(title: "Info", subtitle: "This Product Not Available Info")
              //     : infoMassageDialog(
              //         context: context,
              //         text: widget.billPaymentProduct.helpText,
              //       );
            },
            icon: const Icon(
              Icons.error_outline,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: Get.width * 0.5,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Hero(
                  tag: '${widget.billPaymentProduct.productId}',
                  child: Center(
                    child: Image.network(
                      '${widget.billPaymentProduct.logo}',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/logo/parrot_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                widget.billPaymentProduct.name!.split(' ').map((e) => e.capitalize).join(" "),
                style: kBlackDarkMediumStyle,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'PHONE_NUMBER')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Number',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // contact = await Get.to(() => const ContactsScreen());
                              FocusScope.of(context).unfocus();
                              userProfileController.checkContactPermission(context).then((value) {
                                if (userProfileController.contacts.isNotEmpty ?? false) {
                                  // String coNo = contact!.phones!.first.value!.trim();
                                  String coNo = "${userProfileController.contacts.first.phoneNumbers}";
                                  coNo = coNo.replaceAll('-', '').toString();
                                  coNo = coNo.replaceAll(' ', '').toString();
                                  coNo = coNo.replaceAll('(', '').toString();
                                  coNo = coNo.replaceAll(')', '').toString();
                                  coNo = coNo.replaceAll('[', '').toString();
                                  coNo = coNo.replaceAll(']', '').toString();
                                  coNo = coNo.replaceAll('+6', '').toString();

                                  if (coNo.startsWith('+6')) {
                                    coNo = coNo.substring(2);
                                  }

                                  phoneNoController.text = coNo;

                                  if ((coNo.trim().length < 10 || coNo.trim().length > 11) || !coNo.trim().startsWith('01')) {
                                    //invalid no
                                    print('INVALID NO');
                                    setState(() {
                                      isInvalidNo = true;
                                      isInsertNo = false;
                                    });

                                    return;
                                  }

                                  if (isInsertNo || isInvalidNo) {
                                    setState(() {
                                      isInsertNo = false;
                                      isInvalidNo = false;
                                    });
                                  }

                                  billPaymentAmounts = null;

                                  // _futureBillPaymentAmts = getTopUpAmounts({
                                  //   "product_id":
                                  //       "${widget.billPaymentProduct.productId}",
                                  //   "country": "MY",
                                  //   "account_number": coNo
                                  // });

                                  if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_OWNER_IC_NUMBER')) {
                                    _futureBillPaymentAmts = getTopUpAmounts({
                                      "product_id": "${widget.billPaymentProduct.productId}",
                                      "country": "MY",
                                      "account_number": coNo,
                                      'account_name': accountOwnerController.text.trim(),
                                    });
                                  } else {
                                    _futureBillPaymentAmts = getTopUpAmounts({
                                      "product_id": "${widget.billPaymentProduct.productId}",
                                      "country": "MY",
                                      "account_number": coNo,
                                    });
                                  }

                                  setState(() {});
                                }
                              });
                            },
                            child: Container(
                              width: 45,
                              height: 47,
                              padding: const EdgeInsets.all(5),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/wallet/phonebook.png',
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
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
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: TextField(
                                            controller: phoneNoController,
                                            textAlignVertical: TextAlignVertical.center,
                                            // validator: (value) {
                                            //   if (value!.trim().isEmpty) {
                                            //     return 'Phone number is required';
                                            //   }
                                            //   if (!value.trim().startsWith('01')) {
                                            //     return 'Phone number is invalid';
                                            //   }
                                            //   if (value.trim().length < 10 ||
                                            //       value.trim().length > 11) {
                                            //     return 'Phone number is invalid';
                                            //   }
                                            //   return null;
                                            // },
                                            onChanged: (value) {
                                              if (isInsertNo || isInvalidNo) {
                                                setState(() {
                                                  isInsertNo = false;
                                                  isInvalidNo = false;
                                                });
                                              }

                                              //  if (widget.billPaymentProduct
                                              //         .fieldsRequired!
                                              //         .singleWhere((element) =>
                                              //             element.type ==
                                              //             'PHONE_NUMBER')
                                              //         .minLength !=
                                              //     '-1') {
                                              //   if (value.toString().length <
                                              //       widget.billPaymentProduct
                                              //           .fieldsRequired!
                                              //           .singleWhere(
                                              //               (element) =>
                                              //                   element.type ==
                                              //                   'PHONE_NUMBER')
                                              //           .minLength) {
                                              //     return;
                                              //   }
                                              // }

                                              if (value.trim().length >= 10 && value.trim().length <= 11) {
                                                //fetch
                                                billPaymentAmounts = null;
                                                if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_OWNER_IC_NUMBER')) {
                                                  _futureBillPaymentAmts = getTopUpAmounts({
                                                    "product_id": "${widget.billPaymentProduct.productId}",
                                                    "country": "MY",
                                                    "account_number": value.trim(),
                                                    'account_name': accountOwnerController.text.trim(),
                                                  });
                                                } else {
                                                  _futureBillPaymentAmts = getTopUpAmounts({
                                                    "product_id": "${widget.billPaymentProduct.productId}",
                                                    "country": "MY",
                                                    "account_number": value.trim(),
                                                  });
                                                }
                                              } else {
                                                if (billPaymentAmounts != null) {
                                                  billPaymentAmounts = null;
                                                  _futureBillPaymentAmts = getTopUpAmounts({});
                                                }
                                              }
                                              setState(() {});
                                            },
                                            // autofocus: true,
                                            focusNode: inputNode,
                                            enableInteractiveSelection: true,
                                            style: kBlackMediumStyle,
                                            textInputAction: TextInputAction.done,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                              helperStyle: kBlackSmallLightMediumStyle,
                                              errorStyle: kBlackSmallLightMediumStyle,
                                              hintStyle: kBlackSmallLightMediumStyle,
                                              hintText: 'Eg: 0123456789',
                                              labelStyle: kBlackSmallLightMediumStyle,
                                              fillColor: kWhite,
                                              filled: true,
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              // suffixIcon: phoneNoController.text.trim().isNotEmpty
                                              //     ? GestureDetector(
                                              //         onTap: () => setState(() {
                                              //           phoneNoController.text = '';
                                              //         }),
                                              //         child: const Icon(
                                              //           Icons.close,
                                              //           color: Colors.black38,
                                              //           size: 18,
                                              //         ),
                                              //       )
                                              //     : const SizedBox(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
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
                                          phoneNoController.text = '';
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            isInsertNo = false;
                                            isInvalidNo = false;

                                            billPaymentAmounts = null;
                                            _futureBillPaymentAmts = getTopUpAmounts({});
                                          });
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, right: 5),
                                  child: Text(
                                    isInsertNo
                                        ? 'Enter Phone Number'
                                        : isInvalidNo
                                            ? 'Invalid Phone Number'
                                            : '',
                                    style: kRedSmallMediumStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  )
                : const SizedBox(),
            widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Number',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 20,
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
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextFormField(
                                  focusNode: _focusNode,
                                  controller: accountNoController,
                                  textAlignVertical: TextAlignVertical.center,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                  ],
                                  // validator: (value) {
                                  //   if (value!.trim().isEmpty) {
                                  //     return 'Phone number is required';
                                  //   }
                                  //   if (!value.trim().startsWith('01')) {
                                  //     return 'Phone number is invalid';
                                  //   }
                                  //   if (value.trim().length < 10 ||
                                  //       value.trim().length > 11) {
                                  //     return 'Phone number is invalid';
                                  //   }
                                  //   return null;
                                  // },
                                  onChanged: (value) {
                                    if (isInsertNo) {
                                      setState(() {
                                        isInsertNo = false;
                                      });
                                    }

                                    _futureBillPaymentAmts = null;

                                    if (widget.billPaymentProduct.fieldsRequired!.singleWhere((element) => element.type == 'ACCOUNT_NUMBER').minLength.toString() != '-1') {
                                      if (value.toString().length <
                                          double.parse(widget.billPaymentProduct.fieldsRequired!.singleWhere((element) => element.type == 'ACCOUNT_NUMBER').minLength.toString())) {
                                        if (billPaymentAmounts != null) {
                                          billPaymentAmounts = null;
                                          _futureBillPaymentAmts = getTopUpAmounts({});
                                        }
                                      } else {
                                        billPaymentAmounts = null;

                                        if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_OWNER_IC_NUMBER')) {
                                          _futureBillPaymentAmts = getTopUpAmounts({
                                            "product_id": "${widget.billPaymentProduct.productId}",
                                            "country": "MY",
                                            "account_number": value.trim(),
                                            'account_name': accountOwnerController.text.trim(),
                                          });
                                        } else {
                                          _futureBillPaymentAmts = getTopUpAmounts({
                                            "product_id": "${widget.billPaymentProduct.productId}",
                                            "country": "MY",
                                            "account_number": value.trim(),
                                          });
                                        }

                                        // _futureBillPaymentAmts =
                                        //     getTopUpAmounts({
                                        //   "product_id":
                                        //       "${widget.billPaymentProduct.productId}",
                                        //   "country": "MY",
                                        //   "account_number": value.trim()
                                        // });
                                      }
                                    } else {
                                      billPaymentAmounts = null;

                                      if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_OWNER_IC_NUMBER')) {
                                        _futureBillPaymentAmts = getTopUpAmounts({
                                          "product_id": "${widget.billPaymentProduct.productId}",
                                          "country": "MY",
                                          "account_number": value.trim(),
                                          'account_name': accountOwnerController.text.trim(),
                                        });
                                      } else {
                                        _futureBillPaymentAmts = getTopUpAmounts({
                                          "product_id": "${widget.billPaymentProduct.productId}",
                                          "country": "MY",
                                          "account_number": value.trim(),
                                        });
                                      }
                                    }

                                    // if (value.trim().length >= 5) {
                                    //   //fetch
                                    //   billPaymentAmounts = null;

                                    //   _futureBillPaymentAmts = getTopUpAmounts({
                                    //     "product_id":
                                    //         "${widget.billPaymentProduct.productId}",
                                    //     "country": "MY",
                                    //     "account_number": value.trim()
                                    //   });
                                    // } else {
                                    //   if (billPaymentAmounts != null) {
                                    //     billPaymentAmounts = null;
                                    //     _futureBillPaymentAmts =
                                    //         getTopUpAmounts({});
                                    //   }
                                    // }
                                    setState(() {});
                                  },
                                  enableInteractiveSelection: true,
                                  style: kBlackMediumStyle,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                    helperStyle: kBlackSmallLightMediumStyle,
                                    errorStyle: kBlackSmallLightMediumStyle,
                                    hintStyle: kBlackSmallLightMediumStyle,
                                    hintText: 'Enter your account number',
                                    labelStyle: kBlackSmallLightMediumStyle,
                                    fillColor: kWhite,
                                    filled: true,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    // suffixIcon: phoneNoController.text.trim().isNotEmpty
                                    //     ? GestureDetector(
                                    //         onTap: () => setState(() {
                                    //           phoneNoController.text = '';
                                    //         }),
                                    //         child: const Icon(
                                    //           Icons.close,
                                    //           color: Colors.black38,
                                    //           size: 18,
                                    //         ),
                                    //       )
                                    //     : const SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
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
                                accountNoController.text = '';
                                setState(() {
                                  isInsertNo = false;

                                  billPaymentAmounts = null;
                                  _futureBillPaymentAmts = getTopUpAmounts({});
                                });
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 5),
                        child: Text(
                          isInsertNo ? 'Enter Account Number' : '',
                          style: kRedSmallMediumStyle,
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  )
                : const SizedBox(),
            FutureBuilder<BillPaymentAmounts?>(
              future: _futureBillPaymentAmts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: LinearProgressIndicator(
                      color: kAccentColor,

                      // indicatorType: Indicator.lineScalePulseOut,
                      // colors: [
                      //   kAccentColor,
                      // ],
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                if (snapshot.data!.status != 200) {
                  return const SizedBox();
                }

                if (snapshot.data!.amounts!.isEmpty) {
                  return const SizedBox();
                }

                if (snapshot.data!.bill != null && billPaymentAmounts == null) {
                  if (snapshot.data!.bill!.outstandingAmount!.contains('-')) {
                    //skip
                  } else {
                    amountController.text = double.parse(snapshot.data!.bill!.outstandingAmount!.toString()).toInt().toString();
                  }
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    snapshot.data!.bill != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: const Color(0xffF6F6F6),
                                  // color: kWhite,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 35,
                                          height: 35,
                                          padding: const EdgeInsets.all(5),
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
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/icons/bill_payment/ic_person.png',
                                              width: 18,
                                              height: 18,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '${snapshot.data!.bill!.accountHolderName}',
                                          style: kBlackMediumStyle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 35,
                                                height: 35,
                                                padding: const EdgeInsets.all(5),
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
                                                  borderRadius: BorderRadius.circular(100),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/icons/bill_payment/ic_outstanding_amt.png',
                                                    width: 18,
                                                    height: 18,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${snapshot.data!.amounts!.first.currency} ${snapshot.data!.bill!.outstandingAmount}',
                                                    style: kBlackMediumStyle,
                                                  ),
                                                  Text(
                                                    'Outstanding Amount',
                                                    style: kBlackSmallLightMediumStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        snapshot.data!.bill != null && widget.billPaymentProduct.name == 'TENAGA NASIONAL BERHAD'
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(() => BillPdfScreen(
                                                        billPaymentAmounts: snapshot.data,
                                                      ));
                                                },
                                                child: Container(
                                                  height: 40,
                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        kWhite,
                                                        Color(0xffE4F0FA),
                                                      ],
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: const Offset(0, 0),
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'View Bill',
                                                        style: kBlackSmallMediumStyle,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        color: Colors.black45,
                                                        size: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Amount',
                  style: kBlackMediumStyle,
                ),
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                        color: kWhite,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/ic_cashback.png',
                          width: 12,
                          height: 12,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          'Cash Back: ',
                          style: kBlackSmallMediumStyle,
                        ),
                        Text(
                          '${widget.billPaymentProduct.amounts!.first.currency} $cashbackAmt',
                          style: kPrimarySmallDarkMediumStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: isExceed ? Colors.red : Colors.black.withOpacity(0.2),
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        ],
                        textAlignVertical: TextAlignVertical.center,
                        controller: amountController,
                        onChanged: (value) {
                          print(value);
                          print('$value ---');
                          print(widget.billPaymentProduct.amountType);
                          if (widget.billPaymentProduct.amountType == 'INTEGER' && value.trim().contains('.')) {
                            print('object');
                            decimalNotAllowedDialog(context: context);
                            amountController.text = value.replaceAll('.', '');
                            amountController.selection = TextSelection.fromPosition(
                              TextPosition(offset: amountController.text.length),
                            );

                            return;
                          }
                          setState(() {
                            if (value.trim().isEmpty) {
                              cashbackAmt = '0.00';

                              isExceed = false;

                              return;
                            }
                            //check min
                            if (double.parse(value.trim()) < double.parse(widget.billPaymentProduct.minimumAmount.toString())) {
                              //make red

                              isExceed = true;
                            }
                            //check max
                            if (double.parse(value.trim()) > double.parse(widget.billPaymentProduct.maximumAmount.toString())) {
                              //make red

                              isExceed = true;
                            }

                            if (double.parse(value.trim()) <= double.parse(widget.billPaymentProduct.maximumAmount.toString())) {
                              for (var item in widget.billPaymentProduct.amounts!) {
                                if (double.parse(value.trim()) >= double.parse(item.minAmount.toString()) && double.parse(value.trim()) <= double.parse(item.maxAmount.toString())) {
                                  print('${item.cashbackAmount}');
                                  cashbackAmt = item.cashbackAmount.toString();

                                  isExceed = false;

                                  return;
                                }
                              }
                            }
                            // else {
                            //   errorSnackbar(
                            //       title: 'Failed',
                            //       subtitle:
                            //           'You cannot exceed the max amount!');
                            // }
                          });
                        },
                        enableInteractiveSelection: true,
                        style: kBlackMediumStyle,
                        textInputAction: TextInputAction.done,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
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
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20),
                            child: Text(
                              'Min. ${double.parse(widget.billPaymentProduct.minimumAmount).toInt()} | Max. ${double.parse(widget.billPaymentProduct.maximumAmount).toInt()}',
                              style: isExceed ? kRedSmallLightMediumStyle : kBlackSmallLightMediumStyle,
                            ),
                          ),
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
                    const SizedBox(
                      width: 5,
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
                        cashbackAmt = '0.00';
                        isExceed = false;
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
              height: 25,
            ),
            widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_OWNER_IC_NUMBER')
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Owner I.C. Number (optional)',
                        style: kBlackMediumStyle,
                      ),
                      const SizedBox(
                        height: 20,
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
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: TextFormField(
                                  controller: accountOwnerController,
                                  textAlignVertical: TextAlignVertical.center,
                                  // validator: (value) {
                                  //   if (value!.trim().isEmpty) {
                                  //     return 'Phone number is required';
                                  //   }
                                  //   if (!value.trim().startsWith('01')) {
                                  //     return 'Phone number is invalid';
                                  //   }
                                  //   if (value.trim().length < 10 ||
                                  //       value.trim().length > 11) {
                                  //     return 'Phone number is invalid';
                                  //   }
                                  //   return null;
                                  // },
                                  // onChanged: (value) {
                                  //   if (isInsertNo || isInvalidNo) {
                                  //     setState(() {
                                  //       isInsertNo = false;
                                  //       isInvalidNo = false;
                                  //     });
                                  //   }

                                  //   if (value.trim().length >= 10 &&
                                  //       value.trim().length <= 11) {
                                  //     //fetch
                                  //     billPaymentAmounts = null;
                                  //     _futureBillPaymentAmts = getTopUpAmounts({
                                  //       "product_id":
                                  //           "${widget.billPaymentProduct.productId}",
                                  //       "country": "MY",
                                  //       "account_number": "ghr568hui78"
                                  //     });
                                  //   } else {
                                  //     if (billPaymentAmounts != null) {
                                  //       billPaymentAmounts = null;
                                  //       _futureBillPaymentAmts =
                                  //           getTopUpAmounts({});
                                  //     }
                                  //   }
                                  //   setState(() {});
                                  // },
                                  enableInteractiveSelection: true,
                                  style: kBlackMediumStyle,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                                    helperStyle: kBlackSmallLightMediumStyle,
                                    errorStyle: kBlackSmallLightMediumStyle,
                                    hintStyle: kBlackSmallLightMediumStyle,
                                    hintText: 'Enter IC number',
                                    labelStyle: kBlackSmallLightMediumStyle,
                                    fillColor: kWhite,
                                    filled: true,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    // suffixIcon: phoneNoController.text.trim().isNotEmpty
                                    //     ? GestureDetector(
                                    //         onTap: () => setState(() {
                                    //           phoneNoController.text = '';
                                    //         }),
                                    //         child: const Icon(
                                    //           Icons.close,
                                    //           color: Colors.black38,
                                    //           size: 18,
                                    //         ),
                                    //       )
                                    //     : const SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
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
                                accountOwnerController.text = '';
                                // setState(() {
                                //   isInsertNo = false;
                                //   isInvalidNo = false;

                                //   billPaymentAmounts = null;
                                //   _futureBillPaymentAmts = getTopUpAmounts({});
                                // });
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
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  )
                : const SizedBox(),
            GradientButton(
              text: 'Continue',
              width: false,
              widthSize: Get.width,
              buttonState: btnState,
              onTap: () {
                FocusScope.of(context).unfocus();
                if (widget.billPaymentProduct.fieldsRequired!.any((element) => element.type == 'ACCOUNT_NUMBER')) {
                  //account no.

                  if (accountNoController.text.trim().isEmpty) {
                    setState(() {
                      isInsertNo = true;
                    });
                    // errorSnackbar(
                    //     title: 'Failed',
                    //     subtitle: 'Enter phone number to proceed!');
                    return;
                  }
                } else {
                  //phone no.
                  if (phoneNoController.text.trim().isEmpty) {
                    setState(() {
                      isInsertNo = true;
                    });
                    // errorSnackbar(
                    //     title: 'Failed',
                    //     subtitle: 'Enter phone number to proceed!');
                    return;
                  } else if (phoneNoController.text.trim().length < 10 || phoneNoController.text.trim().length > 11 || !phoneNoController.text.trim().startsWith('01')) {
                    setState(() {
                      isInvalidNo = true;
                    });
                    // errorSnackbar(
                    //     title: 'Failed',
                    //     subtitle: 'Phone number is invalid!');
                    return;
                  }
                }

                if (amountController.text.trim().isEmpty) {
                  errorSnackbar(title: 'Failed', subtitle: 'Enter amount!');
                } else {
                  if (widget.billPaymentProduct.amountType == 'INTEGER' && amountController.text.trim().contains('.')) {
                    decimalNotAllowedDialog(context: context);
                    return;
                  }
                  if (double.parse(amountController.text.trim()) < double.parse(widget.billPaymentProduct.minimumAmount.toString()) ||
                      double.parse(amountController.text.trim()) > double.parse(widget.billPaymentProduct.maximumAmount.toString())) {
                    errorSnackbar(title: 'Failed', subtitle: 'Payment amount should be Min. ${widget.billPaymentProduct.minimumAmount} | Max. ${widget.billPaymentProduct.maximumAmount}');
                    return;
                  }
                  showBillPaymentSheet();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
