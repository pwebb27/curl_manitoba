import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' show Client;

class CurlingIOAPI {
  
  Client client = Client();
  static String baseUrl =
      'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions';

  Future<http.Response> fetchGames(String id) async {
    return await http.get(Uri.parse(baseUrl + '/$id/games'));
  }

  Future<http.Response> fetchTeams(String id) async {
    return await http.get(Uri.parse(baseUrl + '/$id/teams'));
  }

  Future<http.Response> fetchCompetitions(
      [String tag = '', int pageNumber = 1]) async {
    return await client
        .get(Uri.parse('$baseUrl.json?search=&tags=$tag&page=$pageNumber'));
  }

  Future<http.Response> fetchGameResults(
      String competitionId, String teamId, String id) async {
    return await http.get(Uri.parse(
        baseUrl + '/$competitionId/teams/$teamId/game_positions/$id'));
  }

  Future<http.Response> fetchFormat(
      String competitionId) async {
    return await http
        .get(Uri.parse('$baseUrl/$competitionId/formats'));
  }
}
