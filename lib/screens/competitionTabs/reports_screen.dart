import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReportsScreen extends StatefulWidget {
  scoresCompetition competition;
  ReportsScreen(this.competition);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late scoresCompetition competition;

  void initState(){
    competition = widget.competition;
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Reports'),);
    
  }
}