import 'package:curl_manitoba/models/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Game {
  final scoresCompetition? competition;
  final String? drawNumber;
  var startTime;
  final String? sheet;
  final Map<Team, GameResults>? gameResultsbyTeamMap;

  Game.fromJson(Map<String, dynamic> jsonGame, this.competition)
      : drawNumber = jsonGame['draw']['label'],
        startTime = _getStartTime(jsonGame['draw']['starts_at']),
        sheet = '${jsonGame['draw']['sheet_number']}',
        gameResultsbyTeamMap = {
          Team('${jsonGame['game_positions'][0]['competition_team_id']}'):
              GameResults.fromJson(
                  jsonGamePositions: jsonGame['game_positions'][0],
                  competitionId: competition!.id),
          Team('${jsonGame['game_positions'][1]['competition_team_id']}'):
              GameResults.fromJson(
                  jsonGamePositions: jsonGame['game_positions'][1],
                  competitionId: competition!.id)
        };

  static dynamic _getStartTime(String startTime) {
    try {
      return DateTime.parse(startTime);
    } catch (e) {
      //Startime will be a 'TBA' string if not a date instance from API
      return startTime;
    }
  }

  static List<Game> parseGamesData(
      http.Response gamesResponse, scoresCompetition competition) {
    List<dynamic> jsonGames = json.decode(gamesResponse.body);

    return [
      for (var jsonGame in jsonGames) (Game.fromJson(jsonGame, competition))
    ];
  }
}
