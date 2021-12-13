import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js.dart' as js;
import 'package:universal_ui/universal_ui.dart' as ui;
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:http/http.dart' as http;
import '../models/TwitterFeed.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

class TwitterFeedScreen extends StatefulWidget {
  @override
  TwitterFeedScreenState createState() {
    return TwitterFeedScreenState();
  }
}

class TwitterFeedScreenState extends State<TwitterFeedScreen> {
            void callTwitterAPI() async {
    String bearerToken =
        'AAAAAAAAAAAAAAAAAAAAANDnWgEAAAAAQ0%2BkRHKSb1CbJ0I1nJPhAlyBggU%3DqvnkZaPQjBQZ4DPAPDyArtDcTq2JTPkdYJoUqxTQLV921z3WuC';
    final response = await http.get(
        new Uri.https("api.twitter.com", "2/users/92376817/tweets", {
          "max_results": "30",
        }),
        headers: {
          "Authorization":
              'Bearer ${bearerToken}', //twitter.token is the token recieved from Twitter sign in process
          "Content-Type": "application/json"
        });
    var tweets = json.decode(response.body);
    print(tweets);
      }

 


  @override
  void initState() {
    super.initState();
    callTwitterAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('hello'),);
  }
}
