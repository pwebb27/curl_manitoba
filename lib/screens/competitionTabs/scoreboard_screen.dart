import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/draw.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/providers/curlingIOClient.dart';
import 'package:curl_manitoba/widgets/circular_progress_bar.dart';
import 'package:curl_manitoba/widgets/custom_expansion_tile.dart';
import 'package:curl_manitoba/widgets/sliverWrap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:provider/provider.dart';

class ScoreboardScreen extends StatefulWidget {
  ScoreboardScreen(this.competition);
  scoresCompetition competition;
  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  late scoresCompetition competition;
  late List<Game> games;
  List<Draw>? draws;
  FutureGroup<void>? _futureGroup;
  late CurlingIOAPI _curlingIOAPI;

  late Future<http.Response> competitionGamesFuture;
  late List<DropdownMenuItem> items;
  Draw? selectedDraw;
  static const List<String> headers = [
    'LSFE',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    'Total'
  ];

  @override
  void initState() {
    super.initState();

    competition = widget.competition;
        _curlingIOAPI = CurlingIOAPI()
      ..client = Provider.of<CurlingIOClientProvider>(context, listen: false)
          .getClient();
    competitionGamesFuture = _curlingIOAPI.fetchGames(competition.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(builder: (BuildContext context) {
      return CustomScrollView(slivers: <Widget>[
        SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
        SliverPadding(
          padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
          sliver: SliverToBoxAdapter(
            child: FutureBuilder(
                future: competitionGamesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressBar();
                  games = Game.parseGamesData(
                      snapshot.data as http.Response, competition);
                  draws = Draw.createDraws(games);

                  selectedDraw = draws![0];
                  return StatefulBuilder(builder: (context, setState) {
                    //Go through each game and add both teams game results to FutureGroup
                    for (Game game in selectedDraw!.games) {
                      _futureGroup = FutureGroup()
                        ..add(_curlingIOAPI.fetchGameResults(
                            competition.id,
                            game.resultsMap.keys.first.id,
                            game.resultsMap.values.first.id))
                        ..add(_curlingIOAPI.fetchGameResults(
                            competition.id,
                            game.resultsMap.keys.first.id,
                            game.resultsMap.values.first.id));
                    }
                    _futureGroup!.close();

                    return SingleChildScrollView(
                      child: Column(children: [
                        buildDropDownMenu(setState),
                        buildScoresTables(selectedDraw),
                      ]),
                    );
                  });
                }),
          ),
        ),
      ]);
    });
  }

  buildDropDownMenu(Function setState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: Colors.grey.shade500)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Draw>(
              isExpanded: true,
              value: selectedDraw,
              onChanged: (selectedDraw) => setState(() {
                this.selectedDraw = selectedDraw;
              }),
              items: draws!
                  .map(
                    (draw) => DropdownMenuItem(
                        value: draw,
                        child: Text('Draw ' +
                            draw.drawNumber +
                            ': ' +
                            DateFormat('jm').format(draw.startTime) +
                            ' on ' +
                            DateFormat('MMMd').format(draw.startTime))),
                  )
                  .toList(),
            ),
          )),
    );
  }

  buildScoresTables(Draw? draw) {
    return FutureBuilder(
        future: _futureGroup!.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressBar();

          List<http.Response> FutureGroupResponses =
              snapshot.data as List<http.Response>;
          for (http.Response response in FutureGroupResponses) {
            Game.parseGamesData(response, competition);
          }
          return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: draw!.games.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, left: 12),
                                  child: Text(
                                      'Sheet ' + draw.games[index].sheet,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildFixedColumn(),
                                      buildScrollableColumn(draw.games[index]),
                                    ]),
                                buildBoxscore(draw.games[index])
                              ])
                        ]),
                  ));
        });
  }

  buildBoxscore(Game game) {
    return CustomExpansionTile(
        tilePadding: EdgeInsets.only(left: 100),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Boxscore',
            style: TextStyle(fontSize: 15),
          ),
        ),
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildFixedColumn(), buildScrollableColumn(game)]),
        ]);
  }

  buildDataRow(GameResults results) {
    List<dynamic> teamScores = [
      results.firstHammer == true ? '*' : '',
      ...results.endScores!.values,
    ];
    while (teamScores.length != 9) teamScores.add('x');
    teamScores.add(results.total as String);
    return DataRow(cells: [
      for (String s in teamScores)
        DataCell(Text(
          s,
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ))
    ]);
  }

  buildFixedColumn() {
    return Container(
      width: 140,
      child: DataTable(
          border: TableBorder.symmetric(outside: BorderSide(width: .2)),
          headingRowHeight: 40,
          dataRowHeight: 40,
          headingRowColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          columns: [
            DataColumn(
              label: Text('Teams',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white)),
            ),
          ],
          rows: [
            DataRow(cells: [buildFixedColumnCell('test')]),
            DataRow(cells: [buildFixedColumnCell('test')])
          ]),
    );
  }

  buildFixedColumnCell(String text) {
    return DataCell(Container(
        width: 145,
        child: Text(
          'test',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        )));
  }

  buildScrollableColumn(Game game) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.symmetric(outside: BorderSide(width: .2)),
          headingRowHeight: 40,
          dataRowHeight: 40,
          headingRowColor: MaterialStateProperty.all(
            Color.fromRGBO(143, 108, 102, 1),
          ),
          columnSpacing: 15,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          ),
          columns: [
            for (String header in headers)
              DataColumn(
                  label: Text(
                header,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              )),
          ],
          rows: [
            buildDataRow(game.resultsMap.values.first),
            buildDataRow(game.resultsMap.values.last)
          ],
        ),
      ),
    );
  }
}
