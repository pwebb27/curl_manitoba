import 'package:curl_manitoba/data/models/scoresCompetitionModels/player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Team {
  String? name;
  final String? id;
  List<Player>? players;

  String? coach;
  String? affiliation;
  String? location;

  Team(this.id);

  Team.fromJson(Map<String, dynamic> jsonTeam)
      : id = '${jsonTeam['id']}',
        coach = jsonTeam['coach'],
        location = jsonTeam['location'],
        affiliation = jsonTeam['affiliation'],
        //Remove leading 'team' word in team name if present
        name = '${jsonTeam['name']}'.split(" ")[0].toLowerCase() != 'team'
            ? jsonTeam['name']
            : '${jsonTeam['name']}'.split(" ").sublist(1,'${jsonTeam['name']}'.length).join(" "),
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
