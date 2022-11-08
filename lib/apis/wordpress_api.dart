import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WordPressApi {
  static const String _baseUrl = 'curlmanitoba.org';
  static const String _rootPath = '/wp-json/wp/v2/';
  static const String _eventsCalendarPath = '/wp-json/tribe/events/v1/events';

  late http.Client client;

  Future<http.Response> fetchPage(String pageNumber) async {
    const Map<String, String> _pageQueryParameters = {'_fields': 'content'};
    String extendedPath = _rootPath + 'pages/$pageNumber';
    return await http
        .get(Uri.https(_baseUrl, extendedPath, _pageQueryParameters));
  }

  Future<http.Response> fetchPosts({required int amountOfPosts}) async {
    Map<String, String> _postsQueryParameters = {
      '_fields': ['id', 'title', 'date', 'author'].join(','),
      'per_page': '$amountOfPosts'
    };
    String extendedPath = _rootPath + 'posts';

    return await http
        .get(Uri.https(_baseUrl, extendedPath, _postsQueryParameters));
  }

  Future<http.Response> fetchPost(String postId) async {
    const Map<String, String> _postQueryParameters = {'_fields': 'content'};

    String extendedPath = _rootPath + 'posts/$postId';
    return await http
        .get(Uri.https(_baseUrl, extendedPath, _postQueryParameters));
  }

  Future<http.Response> fetchCalendarData() async {
    Map<String, String> _eventCalendarQueryParameters = {
      'per_page': '999',
      'start_date': _getStartingDateForCalendarEvents()
    };
    return await http.get(Uri.https(
        _baseUrl, _eventsCalendarPath, _eventCalendarQueryParameters));
  }

  static String _getStartingDateForCalendarEvents() {
    //Set default starting date to September 1st of current year
    DateTime startingDate = DateTime(
      DateTime.now().year,
      09,
      01,
    );

    //Load events starting September 1st of last year if we are before July 1st
    if (DateTime.now().isBefore(DateTime(DateTime.now().year, 7, 01)))
      startingDate =
          DateTime(startingDate.year - 1, startingDate.month, startingDate.day);
    return DateFormat('y-MM-dd').format(startingDate);
  }
}
