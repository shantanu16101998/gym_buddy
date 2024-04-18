import 'package:flutter/material.dart';

double getScreenWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getStatusBarHeight(context) {
  return MediaQuery.of(context).viewPadding.top;
}