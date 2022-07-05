import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/models/teams.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResults {
  late String id;
  late String teamId;
  late String competitionId;
  Map<String, String>? endScores;
  bool? firstHammer;

  GameResults(this.teamId, this.id, this.competitionId);

  Future<Map<String, dynamic>> fetchGameResults() async {
    final gamesUrl =
        'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions/${competitionId}/teams/${teamId}/game_positions/${id}';
    var response = await http.get(Uri.parse(gamesUrl));
    return parseGameResults(json.decode(response.body));
  }

  parseGameResults(Map<String, dynamic> resultsData) {
    List<dynamic> endScoreData = resultsData['end_scores'];
    endScoreData.asMap().forEach((index, end) {
      endScores![index.toString()] = end['score'];
    });
  }
}
