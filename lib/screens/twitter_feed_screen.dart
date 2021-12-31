import 'package:curl_manitoba/widgets/tweet_item.dart';
import 'package:http/http.dart' as http;
import '../models/twitter_feed.dart';
import '../models/tweet.dart';
import '../models/twitter_api.dart';

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
  void getAPIData() async {
    var response = await api.callTwitterAPI("1.1/statuses/user_timeline.json", {
      "user_id": "92376817",
      "count": "30",
    });
    Map<String, dynamic> map = json.decode(response);
    data = map["data"];
    data?.forEach((element) {
      feed.addTweet(Tweet.fromJson(element));
    });
  }

  @override
  void initState() {
    super.initState();
    getAPIData();
  }

  @override
  Widget build(BuildContext context) {
    for (Tweet tweet in feed.tweets) {
      print(tweet.attachments);
    }

    return ListView.builder(
        itemBuilder: (ctx, index) {
          return TweetItem(
            id: feed.tweets[index].id,
            creationTime: feed.tweets[index].createdAt,
            attachments: feed.tweets[index].attachments,
          );
        },
        itemCount: feed.tweets.length);
  }
}
