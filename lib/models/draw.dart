import 'package:curl_manitoba/models/game.dart';

class Draw {
  String drawNumber;
  DateTime startTime;
  late List<Game> games;

  Draw(this.drawNumber, this.startTime) {
    games = [];
  }

  addGame(Game game) {
    games.add(game);
  }

  static List<Draw> createDraws(List<Game> games) {
    List<Draw> draws = [];
    
    Draw tempDraw = Draw(games[0].drawNumber, games[0].startTime);

    for (Game game in games) {
      if (game.drawNumber != tempDraw.drawNumber) {
        draws.add(tempDraw);
        tempDraw = Draw(game.drawNumber, game.startTime);
      } else
        tempDraw.addGame(game);
    }
    return draws;
  }
}
