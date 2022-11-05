import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResults {
   String? id;
   String? teamId;
   String? competitionId;
   Map<String, String>? endScores;
   bool? firstHammer;
   String? total;

  GameResults(this.teamId, this.id, this.competitionId);

  GameResults.fromJson(Map<String, dynamic> jsonGameResults)
      : firstHammer = jsonGameResults['first_hammer'],
        total = jsonGameResults['total'].toString(),
        endScores = {
          for (MapEntry entry
              in (jsonGameResults['end_scores'] as List<dynamic>).asMap().entries)
            entry.key: entry.value['score']
        };

  static GameResults parseGameResults(http.Response response) =>
      GameResults.fromJson(json.decode(response.body));
}
