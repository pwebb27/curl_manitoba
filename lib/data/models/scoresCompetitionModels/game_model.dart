import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';

class GameModel extends Game {
  GameModel(
      {required String drawNumber,
      required DateTime startTime,
      required String sheet,
      required Map<Team, GameResults> gameResultsbyTeamMap,
      required scoresCompetition competition})
      : super(
            drawNumber: drawNumber,
            startTime: startTime,
            sheet: sheet,
            gameResultsbyTeamMap: gameResultsbyTeamMap,
            competition: competition);

  factory GameModel.fromJson(Map<String, dynamic> jsonGame, competition) {
    return GameModel(
        drawNumber: jsonGame['draw']['label'],
        startTime: _getStartTime(jsonGame['draw']['starts_at']),
        sheet: '${jsonGame['draw']['sheet_number']}',
        gameResultsbyTeamMap: {
          Team('${jsonGame['game_positions'][0]['competition_team_id']}'):
              GameResults.fromJson(
                  jsonGamePositions: jsonGame['game_positions'][0],
                  competitionId: competition!.id),
          Team('${jsonGame['game_positions'][1]['competition_team_id']}'):
              GameResults.fromJson(
                  jsonGamePositions: jsonGame['game_positions'][1],
                  competitionId: competition!.id)
        },
        competition: competition);
  }

  static dynamic _getStartTime(String startTime) {
    try {
      return DateTime.parse(startTime);
    } catch (e) {
      //Startime will be a 'TBA' string if not a date instance from API
      return startTime;
    }
  }
}
