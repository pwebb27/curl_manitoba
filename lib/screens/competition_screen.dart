import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CompetitionScreen extends StatefulWidget {
  CompetitionScreen(this.competition);
  scoresCompetition competition;
  static const routeName = '/competition';

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen>
    with TickerProviderStateMixin {
  late scoresCompetition competition;
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    competition = widget.competition;
    _controller = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(context, 'Live Scores & Results'),
      body: new ListView(
        children: <Widget>[
          Material(
            elevation: 1,
            child: Container(
              color: Colors.white,
              child: new Column(
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 7), child: Image.network(competition.sponsorImageUrl, height: 60)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 2),
                    child: Text(
                      competition.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TabBar(
                    isScrollable: true,
                    labelColor: Colors.black,
                    controller: _controller,
                    tabs: [
                      new Tab(
                        text: 'Scoreboard',
                      ),
                      new Tab(
                        text: 'Standings/Draw',
                      ),
                      new Tab(
                        text: 'Teams',
                      ),
                      new Tab(
                        text: 'Reports',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 80.0,
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                Center(
                  child: Text('Tab1'),
                ),
                Center(
                  child: Text('Tab2'),
                ),
                Center(
                  child: Text('Tab3'),
                ),
                Center(
                  child: Text('Tab4'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
