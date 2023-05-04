import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:flutter/material.dart';

class LoadedCompetitionsProvider extends ChangeNotifier {
  List<scoresCompetition> _loadedCompetitions = [];

  List<scoresCompetition> get loadedCompetitions => _loadedCompetitions;

  void addCompetitions(List<scoresCompetition> competitions){
    _loadedCompetitions.addAll(competitions);
  }

  set loadedCompetitions(List<scoresCompetition> loadedCompetitions) {
    _loadedCompetitions = loadedCompetitions;
    notifyListeners();
  }
}
