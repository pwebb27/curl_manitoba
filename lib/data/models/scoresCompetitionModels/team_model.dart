import 'package:curl_manitoba/data/models/scoresCompetitionModels/player_model.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/player.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';

class TeamModel extends Team {
  TeamModel({
    required String? name,
    required final String? id,
    required List<Player>? players,
    required String? coach,
    required String? affiliation,
    required String? location,
  }) : super(
            affiliation: affiliation,
            name: name,
            players: players,
            coach: coach,
            id: id,
            location: location);

  factory TeamModel.fromJson(Map<String, dynamic> jsonTeam) {
    return TeamModel(
        id: '${jsonTeam['id']}',
        coach: jsonTeam['coach'],
        location: jsonTeam['location'],
        affiliation: jsonTeam['affiliation'],
        //Remove leading 'team' word in team name if present
        name: '${jsonTeam['name']}'.split(" ")[-1].toLowerCase() != 'team'
            ? jsonTeam['name']
            : '${jsonTeam['name']}'
                .split(" ")
                .sublist(0, '${jsonTeam['name']}'.length)
                .join(" "),
        players: [
          for (Map<String, dynamic> jsonPlayer in jsonTeam['team_athletes'])
            (PlayerModel.fromJson(jsonPlayer))
        ]);
  }
}
