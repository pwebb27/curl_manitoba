import 'package:curl_manitoba/apis/curling_io_api.dart';
import 'package:curl_manitoba/data/repositories/curling_io_repository.dart';
import 'package:curl_manitoba/domain/entities/draw.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/game_results.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';
import 'package:curl_manitoba/domain/useCases/curling_io_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/widgets/circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

class ScoreboardScreen extends StatefulWidget {
  ScoreboardScreen(this.competition);
  final scoresCompetition competition;
  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  late scoresCompetition competition;
  late List<Game> games;
  List<Draw>? draws;
  FutureGroup<void>? _gameResultsFutureGroup;
  late List<DropdownMenuItem> items;
  Draw? selectedDraw;
  late FutureGroup<void> _teamsAndGamesFutureGroup;
  late List<Team> teams;

  @override
  void initState() {
    super.initState();
    competition = widget.competition;

    _teamsAndGamesFutureGroup = FutureGroup()
      ..add(GetTeams(CurlingIORepositoryImp())(competition.id!))
      ..add(GetGames(CurlingIORepositoryImp())(competition.id!));
    _teamsAndGamesFutureGroup.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Builder(
        builder: (BuildContext context) => CustomScrollView(slivers: <Widget>[
              SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
              SliverPadding(
                padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
                sliver: SliverToBoxAdapter(
                  child: FutureBuilder(
                      future: _teamsAndGamesFutureGroup.future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircularProgressBar();
                        List<dynamic> FutureGroupResponses =
                            snapshot.data as List<dynamic>;

                        teams = FutureGroupResponses[0];
                        games = FutureGroupResponses[1];
                        draws = Draw.getDrawsFromGames(games);
                        //Choose first draw to display as default
                        selectedDraw = draws![0];
                        return StatefulBuilder(builder: (context, setState) {
                          //Go through all games and fetch both teams' game results
                          _gameResultsFutureGroup = FutureGroup();

                          for (Game game in selectedDraw!.games)
                            _gameResultsFutureGroup!
                              ..add(GetGameResults(CurlingIORepositoryImp())(
                                  competition.id!,
                                  game.gameResultsbyTeamMap!.keys.first.id!,
                                  game.gameResultsbyTeamMap!.values.first!.id!))
                              ..add(GetGameResults(CurlingIORepositoryImp())(
                                  competition.id!,
                                  game.gameResultsbyTeamMap!.keys.first.id!,
                                  game.gameResultsbyTeamMap!.values.first!
                                      .id!));
                          _gameResultsFutureGroup!.close();
                          return SingleChildScrollView(
                            child: Column(children: [
                              buildDropDownMenu(),
                              ScoresTables(),
                            ]),
                          );
                        });
                      }),
                ),
              ),
            ]));
  }

  buildDropDownMenu() => Padding(
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
                onChanged: (_selectedDraw) => setState(() {
                  selectedDraw = _selectedDraw;
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

  ScoresTables() {
    return FutureBuilder(
        future: _gameResultsFutureGroup!.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressBar();
          List<dynamic> FutureGroupResponses = snapshot.data as List<dynamic>;

          int i = 0;
          for (Game game in selectedDraw!.games)
            game.gameResultsbyTeamMap!.forEach((team, gameResults) {
              gameResults.addVariablesFromGamesResultsResponse(
                  FutureGroupResponses[i++]);
              team.name = getTeamNamefromTeamsId(team.id!);
            });
          return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: selectedDraw!.games.length,
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
                                      'Sheet ' +
                                          selectedDraw!.games[index].sheet!,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FixedColumn(selectedDraw!.games[index]),
                                      ScrollableColumn(
                                          selectedDraw!.games[index], context),
                                    ]),
                              ])
                        ]),
                  ));
        });
  }

  getTeamNamefromTeamsId(String teamId) {
    for (Team team in teams) {
      if (team.id == teamId) return team.name;
    }
  }

  FixedColumn(Game game) => Container(
        width: 170,
        child: DataTable(
            horizontalMargin: 10,
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
              DataRow(cells: [
                buildFixedColumnCell(
                    game.gameResultsbyTeamMap!.keys.first.name!)
              ]),
              DataRow(cells: [
                buildFixedColumnCell(game.gameResultsbyTeamMap!.keys.last.name!)
              ])
            ]),
      );
}

buildFixedColumnCell(String teamName) {
  return DataCell(Container(
      width: 145,
      child: Text(
        teamName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      )));
}

ScrollableColumn(Game game, BuildContext context) {
  const List<String> headers = [
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

  return Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 8,
        border: TableBorder.symmetric(outside: BorderSide(width: .2)),
        headingRowHeight: 40,
        dataRowHeight: 40,
        headingRowColor:
            MaterialStateProperty.all(Theme.of(context).primaryColorLight),
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
                label: Expanded(
              child: Text(
                header,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            )),
        ],
        rows: [
          buildDataRow(game.gameResultsbyTeamMap!.values.first),
          buildDataRow(game.gameResultsbyTeamMap!.values.last)
        ],
      ),
    ),
  );
}

buildDataRow(GameResults results) {
  List<String> teamRowCells = [
    results.firstHammer == true ? '*' : '',
    for (int endScore in results.endScores!.values) endScore.toString()
  ];
  //Add x's to teamScores to fill out remaining ends
  while (teamRowCells.length <= 8) teamRowCells.add('x');
  teamRowCells.add('${results.total}');

  return DataRow(cells: [
    for (String cellText in teamRowCells)
      DataCell(Center(
        child: Text(
          cellText,
          style: TextStyle(fontSize: 15),
        ),
      ))
  ]);
}


  /*  buildBoxscore(Game game) {
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
  } */
