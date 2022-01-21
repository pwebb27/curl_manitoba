import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'package:flutter/cupertino.dart';

class Tweet {
  late String profilePicURL;
  late String timePassed;
  late String text;
  String mediaURL = "";
  String userName = 'Curl Manitoba';
  bool retweet = false;
  List<TextSpan> spans = [];

  Tweet.fromJson(Map<String, dynamic> json) {
    (json['retweeted_status'] != null)
        ? generateRetweet(json)
        : generateTweet(json);
  }

  generateRetweet(Map<String, dynamic> json) {
    retweet = true;
    timePassed = GetTimeAgo.parse(DateTime.parse(
        convertToDateTimeFormat(json['retweeted_status']['created_at'])));
    text = json['retweeted_status']['full_text'];
    generateColoredText(json, text);
    spans[0] = removeUserMentions(json, spans[0]);

    profilePicURL = json['retweeted_status']['user']['profile_image_url'];
    userName = json['retweeted_status']['user']['name'];
    if (json['retweeted_status']['entities']['media'] != null) {
      mediaURL = json['retweeted_status']['entities']['media'][0]['media_url'];
    }
  }

  generateTweet(Map<String, dynamic> json) {
    timePassed = GetTimeAgo.parse(
        DateTime.parse(convertToDateTimeFormat(json['created_at'])));
    profilePicURL = json['user']['profile_image_url'];
    text = json['full_text'];
    if (json['entities']['media'] != null) {
      mediaURL = json['entities']['media'][0]['media_url'];
    }
  }

  TextSpan removeUserMentions(Map<String, dynamic> json, TextSpan span) {
    String usermentions = "";
    String spanText = span.text as String;
    for (Map<String, dynamic> usermention in json['retweeted_status']
        ['entities']['user_mentions']) {
      usermentions = usermentions + '@' + usermention['screen_name'] + " ";
    }
    text.replaceAll(usermentions, "");
    return TextSpan(text: spanText, style: TextStyle(color: Colors.black));
  }

  String convertToDateTimeFormat(String timestamp) {
    String year = timestamp.substring(26, 30);
    String month = timestamp.substring(4, 7);
    switch (month) {
      case 'Jan':
        month = '01';
        break;
      case 'Feb':
        month = '02';
        break;
      case 'Mar':
        month = '03';
        break;
      case 'Apr':
        month = '04';
        break;
      case 'May':
        month = '05';
        break;
      case 'Jun':
        month = '06';
        break;
      case 'Jul':
        month = '07';
        break;
      case 'Aug':
        month = '08';
        break;
      case 'Sep':
        month = '09';
        break;
      case 'Oct':
        month = '10';
        break;
      case 'Nov':
        month = '11';
        break;
      case 'Dec':
        month = '12';
    }
    String day = timestamp.substring(8, 10);
    if (day.length == 1) {
      day = '0' + day;
    }
    String hours = timestamp.substring(11, 13);
    String minutes = timestamp.substring(14, 16);
    String seconds = timestamp.substring(17, 19);

    return year + month + day + 'T' + hours + minutes + seconds;
  }

  generateColoredText(Map<String, dynamic> json, String text) {
    List<int> indices = [];
    if (json['retweeted_status']['entities']['hashtags'] != null)
      for (var hashtag in json['retweeted_status']['entities']['hashtags']) {
        indices.add(hashtag['indices'][0]);
        indices.add(hashtag['indices'][1]);
      }
    final TextStyle normalStyle = TextStyle(color: Colors.black);
    final TextStyle hypertextStyle = TextStyle(color: Colors.blue);

    spans
        .add(TextSpan(text: text.substring(0, indices[0]), style: normalStyle));
    int i = 0;

    do {
      spans.add(TextSpan(
          text: text.substring(indices[i], indices[++i]),
          style: hypertextStyle));
      if (i != indices.length - 1) {
        spans.add(TextSpan(
            text: text.substring(indices[i], indices[++i]),
            style: normalStyle));
      } else {
        spans.add(TextSpan(
            text: text.substring(indices[i], text.length - 1),
            style: normalStyle));
        break;
      }
    } while (true);
  }
}
