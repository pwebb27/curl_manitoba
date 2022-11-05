
import 'package:curl_manitoba/models/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/player.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Team {
  String? name;
  final String? id;
  List<Player>? players;

  String? coach;
  String? affiliation;
  String? location;

  Team(this.id);

  Team.fromJson(Map<String, dynamic> jsonTeam)
      : id = jsonTeam['id'].toString(),
        coach = jsonTeam['coach'],
        location = jsonTeam['location'],
        affiliation = jsonTeam['affiliation'],
        name = jsonTeam['name'].split(" ")[0] == 'Team'
            ? jsonTeam['name']
            : 'Team ' + jsonTeam['name'],
        players = [
          for (Map<String, dynamic> jsonPlayer in jsonTeam['team_athletes'])
            (Player.fromJson(jsonPlayer))
        ];

  static List<Team> parseTeamsData(http.Response teamsResponse) {
    return [
      for (Map<String, dynamic> jsonTeam in json.decode(teamsResponse.body))
        Team.fromJson(jsonTeam)
    ];
  }
}
