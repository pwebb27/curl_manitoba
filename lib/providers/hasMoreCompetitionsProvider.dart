import 'package:flutter/material.dart';

class HasMoreCompetitionsProvider extends ChangeNotifier {
  bool _hasMoreCompetitions = true;

  bool get hasMoreCompetitions => _hasMoreCompetitions;

  set hasMoreCompetitions(bool hasMoreCompetitions) {
    _hasMoreCompetitions = hasMoreCompetitions;
    notifyListeners();
  }
}
