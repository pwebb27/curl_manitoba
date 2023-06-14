import 'package:curl_manitoba/domain/entities/tweet.dart';
import 'package:curl_manitoba/data/repositories/twitter_repository.dart';
import 'package:curl_manitoba/domain/useCases/get_tweets.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTwitterRepository extends Mock implements TwitterRepository {
  void main() {
    late MockTwitterRepository mockTwitterRepository;
    late GetTweets usecase;

    setUp(() {
      mockTwitterRepository = MockTwitterRepository();
      usecase = GetTweets(mockTwitterRepository);
    }); 

    final List<Tweet> tweets = [Tweet(),Tweet(),Tweet()];

    test(
      'should get list of tweets from TwitterRepository',
      () async {
        // arrange
        when(mockTwitterRepository.getTweets())
            .thenAnswer((_) async => Right(tweets));
        // act
        final result = usecase();
        // assert
        expect(result, Right(tweets));
        verify(mockTwitterRepository.getTweets());
        verifyNoMoreInteractions(mockTwitterRepository);
      },
    );
  }
}
