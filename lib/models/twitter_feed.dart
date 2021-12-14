import './tweet.dart';

class TwitterFeed{
  List<Tweet> tweets = [];

  TwitterFeed();

  addTweet(Tweet tweet){
    tweets.add(tweet);

  }
}