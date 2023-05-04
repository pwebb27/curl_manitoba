import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game.dart';

class Draw {
  final String drawNumber;
  final DateTime startTime;
  final List<Game> games;

  Draw(this.drawNumber, this.startTime) : games = [];

  addGame(Game game) {
    games.add(game);
  }

  static List<Draw> getDrawsFromGames(List<Game> games) {
    Draw tempDraw = Draw(games[0].drawNumber!, games[0].startTime!);
    List<Draw> draws = [];

    for (Game game in games)
      game.drawNumber == tempDraw.drawNumber
      //Keep adding games while draw number is the same
          ? tempDraw.addGame(game)
          //Othwerwise add complete draw to draws
          : {
              draws.add(tempDraw),
              tempDraw = Draw(game.drawNumber!, game.startTime!)
            };

    return draws;
  }
}
