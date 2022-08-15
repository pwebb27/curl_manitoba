import 'package:curl_manitoba/models/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';

class LoadedGames{
  late Map<String,List<Game>> loadedGames;
  

  addGames(Map<String, List<Game>> games){
    loadedGames.addAll(games);
  }
}