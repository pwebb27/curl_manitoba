import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/data/repositories/curling_io_repository.dart';
import 'package:curl_manitoba/domain/useCases/curling_io_repository_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockCurlingIORepository extends Mock implements CurlingIORepository {
  void main() {
    late final MockCurlingIORepository mockCurlingIORepository;
    late final GetScoresCompetitions usecase;

    setUp(() {
      mockCurlingIORepository = MockCurlingIORepository();
      usecase = GetScoresCompetitions(mockCurlingIORepository);
    });

    final List<scoresCompetition> scoresCompetitions = [];

    test(
      'should get scores from CurlingIORepository',
      () async {
        // arrange
        when(mockCurlingIORepository.getCompetitions())
            .thenAnswer((_) async => Right(scoresCompetitions));
        // act
        final result = await usecase();
        // assert
        expect(result, Right(scoresCompetition));
        verify(mockCurlingIORepository.getCompetitions());
        verifyNoMoreInteractions(mockCurlingIORepository);
      },
    );
  }
}
