import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/models/teams.dart';
import 'package:curl_manitoba/widgets/circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class TeamsScreen extends StatefulWidget {
  TeamsScreen(this.competition);
  final scoresCompetition competition;

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  late scoresCompetition competition;
  late Future<http.Response> teamsFuture;
  late List<Team> teams;
  void initState() {
    teams = [];

    competition = widget.competition;
    print(competition.id);
    teamsFuture = Team.fetchTeamsData(competition.id);
    teamsFuture.then((data) {
      teams = Team.parseTeamsData(data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: teamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressBar();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: teams.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(teams[index].name),
            ),
          );
        });
  }
}
