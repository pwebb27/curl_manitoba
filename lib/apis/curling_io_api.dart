import 'package:curl_manitoba/apis/api_base_helper.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CurlingIOApi {
  static final CurlingIOApi _singleton = CurlingIOApi._internal();
  CurlingIOApi._internal();
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper(http.Client());

  factory CurlingIOApi() => _singleton;

  static const String baseUrl =
      'https://legacy-curlingio.global.ssl.fastly.net';

  static const String _rootPath = '/api/organizations/MTZFJ5miuro/competitions';

  Future<http.Response> fetchGames(String competitionID) {
    String fullPath = _rootPath + '/$competitionID/games';
    return _apiBaseHelper.callApi(authority: baseUrl, unencodedPath: fullPath);
  }

  Future<http.Response> fetchTeams(String competitionID) {
    String fullPath = _rootPath + '/$competitionID/teams';
    return _apiBaseHelper.callApi(authority: baseUrl, unencodedPath: fullPath);
  }

  Future<http.Response> fetchCompetitions(
      [String tag = '', String pageNumber = '1']) {
    String fullPath = _rootPath +
        '?' +
        Uri(queryParameters: {'tags': tag, 'page': pageNumber}).query;

    return _apiBaseHelper.callApi(authority: baseUrl, unencodedPath: fullPath);
  }

  Future<http.Response> fetchGameResults(
      String competitionID, String teamID, String gamePositionsID) {
    String fullPath = _rootPath +
        '/$competitionID/teams/$teamID/game_positions/$gamePositionsID';
    return _apiBaseHelper.callApi(authority: baseUrl, unencodedPath: fullPath);
  }

  Future<http.Response> fetchFormat(String competitionID) {
    String fullPath = _rootPath + '/$competitionID/formats';
    return _apiBaseHelper.callApi(authority: baseUrl, unencodedPath: fullPath);
  }
}

//Temporary class for mocking CurlingIOApi to mitigate extensive use of the API
class MockCurlingIOApi {
  static final MockCurlingIOApi _singleton = MockCurlingIOApi._internal();
  MockCurlingIOApi._internal();

  factory MockCurlingIOApi() => _singleton;

  Future<http.Response> fetchCompetitions() async => http.Response(
      await rootBundle.loadString('assets/json/competitions.json'), 200);
}
