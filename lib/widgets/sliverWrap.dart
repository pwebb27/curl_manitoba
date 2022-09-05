import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:flutter/material.dart';

class sliverWrap extends StatelessWidget {
  const sliverWrap({
    Key? key,
    required this.competition,
    required this.child,
  }) : super(key: key);

  final scoresCompetition competition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(slivers: <Widget>[
          SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
          child
        ]);
      },
    );
  }
}
