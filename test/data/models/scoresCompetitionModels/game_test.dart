import 'dart:convert';

import 'package:curl_manitoba/data/models/scoresCompetitionModels/game_model.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:test/test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final gameModel = GameModel(
      drawNumber: '1',
      startTime: DateTime.now(),
      sheet: '1',
      gameResultsbyTeamMap: Map(),
      competition: scoresCompetition());
  ;
  test(
    'should be a subclass of GameModel entity',
    () async {
      // assert
      expect(gameModel, isA<Game>());
    },
  );

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // arrange
        final scoresCompetition competition = scoresCompetition();
        final Map<String, dynamic> jsonString =
            json.decode(fixture('games.json'));
        // act
        final result = GameModel.fromJson(jsonString, competition);
        // assert
      },
    );
  });
}
