import 'package:curl_manitoba/widgets/tweet_item.dart';
import '../../../models/tweet.dart';
import '../../../models/apis/twitter_api.dart';
import '../../../widgets/circular_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TwitterFeedScreen extends StatefulWidget {
  @override
  TwitterFeedScreenState createState() => TwitterFeedScreenState();
}

class TwitterFeedScreenState extends State<TwitterFeedScreen> {
  late TwitterApi _twitterApi;
  late Future _twitterApiDataFuture;
  late List<Tweet> _tweets;

  @override
  void initState() {
    super.initState();
    _tweets = [];
    _twitterApi = TwitterApi();
    _twitterApiDataFuture = _twitterApi.fetchTweets();
  }

  @override
  Widget build(BuildContext context) =>
     FutureBuilder(
        future: _twitterApiDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SliverFillRemaining(
                child: Center(child: CircularProgressBar()));
          _tweets = Tweet.parseTweetData(snapshot.data as http.Response);
          return CustomScrollView(slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  ((_, index) => TweetItem(_tweets[index])),
                  childCount: _tweets.length),
            )
          ]);
        });
  }
