import 'package:curl_manitoba/apis/api_base_helper.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CurlingIOApi {
  static final CurlingIOApi _singleton = CurlingIOApi._internal();
  CurlingIOApi._internal();
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper(http.Client());

  factory CurlingIOApi() => _singleton;

  static const String _baseUrl =
      'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions';

  Future<http.Response> fetchGames(String competitionID) =>
      _apiBaseHelper.callApi(url: '$_baseUrl/$competitionID/games');

  Future<http.Response> fetchTeams(String competitionID) =>
      _apiBaseHelper.callApi(url: '$_baseUrl/$competitionID/teams');

  Future<http.Response> fetchCompetitions(
      [String tag = '', String pageNumber = '1']) {
    String queryString =
        Uri(queryParameters: {'tags': tag, 'page': pageNumber}).query;

    return _apiBaseHelper.callApi(url: '$_baseUrl?$queryString');
  }

  Future<http.Response> fetchGameResults(
          String competitionID, String teamID, String gamePositionsID) =>
      _apiBaseHelper.callApi(
          url:
              '$_baseUrl/$competitionID/teams/$teamID/game_positions/$gamePositionsID');

  Future<http.Response> fetchFormat(String competitionID) =>
      _apiBaseHelper.callApi(url: '$_baseUrl/$competitionID/formats');
}

//Temporary class for mocking CurlingIOApi to mitigate extensive use of the API
class MockCurlingIOApi {
  static final MockCurlingIOApi _singleton = MockCurlingIOApi._internal();
  MockCurlingIOApi._internal();

  factory MockCurlingIOApi() => _singleton;

  Future<http.Response> fetchCompetitions() async => http.Response(
      await rootBundle.loadString('assets/json/competitions.json'), 200);

}
