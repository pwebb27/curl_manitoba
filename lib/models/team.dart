import 'package:curl_manitoba/models/player.dart';
import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Team {
  late String name;
  late String id;
  late List<Player> players;

  Team.fromJson(Map<String, dynamic> json) {
    String tempName = json['name'];
    List<String> wordList = tempName.split(" ");
    (wordList[0].toLowerCase() == 'team')
        ? name = tempName
        : name = 'Team ' + tempName;
    id = json['id'].toString();
    players = [];
    for (Map<String, dynamic> athlete in json['team_athletes'])
      players.add(Player.fromJson(athlete));
  }

  static Future<http.Response> fetchTeamsData(String id) async {
    final teamsUrl =
        'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions/$id/teams';
    var response = await http.get(Uri.parse(teamsUrl));
    return response;
  }

  static List<Team> parseTeamsData(http.Response teamsResponse) {
    List<dynamic> teamsData = json.decode(teamsResponse.body);
    List<Team> teams = [];
    for (Map<String, dynamic> team in teamsData) {
      teams.add(Team.fromJson(team));
    }
    return teams;
  }
}
