import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/screens/tabsScreens/competition_tabs_screen.dart';
import 'package:curl_manitoba/widgets/sliverWrap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReportsScreen extends StatefulWidget {
  scoresCompetition competition;
  ReportsScreen(this.competition);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  late scoresCompetition competition;
  static const List<String> reports = [
    'Attendance',
    'Competition Matrix',
    'Draw Results',
    'Scoring Analysis',
    'Scoring Analysis by Hammer',
    'Team Rosters',
    'Team Standings'
  ];

  void initState() {
    competition = widget.competition;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(builder: (BuildContext context) {
      return CustomScrollView(slivers: <Widget>[
        SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        SliverList( delegate:

            SliverChildBuilderDelegate( (BuildContext context, int index) {

          return ListTile(
            title: Text(reports[index]),
            
          );
        },childCount: reports.length)),
      ]);
    });
  }
}
