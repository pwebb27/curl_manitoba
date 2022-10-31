import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WordPressApi {
  static const String _authority = 'curlmanitoba.org';
  static const String _rootPath = '/wp-json/wp/v2/';
  static const String _eventsCalendarPath = '/wp-json/tribe/events/v1/events';
  static const Map<String, String> _basicQueryParameters = {
    '_fields': 'content'
  };


  Future<http.Response> fetchPage(String pageNumber) async {
    String extendedPath = _rootPath + 'pages/$pageNumber';
    return await http
        .get(Uri.https(_authority, extendedPath, _basicQueryParameters));
  }

  Future<http.Response> fetchPost(String postId) async {
    String extendedPath = _rootPath + 'posts/$postId';
    return await http
        .get(Uri.https(_authority, extendedPath, _basicQueryParameters));
  }

  Future<http.Response> fetchCalendarData() async {
      Map<String, String> _eventCalendarQueryParameters = {
    'per_page': '999',
    'start_date': _getStartingDateForCalendarEvents()
  };
    return await http.get(Uri.https(
        _authority, _eventsCalendarPath, _eventCalendarQueryParameters));
  }
    Future<http.Response> fetchPosts({required int amountOfPosts }) async {
            Map<String, List<String>> _eventCalendarQueryParameters = {
    '_fields': ['id','title','date','author'],
    'per_page': ['$amountOfPosts']
  };
    return await http.get(Uri.https(
        _authority, _rootPath, _eventCalendarQueryParameters));
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
