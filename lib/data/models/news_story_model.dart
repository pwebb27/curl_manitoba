import 'package:curl_manitoba/domain/entities/news_story.dart';

import 'package:intl/intl.dart';

class NewsStoryModel extends NewsStory {
  NewsStoryModel({
    required id,
    required author,
    required String headline,
    required String formattedPublishedDate,
    required String imageURL,
  }) : super(
            author: author,
            id: id,
            formattedPublishedDate: formattedPublishedDate,
            imageURL: imageURL,
            headline: headline);

  factory NewsStoryModel.fromJson(Map<String, dynamic> jsonPost) {
    return NewsStoryModel(
        id: '${jsonPost['id']}',
        author: _getAuthorNameFromId(jsonPost['author']),
        headline: jsonPost['title']['rendered'],
        formattedPublishedDate:
            DateFormat('LLL d, y').format(DateTime.parse(jsonPost['date'])),
        imageURL:
            'https://images.thestar.com/CBZVV_aqoiPFukcZjs74JNLtlF8=/1200x798/smart/filters:cb(2700061000)/https://www.thestar.com/content/dam/thestar/sports/curling/2018/02/04/manitobas-jennifer-jones-heads-to-scotties-tournament-of-hearts-final/jennifer_jones.jpg');
  }
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
}
