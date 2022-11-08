import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

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

    timePassed = generateTimePassed(json['created_at']);

    text = json['retweeted_status']['full_text'];
    generateColoredText(
        json['retweeted_status']['entities']['hashtags'],
        json['retweeted_status']['entities']['user_mentions'],
        json['retweeted_status']['entities']['urls'],
        text);
    spans[0] = removeUserMentions(json, spans[0]);

    profilePicURL = json['retweeted_status']['user']['profile_image_url'];
    userName = json['retweeted_status']['user']['name'];
    if (json['retweeted_status']['entities']['media'] != null) {
      mediaURL = json['retweeted_status']['entities']['media'][0]['media_url'];
      spans[spans.length - 1] = removeMediaURL(json, spans[spans.length - 1]);
    }
  }

  generateTweet(Map<String, dynamic> json) {
    timePassed = generateTimePassed(json['created_at']);

    profilePicURL = json['user']['profile_image_url'];
    text = json['full_text'];
    generateColoredText(json['entities']['hashtags'],
        json['entities']['user_mentions'], json['entities']['urls'], text);

    if (json['entities']['media'] != null) {
      mediaURL = json['entities']['media'][0]['media_url'];
    }
  }

  String generateTimePassed(String timestamp) {
    DateTime timeNow = DateTime.now().toUtc();
    timeNow = DateTime.parse(timeNow.toString().substring(0, 19));

    DateTime timeOfTweet = DateTime.parse(convertToDateTimeFormat(timestamp));
    timeOfTweet = DateTime.parse(timeOfTweet.toString().substring(0, 19));

    final difference = timeNow.difference(timeOfTweet);

    return timeago.format(DateTime.now().subtract(difference));
  }

  TextSpan removeMediaURL(Map<String, dynamic> json, TextSpan span) {
    String mediaURL = json['retweeted_status']['entities']['media'][0]['url'];
    String spanText = span.text as String;

    spanText = spanText.replaceAll(
        " " + mediaURL.substring(0, mediaURL.length - 1), "");
    return TextSpan(text: spanText, style: TextStyle(color: Colors.black));
  }

  TextSpan removeUserMentions(Map<String, dynamic> json, TextSpan span) {
    String usermentions = "";
    String spanText = span.text as String;
    for (Map<String, dynamic> usermention in json['retweeted_status']
        ['entities']['user_mentions']) {
      usermentions = usermentions + '@' + usermention['screen_name'] + " ";
    }
    spanText = spanText.replaceAll(usermentions, "");
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

  generateColoredText(
      List hashtags, List usermentions, List urls, String text) {
    List<int> indices = [];
    if (hashtags != null) {
      for (var hashtag in hashtags) {
        indices.add(hashtag['indices'][0]);
        indices.add(hashtag['indices'][1]);
      }
      if (usermentions != null) {
        for (var usermention in usermentions) {
          indices.add(usermention['indices'][0]);
          indices.add(usermention['indices'][1]);
        }
      }
      if (urls != null) {
        for (var url in urls) {
          indices.add(url['indices'][0]);
          indices.add(url['indices'][1]);
        }
      }
      indices.sort((a, b) => a.compareTo(b));
      final TextStyle normalStyle =
          TextStyle(color: Colors.black, fontSize: 16);
      final TextStyle hypertextStyle =
          TextStyle(color: Colors.blue, fontSize: 16);

      if (indices.length == 0)
        spans.add(TextSpan(text: text, style: normalStyle));
      else {
        spans.add(
            TextSpan(text: text.substring(0, indices[0]), style: normalStyle));

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
                text: text.substring(indices[i], text.length),
                style: normalStyle));
            break;
          }
        } while (true);
      }
    }
  }

  static List<Tweet> parseTweetData(http.Response response) {
    List<dynamic> jsonTweets = json.decode(response.body);
    return [
      for (Map<String, dynamic> jsonTweet in jsonTweets)
        Tweet.fromJson(jsonTweet)
    ];
  }
}
