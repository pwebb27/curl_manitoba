import 'package:curl_manitoba/models/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/player.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Team {
  late String? name;
  late String id;
  List<Player>? players;
  

  Team(this.id);

  Team.fromJson(Map<String, dynamic> json) {
    String tempName = json['name'];
    List<String> wordList = tempName.split(" ");
    (wordList[0].toLowerCase() == 'team')
        ? name = tempName
        : name = 'Team ' + tempName;
    id = json['id'].toString();
    players = [];
    for (Map<String, dynamic> athlete in json['team_athletes'])
      players!.add(Player.fromJson(athlete));
  }



  static List<Team> parseTeamsData(http.Response teamsResponse) {
    List<dynamic> jsonList = json.decode(teamsResponse.body);
    List<Team> teams = [];
    for (Map<String, dynamic> team in jsonList) {
      teams.add(Team.fromJson(team));
    }
    return teams;
  }
}
