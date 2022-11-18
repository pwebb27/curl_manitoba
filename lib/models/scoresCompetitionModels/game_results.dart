import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResults {
  String? id;
  String? teamId;
  String? competitionId;
  Map<int, int>? endScores;
  bool? firstHammer;
  String? total;

  GameResults.fromJson({
      required Map<String, dynamic> jsonGamePositions, required this.competitionId})
      : teamId = '${jsonGamePositions['competition_team_id']}',
        id = '${jsonGamePositions['id']}';

  addVariablesFromGamesResultsResponse(http.Response response) {
    Map<String, dynamic> jsonGameResults = json.decode(response.body);
    firstHammer = jsonGameResults['first_hammer'];
    total = '${jsonGameResults['total']}';
    endScores = {
      for (MapEntry entry
          in (jsonGameResults['end_scores'] as List<dynamic>).asMap().entries)
        entry.key: entry.value['score']
    };
  }
}
