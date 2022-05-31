import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsStory {
  late String headline;
  late String imageURL;
  late String author;
  late String date;
  late int id;
  String? content;

  NewsStory.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.author = getAuthorId(json['author']);
    this.headline = json['title']['rendered'];
    this.date = DateFormat('LLL d, y').format(DateTime.parse(json['date']));
    this.imageURL =
        'https://images.thestar.com/CBZVV_aqoiPFukcZjs74JNLtlF8=/1200x798/smart/filters:cb(2700061000)/https://www.thestar.com/content/dam/thestar/sports/curling/2018/02/04/manitobas-jennifer-jones-heads-to-scotties-tournament-of-hearts-final/jennifer_jones.jpg';
  }

  String getAuthorId(int authorId) {
    switch (authorId) {
      case 3:
        return 'Laurie Macdonell';
      case 27:
        return 'Rob Gordon';
      default:
        return 'Unknown author';
    }
  }

  static Future<Response> getNewsData() async {
    const newsURL =
        'https://curlmanitoba.org/wp-json/wp/v2/posts?_fields=id,title,date,author&per_page=4';
    var response = await http.get(Uri.parse(newsURL));
    return response;
  }

  static List<NewsStory> parseNewsData(http.Response newsStoriesResponse) {
    final posts = json.decode(newsStoriesResponse.body);
    List<NewsStory> newsStories = [];

    posts.forEach((post) {
      newsStories.add(NewsStory.fromJson(post));
    });
    return newsStories;
  }
}
