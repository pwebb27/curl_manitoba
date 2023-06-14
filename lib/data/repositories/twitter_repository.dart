import 'dart:convert';

import 'package:curl_manitoba/apis/twitter_api.dart';
import 'package:curl_manitoba/core/error/exceptions.dart';
import 'package:curl_manitoba/core/error/failures.dart';
import 'package:curl_manitoba/domain/entities/tweet.dart';
import 'package:dartz/dartz.dart';

abstract class TwitterRepository {
  Future<Either<Failure, List<Tweet>>> getTweets();
}

class TwitterRepositoryImp implements TwitterRepository {
  TwitterApi twitterApi;
  TwitterRepositoryImp() : twitterApi = TwitterApi();

  Future<Either<Failure, List<Tweet>>> getTweets() async {
    try {
      final response = await twitterApi.fetchTweets();

      List<dynamic> jsonTweets = json.decode(response.body);
      return Right([
        for (Map<String, dynamic> jsonTweet in jsonTweets)
          Tweet.fromJson(jsonTweet)
      ]);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
