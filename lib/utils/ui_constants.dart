import 'package:flutter/material.dart';

double getScreenWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getHeaderHeight(context) {
  return getScreenHeight(context) * 0.12;
}

double getScreenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getStatusBarHeight(context) {
  return MediaQuery.of(context).viewPadding.top;
}

double getEffectiveScreenHeight(context) {
  return getScreenHeight(context) -
      getStatusBarHeight(context) -
      getHeaderHeight(context);
}

Color formPrimaryColor = const Color.fromARGB(255, 85, 84, 84);

List<num> defaultExerciseWeights = [
  for (int i = 1; i < 1000; i++)
    i < 20
        ? (2.5 * i.toInt()) % 1 == 0
            ? (2.5 * i).toInt()
            : (2.5 * i.toInt())
        : 5 * i.toInt()
];

List<int> defaultExerciseReps = [for (int i = 1; i <= 30; i++) i];
