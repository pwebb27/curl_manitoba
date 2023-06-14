import 'package:curl_manitoba/core/error/failures.dart';
import 'package:curl_manitoba/core/useCases/use_case.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/format.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/data/repositories/curling_io_repository.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetScoresCompetitions
    implements UseCase<List<scoresCompetition>, GetScoresCompetitionParams> {
  CurlingIORepository curlingIORepository;

  GetScoresCompetitions(this.curlingIORepository);

  Future<Either<Failure, List<scoresCompetition>>> call(
          GetScoresCompetitionParams params) async =>
      await curlingIORepository.getCompetitions(params.tag, params.pageNumber);
}

class GetScoresCompetitionParams extends Equatable {
  final String tag;
  final String pageNumber;
  List<Object> get props => [tag, pageNumber];
  GetScoresCompetitionParams({required this.tag, required this.pageNumber});
}

class GetGameResults
    implements UseCase<List<GameResults>, GetGameResultsParams> {
  CurlingIORepository curlingIORepository;

  GetGameResults(this.curlingIORepository);
  Future<Either<Failure, List<GameResults>>> call(
          GetGameResultsParams params) async =>
      await curlingIORepository.getGameResults(
          params.competitionID, params.teamID, params.gamePositionsID);
}

class GetGameResultsParams extends Equatable {
  final String competitionID;
  final String teamID;
  final String gamePositionsID;

  List<Object> get props => [competitionID, teamID, gamePositionsID];
  GetGameResultsParams(
      {required this.competitionID,
      required this.teamID,
      required this.gamePositionsID});
}

class GetTeams implements UseCase<List<Team>, GetTeamsParams> {
  CurlingIORepository curlingIORepository;

  GetTeams(this.curlingIORepository);

  Future<Either<Failure, List<Team>>> call(GetTeamsParams params) async {
    return curlingIORepository.getTeams(params.competitionID);
  }
}

class GetTeamsParams extends Equatable {
  final String competitionID;
  List<Object> get props => [competitionID];
  GetTeamsParams({required this.competitionID});
}

class GetFormats implements UseCase<List<Format>, GetFormatsParams> {
  CurlingIORepository curlingIORepository;

  GetFormats(this.curlingIORepository);

  Future<Either<Failure, List<Format>>> call(GetFormatsParams params) async =>
      await curlingIORepository.getFormat(params.competitionID);
}

class GetFormatsParams extends Equatable {
  final String competitionID;
  List<Object> get props => [competitionID];
  GetFormatsParams({required this.competitionID});
}

class GetGames implements UseCase<List<Game>, GetTeamsParams> {
  CurlingIORepository curlingIORepository;

  GetGames(this.curlingIORepository);

  Future<Either<Failure, List<Game>>> call(GetTeamsParams) async =>
      await curlingIORepository.getGames(GetTeamsParams.competitionID);
}

class GetGamesParams extends Equatable {
  final String competitionID;
  List<Object> get props => [competitionID];
  GetGamesParams({required this.competitionID});
}
