import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

class Tweet {
  String? profilePicURL;
  String? timeAgo;
  String? text;
  String? mediaURL = "";
  String? handle = 'Curl Manitoba';
  bool isRetweet = false;
  bool isQuoteTweet = false;
  List<TextSpan> spans = [];

  Tweet.fromJson(Map<String, dynamic> jsonTweet) {
    jsonTweet['retweeted_status'] != null
        ? Tweet.retweetFromJson(jsonTweet)
        : jsonTweet['quoted_status'] != null? Tweet.quoteTweetFromJson(jsonTweet)
        : {
            timeAgo = _dateTimeToTimePassed(jsonTweet['created_at']),
            profilePicURL = jsonTweet['user']['profile_image_url'],
            text = jsonTweet['full_text'],
            spans = _generateColoredText(jsonTweet['entities'], text!),
            if (jsonTweet['entities']['media'] != null)
              mediaURL = jsonTweet['entities']['media'][0]['media_url']
          };
  }

  Tweet.retweetFromJson(Map<String, dynamic> jsonRetweet) {
    isRetweet = true;

    timeAgo = _dateTimeToTimePassed(jsonRetweet['created_at']);

    text = jsonRetweet['retweeted_status']['full_text'];

    spans = _generateColoredText(
        jsonRetweet['retweeted_status']['entities'], text!);
    spans[0] = _removeUserMentions(jsonRetweet['retweeted_status'], spans[0]);

    profilePicURL =
        jsonRetweet['retweeted_status']['user']['profile_image_url'];
    handle = jsonRetweet['retweeted_status']['user']['name'];
    if (jsonRetweet['retweeted_status']['entities']['media'] != null) {
      mediaURL =
          jsonRetweet['retweeted_status']['entities']['media'][0]['media_url'];
      spans[spans.length - 1] =
          _removeMediaURL(jsonRetweet['retweeted_status'], spans[spans.length - 1]);
    }
  }

   Tweet.quoteTweetFromJson(Map<String, dynamic> jsonQuoteTweet) {
    isQuoteTweet = true;

    timeAgo = _dateTimeToTimePassed(jsonQuoteTweet['created_at']);

    text = jsonQuoteTweet['quoted_status']['full_text'];

    spans = _generateColoredText(
        jsonQuoteTweet['quoted_status']['entities'], text!);
    spans[0] = _removeUserMentions(jsonQuoteTweet['quoted_status'], spans[0]);

    profilePicURL =
        jsonQuoteTweet['quoted_status']['user']['profile_image_url'];
    handle = jsonQuoteTweet['quoted_status']['user']['name'];
    if (jsonQuoteTweet['quoted_status']['entities']['media'] != null) {
      mediaURL =
          jsonQuoteTweet['quoted_status']['entities']['media'][0]['media_url'];
      spans[spans.length - 1] =
          _removeMediaURL(jsonQuoteTweet['quoted_status'], spans[spans.length - 1]);
    }
  }

  static String _dateTimeToTimePassed(String createdAtString) {
    DateTime currentDateTime = DateTime.now().toUtc();
    //Remove seconds from currentDateTime
    currentDateTime =
        DateTime.parse(currentDateTime.toString().substring(0, 19));

    DateTime timeOfTweet =
        DateTime.parse(_createdAtToDateTimeFormat(createdAtString));
    timeOfTweet = DateTime.parse(timeOfTweet.toString().substring(0, 19));

    final difference = currentDateTime.difference(timeOfTweet);

    return timeago.format(DateTime.now().subtract(difference));
  }

  static TextSpan _removeMediaURL(Map<String, dynamic> json, TextSpan span) {
    String mediaURL = json['entities']['media'][0]['url'];
    String spanText = span.text as String;

    spanText = spanText.replaceAll(
        " " + mediaURL.substring(0, mediaURL.length - 1), "");
    return TextSpan(text: spanText, style: TextStyle(color: Colors.black));
  }

  static TextSpan _removeUserMentions(
      Map<String, dynamic> json, TextSpan span) {
    String usermentions = "";
    String spanText = span.text as String;
    for (Map<String, dynamic> usermention in json
        ['entities']['user_mentions']) {
      usermentions = usermentions + '@' + usermention['screen_name'] + " ";
    }
    spanText = spanText.replaceAll(usermentions, "");
    return TextSpan(text: spanText, style: TextStyle(color: Colors.black));
  }

  static String _createdAtToDateTimeFormat(String timestamp) {
    final String year = timestamp.substring(26, 30);
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
    if (day.length == 1) day = '0' + day;

    String hours = timestamp.substring(11, 13);
    String minutes = timestamp.substring(14, 16);
    String seconds = timestamp.substring(17, 19);

    return year + month + day + 'T' + hours + minutes + seconds;
  }

  static _generateColoredText(Map<String, dynamic> entitiesMap, String text) {
    List hashtags = entitiesMap['hashtags'];
    List usermentions = entitiesMap['user_mentions'];
    List urls = entitiesMap['urls'];

    List<TextSpan> spans = [];

    List<int> indices = [];
    if (hashtags != null) {
      for (var hashtag in hashtags) {
        indices
          ..add(hashtag['indices'][0])
          ..add(hashtag['indices'][1]);
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
    return spans;
  }

  static List<Tweet> parseTweetData(http.Response tweetsResponse) {
    List<dynamic> jsonTweets = json.decode(tweetsResponse.body);
    return [
      for (Map<String, dynamic> jsonTweet in jsonTweets)
        Tweet.fromJson(jsonTweet)
    ];
  }
}
