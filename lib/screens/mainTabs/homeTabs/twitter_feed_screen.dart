import 'package:curl_manitoba/widgets/tweet_item.dart';
import '../../../models/twitter_feed.dart';
import '../../../models/tweet.dart';
import '../../../models/twitter_api.dart';
import '../../../widgets/circular_progress_bar.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

class TwitterFeedScreen extends StatefulWidget {
  @override
  TwitterFeedScreenState createState() {
    return TwitterFeedScreenState();
  }
}

class TwitterFeedScreenState extends State<TwitterFeedScreen> {
  List<dynamic>? data;
  TwitterFeed feed = TwitterFeed();
  TwitterAPI api = TwitterAPI();

  Future<List<dynamic>> _getAPIData() async {
    var response = await api.callTwitterAPI("1.1/statuses/user_timeline.json",
        {"user_id": "92376817", "count": "15", "tweet_mode": "extended"});
    return json.decode(response);
  }

  void buildContent(List<dynamic> map) {
    for (var element in map) {
      feed.addTweet(Tweet.fromJson(element));
    }
  }

  @override
  void initState() {
    super.initState();
    _getAPIData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getAPIData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SliverFillRemaining(
                child: Center(child: CircularProgressBar()));
          buildContent(snapshot.data as List<dynamic>);
          return CustomScrollView(slivers: [
                        
                        SliverList(
                          delegate:
                              SliverChildBuilderDelegate(((context, index) {
                            return TweetItem(feed.tweets[index]);
                          }), childCount: feed.tweets.length),
                        )
                      ]);
        });
  }
}


