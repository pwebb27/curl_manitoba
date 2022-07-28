import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResults {
  late String id;
  late String teamId;
  late String competitionId;
  Map<String, String>? endScores;
  bool? firstHammer;
  String? total;

  GameResults(this.teamId, this.id, this.competitionId);

  GameResults.fromJson(Map<String, dynamic> jsonMap) {
    firstHammer = jsonMap['first_hammer'];
    total = jsonMap['total'].toString();
    endScores = {};

    List<dynamic> endScoreData = jsonMap['end_scores'];
    endScoreData.asMap().forEach((index, end) {
      endScores![index.toString()] = end['score'].toString();
    });
  }

  static GameResults parseGameResults(http.Response response) {
    Map<String, dynamic> jsonMap = json.decode(response.body);
    return GameResults.fromJson(jsonMap);
  }
}
