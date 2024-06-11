import 'package:flutter/material.dart';

class ApiDataLoadedProvider extends ChangeNotifier {
  bool isApiDataLoaded = false;

  void changeApiDataLoaded(bool verdict) {
    isApiDataLoaded = verdict;
    notifyListeners();
  }
}
