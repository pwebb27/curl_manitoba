// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:curl_manitoba/data/models/scoresCompetitionModels/player_model.dart';
import 'package:http/http.dart' as http;

import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/player.dart';

class Team {
  String? name;
  final String? id;
  List<Player>? players;
  String? coach;
  String? affiliation;
  String? location;

  Team({
    required this.name,
    required this.id,
    required this.players,
    required this.coach,
    required this.affiliation,
    required this.location,
  });

  static List<Team> parseTeamsData(http.Response teamsResponse) {
    return [
      for (Map<String, dynamic> jsonTeam in json.decode(teamsResponse.body))
        Team.fromJson(jsonTeam)
    ];
  }
}
