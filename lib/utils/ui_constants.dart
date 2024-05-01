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
  return getScreenHeight(context) - getStatusBarHeight(context) - getHeaderHeight(context) ;
}
