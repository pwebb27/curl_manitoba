import 'package:http/http.dart' as http;

class CurlingIOApi {
  late http.Client client;

  static const String _baseUrl =
      'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions';

  Future<http.Response> fetchGames(String competitionID) =>
      callCurlingIOApi(url: '$_baseUrl/$competitionID/games');

  Future<http.Response> fetchTeams(String competitionID) =>
      callCurlingIOApi(url: '$_baseUrl/$competitionID/teams');

  Future<http.Response> fetchCompetitions(
      [String tag = '', String pageNumber = '1']) {
    String queryString =
        Uri(queryParameters: {'tags': tag, 'page': pageNumber}).query;

    return callCurlingIOApi(url: '$_baseUrl?$queryString');
  }

  Future<http.Response> fetchGameResults(
          String competitionID, String teamID, String gamePositionsID) =>
      callCurlingIOApi(
          url:
              '$_baseUrl/$competitionID/teams/$teamID/game_positions/$gamePositionsID');

  Future<http.Response> fetchFormat(String competitionID) =>
      callCurlingIOApi(url: '$_baseUrl/$competitionID/formats');

  Future<http.Response> callCurlingIOApi({required String url}) async =>
      await client.get(Uri.parse(url));
}
