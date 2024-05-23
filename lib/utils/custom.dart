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

textToSend(String name) {
  return "Hi $name, we hope this message finds you well. We wanted to inform you that your gym subscription has ended. Please feel free to reach out to us if you have any questions or if you'd like to renew your subscription. Have a wonderful day!";
}

bool isTrueString(String? input) {
  return input != null && input.isNotEmpty;
}

int getStartingDayOfMonth(int year, int month) {
  DateTime firstDayOfMonth = DateTime(year, month, 1);
  return firstDayOfMonth.weekday;
}

int getDaysInMonth(int year, int month) {
  DateTime firstDayNextMonth;
  if (month == 12) {
    // if December, go to next year's January
    firstDayNextMonth = DateTime(year + 1, 1, 1);
  } else {
    firstDayNextMonth = DateTime(year, month + 1, 1);
  }
  DateTime lastDayOfMonth = firstDayNextMonth.subtract(const Duration(days: 1));
  return lastDayOfMonth.day;
}

List<String> monthNames = [
  'December',
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];