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

  GameResults.fromJson(Map<String, dynamic> jsonMap)
      : firstHammer = jsonMap['first_hammer'],
        total = jsonMap['total'].toString(),
        endScores = {
          for (MapEntry entry
              in (jsonMap['end_scores'] as List<dynamic>).asMap().entries)
            entry.key: entry.value['score']
        };

  static GameResults parseGameResults(http.Response response) =>
      GameResults.fromJson(json.decode(response.body));
}
