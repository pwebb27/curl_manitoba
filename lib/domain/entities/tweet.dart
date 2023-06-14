// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Tweet {
  String? profilePicURL;
  String? timeAgo;
  String? text;
  String? mediaURL = "";
  String? handle = 'Curl Manitoba';
  bool isRetweet = false;
  bool isQuoteTweet = false;
  List<TextSpan> spans = [];

  Tweet({
    this.profilePicURL,
    this.timeAgo,
    this.text,
    this.mediaURL,
    this.handle,
    required this.isRetweet,
    required this.isQuoteTweet,
    required this.spans,
  });
}
