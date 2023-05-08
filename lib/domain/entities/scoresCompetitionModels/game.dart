import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';

class Game {
  final scoresCompetition? competition;
  final String? drawNumber;
  var startTime;
  final String? sheet;
  final Map<Team, GameResults>? gameResultsbyTeamMap;

  Game(
      {required this.drawNumber,
      required this.startTime,
      required this.sheet,
      required this.gameResultsbyTeamMap,
      required this.competition});
}
