import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/format.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:curl_manitoba/screens/tabsScreens/competition_tabs_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/teams/team_screen.dart';
import 'package:curl_manitoba/widgets/circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  late Future<List<http.Response>> futures;
  late List<Format> formats;
  late int defaultChoiceIndex = -1;
  
  late List<Team> teams;
  void initState() {
    teams = [];

    competition = widget.competition;
    print(competition.id);
    futures = Future.wait([
      CurlingIOAPI().fetchTeams(competition.id),
      CurlingIOAPI().fetchFormat(competition.id)
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: futures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressBar();
          List<http.Response> responses = snapshot.data as List<http.Response>;
          teams = Team.parseTeamsData(responses[0]);
          formats = Format.parseFormatData(responses[1]);

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
