import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Game {
  late scoresCompetition competition;
  late String drawNumber;
  late DateTime startTime;
  late String sheet;
  late Map<Team, GameResults> resultsMap;

  Game.fromJson(Map<String, dynamic> json, this.competition) {
    drawNumber = json['draw']['label'];
    startTime = DateTime.parse(json['draw']['starts_at']);
    sheet = json['draw']['sheet_number'].toString();

    resultsMap = {
      Team(json['game_positions'][0]['competition_team_id'].toString()):
          GameResults(
              json['game_positions'][0]['competition_team_id'].toString(),
              json['game_positions'][0]['id'].toString(),
              competition.id),
      Team(json['game_positions'][1]['competition_team_id'].toString()):
          GameResults(
              json['game_positions'][1]['competition_team_id'].toString(),
              json['game_positions'][1]['id'].toString(),
              competition.id)
    };
  }

  static List<Game> parseGamesData(
      http.Response gamesResponse, scoresCompetition competition) {
    List<dynamic> jsonList = json.decode(gamesResponse.body);

    List<Game> games = [];
    for (var game in jsonList) games.add(Game.fromJson(game, competition));
    return games;
  }
}
