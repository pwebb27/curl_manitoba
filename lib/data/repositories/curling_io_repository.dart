import 'dart:convert';
import 'package:curl_manitoba/apis/api_base_helper.dart';
import 'package:curl_manitoba/apis/curling_io_api.dart';
import 'package:curl_manitoba/core/error/exceptions.dart';
import 'package:curl_manitoba/core/error/failures.dart';
import 'package:curl_manitoba/core/network/network_info.dart';
import 'package:curl_manitoba/data/models/scoresCompetitionModels/format_model.dart';
import 'package:curl_manitoba/data/models/scoresCompetitionModels/game_model.dart';
import 'package:curl_manitoba/data/models/scoresCompetitionModels/scores_competition_model.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/format.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';
import 'package:dartz/dartz.dart';

abstract class CurlingIORepository {
  Future<Either<Failure, List<scoresCompetition>>> getCompetitions(
      [String tag = '', String pageNumber = '1']);

  Future<Either<Failure, List<Game>>> getGames(String competitionID);

  Future<Either<Failure, List<Team>>> getTeams(String competitionID);

  Future<Either<Failure, List<Format>>> getFormat(String competitionID);

  Future<Either<Failure, List<GameResults>>> getGameResults(
      String competitionID, String teamID, String gamePositionsID);
}

class CurlingIORepositoryImp implements CurlingIORepository {
  late final CurlingIOApi curlingIOApi;
  final NetworkInfo networkInfo;
  final ApiBaseHelper apiBaseHelper;

  CurlingIORepositoryImp(
      {required this.networkInfo,
      required this.curlingIOApi,
      required this.apiBaseHelper}) {}

  Future<Either<Failure, List<Game>>> getGames(String competitionID) async {
    return await _getCurlingIOData(() async {
      final response = await curlingIOApi.fetchGames(competitionID);
      List<dynamic> jsonGames = json.decode(response.body);
      [
        for (var jsonGame in jsonGames)
          (GameModel.fromJson(jsonGame, competition))
      ];
    }) as Future<Either<Failure, List<Game>>>;
  }

  Future<Either<Failure, List<Team>>> getTeams(String competitionID) async {
    return await _getCurlingIOData(() async {
      final response = await curlingIOApi.fetchTeams(competitionID);
      List<dynamic> jsonGames = json.decode(response.body);
      Right([for (var jsonGame in jsonGames) (GameModel.fromJson(jsonGame))]);
    }) as Future<Either<Failure, List<Team>>>;
  }

  Future<Either<Failure, List<scoresCompetition>>> getCompetitions(
      [String tag = '', String pageNumber = '1']) async {
    return await _getCurlingIOData(() async {
      final response = await curlingIOApi.fetchCompetitions(tag, pageNumber);
      Map<String, dynamic> jsonMap = json.decode(response.body);
      List<dynamic> jsonCompetitions =
          jsonMap["paged_competitions"]["competitions"];
      return [
        for (Map<String, dynamic> jsonCompetition in jsonCompetitions)
          scoresCompetitionModel.fromJson(jsonCompetition)
      ];
    }) as Future<Either<Failure, List<scoresCompetition>>>;
  }

  Future<Either<Failure, List<Format>>> getFormat(String competitionID) async {
    return await _getCurlingIOData(() async {
      final response = await curlingIOApi.fetchFormat(competitionID);
      List<dynamic> jsonList = json.decode(response.body);

      List<Format> formats = [];
      for (Map<String, dynamic> jsonFormat in jsonList) {
        Format format = FormatModel.fromJson(jsonFormat);
        if (format.type != 'Bracket') formats.add(format);
      }
      return formats;
    }) as Future<Either<Failure, List<Format>>>;
  }

  Future<Either<Failure, List<GameResults>>> getGameResults(
      String competitionID, String teamID, String gamePositionsID) async {
    return await _getCurlingIOData(() async {
      final response = await curlingIOApi.fetchGameResults(
          competitionID, teamID, gamePositionsID);
      List<dynamic> jsonGames = json.decode(response.body);
      return [
        for (var jsonGame in jsonGames)
          (GameModel.fromJson(jsonGame, competition))
      ];
    }) as Future<Either<Failure, List<GameResults>>>;
  }

  Future<Either<Failure, dynamic>> _getCurlingIOData(
      Future<dynamic> Function() getAndParseData) async {
    if (await NetworkInfo.isConnected)
      try {
        final data = getAndParseData();
        return Right(data);
      } on ServerException {
        return Left(ServerFailure());
      }
  }
}
