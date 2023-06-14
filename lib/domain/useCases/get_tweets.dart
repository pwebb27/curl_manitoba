import 'package:curl_manitoba/core/useCases/use_case.dart';
import 'package:curl_manitoba/domain/entities/tweet.dart';
import 'package:curl_manitoba/data/repositories/twitter_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:curl_manitoba/core/error/failures.dart';

class GetTweets implements UseCase<List<Tweet>> {
  final TwitterRepository repository;

  GetTweets(this.repository);

  Future<Either<Failure, List<Tweet>>> call() async {
    return await repository.getTweets();
  }
}
