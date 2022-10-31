
import 'package:curl_manitoba/models/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/player.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Team {
  String? name;
  final String id;
  List<Player>? players;

  String? coach;
  String? affiliation;
  String? location;

  Team(this.id);

  Team.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'].toString(),
        coach = jsonMap['coach'],
        location = jsonMap['location'],
        affiliation = jsonMap['affiliation'],
        name = jsonMap['name'].split(" ")[0] == 'Team'
            ? jsonMap['name']
            : 'Team ' + jsonMap['name'],
        players = [
          for (Map<String, dynamic> jsonPlayer in jsonMap['team_athletes'])
            (Player.fromJson(jsonPlayer))
        ];

  static List<Team> parseTeamsData(http.Response teamsResponse) {
    return [
      for (Map<String, dynamic> jsonTeam in json.decode(teamsResponse.body))
        Team.fromJson(jsonTeam)
    ];
  }
}
