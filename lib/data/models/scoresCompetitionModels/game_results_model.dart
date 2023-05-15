import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game_results.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResultsModel extends GameResults {
  GameResultsModel({
    required id,
    required teamId,
    required competitionId,
  }) : super(competitionId: competitionId, teamId: teamId, id: id);

  factory GameResultsModel.fromJson(
      Map<String, dynamic> jsonGamePositions, competitionId) {
    return GameResultsModel(
        teamId: '${jsonGamePositions['competition_team_id']}',
        id: '${jsonGamePositions['id']}',
        competitionId: competitionId);
  }
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
