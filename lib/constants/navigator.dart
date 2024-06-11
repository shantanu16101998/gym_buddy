import 'package:flutter/material.dart';

void navigateBackToRouteOrPush(BuildContext context, String routeName, Widget newRoute) {
  bool routeExists = false;

  Navigator.popUntil(context, (route) {
    if (route.settings.name == routeName) {
      routeExists = true;
    }
    return route.settings.name == routeName;
  });

  if (!routeExists) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newRoute),
    );
  }
}
