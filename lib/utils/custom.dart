import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:location/location.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input.substring(0, 1).toUpperCase() + input.substring(1);
}

double radians(double degrees) {
  return degrees * (pi / 180);
}

String formatCurrency(int number) {
  var format = intl.NumberFormat.compact(locale: 'en_IN');
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

Future<void> captureAndShareWidget(
    Widget widgetToShare, String textToShare) async {
  ScreenshotController screenshotController = ScreenshotController();

  screenshotController
      .captureFromWidget(
    Directionality(textDirection: TextDirection.ltr, child: widgetToShare),
  )
      .then((Uint8List image) async {
    File file = await File('${(await getTemporaryDirectory()).path}/image.png')
        .create();
    file.writeAsBytesSync(image);

    Share.shareXFiles([XFile(file.path)], text: textToShare);
  });
}

String addValidTillToCurrDate(String currentBeginDate, int validTill) {
  final monthNameAndNumber = {
    'Jan': 0,
    'Feb': 1,
    'Mar': 2,
    'Apr': 3,
    'May': 4,
    'Jun': 5,
    'Jul': 6,
    'Aug': 7,
    'Sep': 8,
    'Oct': 9,
    'Nov': 10,
    'Dec': 11
  };

  final parts = currentBeginDate.split(" ");
  final day = int.parse(parts[0]);
  final month = parts[1];
  final year = int.parse(parts[2]);

  final monthNumber = monthNameAndNumber[month];

  if (monthNumber != null) {
    final date = DateTime(year, monthNumber + 1, day);
    final newDate = _addMonths(date, validTill);

    return "${newDate.day.toString().padLeft(2, '0')} ${_getMonthName(newDate.month)} ${newDate.year}";
  }
  return "Month not found";
}

String _getMonthName(int month) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

int? getShortMonthNumber(String month) {
  final monthNumber = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12
  };

  return monthNumber[month];
}

DateTime _addMonths(DateTime date, int monthsToAdd) {
  final year = (date.year + (date.month + monthsToAdd) ~/ 12);
  final month = (date.month + monthsToAdd) % 12;
  final day = date.day;
  return DateTime(year, month, day);
}

class LocationResult {
  final bool success;
  final double latitude;
  final double longitude;

  LocationResult(
      {required this.success, required this.latitude, required this.longitude});
}

int? tryParseInt(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      return int.parse(value);
    } catch (e) {
      print("Error parsing integer: $e");
      return null;
    }
  }

Future<LocationResult> getCurrentLocationSuccess() async {
  var status = await Permission.location.request();

  if (status.isGranted) {
    try {
      LocationData locationData = await Location().getLocation().timeout(
        const Duration(seconds: 5),
        onTimeout: () async {
          return await Location().getLocation().timeout(const Duration(seconds: 5),
              onTimeout: () async {
            throw TimeoutException('location timed out 2 times');
          });
        },
      );

      return LocationResult(
        success: true,
        latitude: locationData.latitude ?? 0,
        longitude: locationData.longitude ?? 0,
      );
    } catch (e) {
      print(e);
      return LocationResult(success: false, latitude: 0, longitude: 0);
    }
  } else {
    return LocationResult(success: false, latitude: 0, longitude: 0);
  }
}

String currentWeekDayCompact() {
  DateTime currentDate = DateTime.now();
  return days[currentDate.day];
}

double calculateDistanceInKm(
    double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0; // Radius of the earth in km
  double dLat = radians(lat2 - lat1);
  double dLon = radians(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c; // Distance in km
  return distance;
}

final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

final expandedWeekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];
