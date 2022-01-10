import 'dart:ffi';
import 'package:get_time_ago/get_time_ago.dart';

import 'package:flutter/cupertino.dart';

class Tweet {
  String? createdAt;
  String? text;
  String? mediaUrl;

  Tweet.fromJson(Map<String, dynamic> json) {
    createdAt = GetTimeAgo.parse(
        DateTime.parse(convertToDateTimeFormat(json['created_at'])));
    if (json['retweeted_status'] != null) {
      text = shortenRetweetText(json);
      
    } else {
      text = json['full_text'];
    }
    if (json['entities']['media'] != null) {
      mediaUrl = json['entities']['media'][0]['media_url'];
    }
  }

  String shortenRetweetText(Map<String,dynamic> json) {
    String usermentions = "";
      for (Map<String,dynamic> usermention in json['retweeted_status']['entities']
          ['user_mentions']) {
        usermentions = usermentions + '@' + usermention['screen_name'] + " ";
      }
      return json['retweeted_status']['full_text'].replaceAll(usermentions, "");
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
}
