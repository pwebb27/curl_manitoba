import 'package:curl_manitoba/apis/api_base_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WordPressApi {
  static const String baseUrl = 'curlmanitoba.org';
  static const String _rootPath = '/wp-json/wp/v2/';

  static final WordPressApi _singleton = WordPressApi._internal();
  WordPressApi._internal();
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper(http.Client());

  factory WordPressApi() => _singleton;

  Future<http.Response> fetchPage(String pageNumber) async {
    String extendedPath = _rootPath + 'pages/$pageNumber';
    return _apiBaseHelper.callApi(
        authority: baseUrl,unencodedPath:  extendedPath, queryParameters: {'_fields': 'content'});
  }

  Future<http.Response> fetchPosts({required int amountOfPosts}) async {
    String extendedPath = _rootPath + 'posts';
    return _apiBaseHelper
        .callApi(authority: baseUrl,unencodedPath:  extendedPath, queryParameters: {
      '_fields': ['id', 'title', 'date', 'author'].join(','),
      'per_page': '$amountOfPosts'
    });
  }

  Future<http.Response> fetchPost(String postId) async {
    String extendedPath = _rootPath + 'posts/$postId';
    return _apiBaseHelper.callApi(
        authority: baseUrl,unencodedPath:  extendedPath, queryParameters: {'_fields': 'content'});
  }

  Future<http.Response> fetchCalendarData() async {
  const String _eventsCalendarPath = '/wp-json/tribe/events/v1/events';

    return _apiBaseHelper.callApi(
        authority: baseUrl ,unencodedPath: _eventsCalendarPath,
        queryParameters: {
          'per_page': '999',
          'start_date': _getStartingDateForCalendarEvents()
        });
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
