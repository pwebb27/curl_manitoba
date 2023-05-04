import 'package:curl_manitoba/apis/curling_io_api.dart';
import 'package:curl_manitoba/data/repositories/curling_io_repository.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/format.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';
import 'package:curl_manitoba/domain/useCases/curling_io_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/screens/tabsScreens/competition_tabs_screen.dart';
import 'package:curl_manitoba/presentation/screens/competitionTabs/teams/team_screen.dart';
import 'package:curl_manitoba/presentation/widgets/circular_progress_bar.dart';
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
  late Future<List> futures;
  late List<Format> formats;
  late int defaultChoiceIndex = -1;

  late List<Team> teams;
  void initState() {
    teams = [];
    competition = widget.competition;
    futures = Future.wait([
      GetTeams(CurlingIORepositoryImp())(competition.id!),
      GetFormats(CurlingIORepositoryImp())(competition.id!)
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
          teams = responses[0];
          formats = responses[1];

          return Scaffold(
            bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Colors.grey.shade700, width: .4))),
                child: BottomNavigationBar(
                    elevation: 10,
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor: Colors.grey.shade700,
                    selectedItemColor: Theme.of(context).primaryColor,
                    items: [
                      BottomNavigationBarItem(
                        label: 'Standings',
                        activeIcon: SvgPicture.asset('assets/icons/podium.svg',
                            height: 22, color: Theme.of(context).primaryColor),
                        icon: SvgPicture.asset(
                          'assets/icons/award.svg',
                          height: 22,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: 'Brackets',
                        activeIcon: SvgPicture.asset('assets/icons/award.svg',
                            height: 22, color: Theme.of(context).primaryColor),
                        icon: SvgPicture.asset(
                          'assets/icons/bracket.svg',
                          height: 22,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ])),
            body: Builder(builder: (BuildContext context) {
              return CustomScrollView(slivers: <Widget>[
                SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context)),
                SliverToBoxAdapter(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildWrap(),
                        DataTable(
                          showCheckboxColumn: false,
                          dataRowHeight: 60,
                          horizontalMargin: 0,
                          columnSpacing: 17,
                          border: TableBorder.symmetric(
                              outside: BorderSide(width: .2)),
                          headingRowColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            ),
                          ),
                          columns: [
                            buildDataColumn('Team'),
                            buildDataColumn('Games'),
                            buildDataColumn('Wins'),
                            buildDataColumn('Losses'),
                          ],
                          rows: [
                            for (Team team in teams)
                              DataRow(
                                  onSelectChanged: (bool? selected) {
                                    if (selected != null)
                                      navKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (_) => TeamDataScreen(team),
                                      ));
                                  },
                                  cells: [
                                    DataCell(Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(team.name!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    )),
                                    buildDataCell('3'),
                                    buildDataCell('4'),
                                    buildDataCell('5'),
                                  ])
                          ],
                        ),
                      ]),
                ),
              ]);
            }),
          );
        });
  }

  DataCell buildDataCell(String text) {
    return DataCell(
      Center(
        child: Text(
          text,
        ),
      ),
    );
  }

  DataColumn buildDataColumn(String label) {
    return DataColumn(
        label: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }

  Widget buildWrap() {
    return StatefulBuilder(
      builder: (context, setState) => Material(
        elevation: 3,
        child: Container(
          width: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 15,
                  children: formats
                      .asMap()
                      .entries
                      .map((format) => ChoiceChip(
                          selected: defaultChoiceIndex == format.key,
                          selectedColor: Colors.grey.shade500,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(format.value.name!),
                          onSelected: (bool isSelected) {
                            setState(() {
                              defaultChoiceIndex =
                                  (isSelected ? format.key : null)!;
                            });
                          }))
                      .toList())),
        ),
      ),
    );
  }
}
