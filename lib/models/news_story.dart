import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsStory {
  late String headline;
  late String imageURL;
  late String author;
  late String formattedPublishedDate;
  late String id;
  String? content;

  NewsStory.fromJson(Map<String, dynamic> jsonPost)
      : this.id = jsonPost['id'].toString(),
        this.author = _getAuthorNameFromId(jsonPost['author']),
        this.headline = jsonPost['title']['rendered'],
        this.formattedPublishedDate =
            DateFormat('LLL d, y').format(DateTime.parse(jsonPost['date'])),
        this.imageURL =
            'https://images.thestar.com/CBZVV_aqoiPFukcZjs74JNLtlF8=/1200x798/smart/filters:cb(2700061000)/https://www.thestar.com/content/dam/thestar/sports/curling/2018/02/04/manitobas-jennifer-jones-heads-to-scotties-tournament-of-hearts-final/jennifer_jones.jpg';

  static String _getAuthorNameFromId(int authorId) {
    switch (authorId) {
      case 3:
        return 'Laurie Macdonell';
      case 27:
        return 'Rob Gordon';
      default:
        return 'Unknown author';
    }
  }

  static List<NewsStory> parseNewsData(http.Response newsStoriesResponse) {
    List<dynamic> jsonPosts = json.decode(newsStoriesResponse.body);
    return [
      for (Map<String, dynamic> jsonPost in jsonPosts)
        (NewsStory.fromJson(jsonPost))
    ];
  }
}
