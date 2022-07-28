import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:curl_manitoba/screens/tabsScreens/competition_tabs_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/teams/team_screen.dart';
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
    teamsFuture = CurlingIOAPI().fetchTeams(competition.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: teamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressBar();
          teams = Team.parseTeamsData(snapshot.data as http.Response);
          return ListView.builder(
              shrinkWrap: true,
              itemCount: teams.length,
              itemBuilder: (context, index) => Container(
                    child: Center(
                      child: ListTile(
                        onTap: () {
                          navKey.currentState!.push(MaterialPageRoute(
                            builder: (_) => TeamDataScreen(teams[index]),
                          ));
                        },
                        title: Text(teams[index].name as String),
                        trailing: Icon(Icons.arrow_right),
                      ),
                    ),
                  ));
        });
  }
}
