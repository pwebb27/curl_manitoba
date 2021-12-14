
import 'package:http/http.dart' as http;
import '../models/twitter_feed.dart';
import '../models/tweet.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

class TwitterFeedScreen extends StatefulWidget {
  @override
  TwitterFeedScreenState createState() {
    return TwitterFeedScreenState();
  }
}

class TwitterFeedScreenState extends State<TwitterFeedScreen> {
  TwitterFeed feed = TwitterFeed();
  void callTwitterAPI() async {
    String bearerToken =
        'AAAAAAAAAAAAAAAAAAAAANDnWgEAAAAAQ0%2BkRHKSb1CbJ0I1nJPhAlyBggU%3DqvnkZaPQjBQZ4DPAPDyArtDcTq2JTPkdYJoUqxTQLV921z3WuC';
    final response = await http.get(
        Uri.https("api.twitter.com", "2/users/92376817/tweets", {
          "max_results": "30",
          "tweet.fields": "created_at,attachments",
        }),
        headers: {
          "Authorization":
              'Bearer $bearerToken', 
          "Content-Type": "application/json"
        });

 
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> data = map["data"];

    
    for (Map<String, dynamic> tweet in data) {
      feed.addTweet(Tweet.fromJson(tweet));
    }
    for(Tweet tweet in feed.tweets){
      print(tweet.id);
    }

  }

  @override
  void initState() {
    super.initState();
    callTwitterAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Test'),
    );
  }
}
