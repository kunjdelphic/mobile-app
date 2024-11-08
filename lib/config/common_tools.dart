import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parrotpos/models/bill_payment/bill_payment_amounts.dart';

class CommonTools {
  getDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd.MM.yyyy').format(dateTime.toLocal());
  }

  getTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('HH:mm:ss').format(dateTime.toLocal());
  }

  getDateAndTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd.MM.yyyy | HH:mm:ss').format(dateTime.toLocal());
  }

  getModernDateAndTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy | HH:mm:ss').format(dateTime.toLocal());
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color getColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  getMinAmt(BillPaymentAmounts billPaymentAmounts) {
    return billPaymentAmounts.amounts!
        .reduce((e1, e2) => e1.minAmount < e2.minAmount ? e1 : e2)
        .minAmount;
  }

  getMaxAmt(BillPaymentAmounts billPaymentAmounts) {
    return billPaymentAmounts.amounts!
        .reduce((e1, e2) => e1.maxAmount > e2.maxAmount ? e1 : e2)
        .maxAmount;
  }
}
