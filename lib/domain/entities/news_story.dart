import 'package:curl_manitoba/data/models/news_story_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsStory {
  late String headline;
  late String imageURL;
  late String author;
  late String formattedPublishedDate;
  late String id;
  String? content;

  NewsStory({
    required this.headline,
    required this.author,
    required this.imageURL,
    required this.formattedPublishedDate,
    required this.id,
  });
}
