import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class StandingsAndDrawsScreen extends StatefulWidget {
  scoresCompetition competition;
StandingsAndDrawsScreen(this.competition);
  @override
  State<StandingsAndDrawsScreen> createState() => _StandingsAndDrawsScreenState();
}

class _StandingsAndDrawsScreenState extends State<StandingsAndDrawsScreen> {
  late scoresCompetition competition;
  @override

  void initState() {
    competition = widget.competition;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Standings'),);
    
  }
}