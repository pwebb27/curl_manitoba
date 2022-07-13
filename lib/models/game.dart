import 'package:curl_manitoba/models/game_results.dart';
import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/models/teams.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Game {
  late scoresCompetition competition;
  late String drawNumber;
  late DateTime startTime;
  late String sheet;
  late GameResults team1Results;
  late GameResults team2Results;

  Game.fromJson(Map<String, dynamic> json, this.competition) {
    drawNumber = json['draw']['label'];
    startTime = DateTime.parse(json['draw']['starts_at']);
    sheet = json['draw']['sheet_number'].toString();

    team1Results = GameResults(
      json['game_positions'][0]['competition_team_id'].toString(),
      json['game_positions'][0]['id'].toString(),
      competition.id
    );
    team2Results = GameResults(
      json['game_positions'][1]['competition_team_id'].toString(),
      json['game_positions'][1]['id'].toString(),
      competition.id
    );
  }


  static Future<List<dynamic>> getGamesData(String id) async {
    final gamesUrl =
        'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions/$id/games';
    var response = await http.get(Uri.parse(gamesUrl));
    return json.decode(response.body);
  }

  static List<Game> parseGamesData(
      List<dynamic> gamesData, scoresCompetition competition) {
    List<Game> games = [];
    for (var game in gamesData)
      games.add(Game.fromJson(game, competition));
    return games;
  }
}
