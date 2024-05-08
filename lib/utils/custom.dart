import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input.substring(0, 1).toUpperCase() + input.substring(1);
}

String formatCurrency(int number) {
  var format = NumberFormat.compact(locale: 'en_IN');
  return format.format(number);
}

generateUPIDeeplink(TextEditingController _upiController, String charges) {
  return "upi://pay?pa=${_upiController.text}&am=$charges";
}
