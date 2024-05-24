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

List<double> defaultExerciseWeights = [2.5, 5, 7.5, 10, 12.5, 15, 17.5, 20, 25, 30, 35, 40];

List<int> defaultExerciseReps = [for (int i = 1; i <= 30; i++) i];
