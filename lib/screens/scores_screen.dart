import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/widgets/competition_tile.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../widgets/circular_progress_bar.dart';

class ScoresScreen extends StatefulWidget {
  @override
  _ScoresScreenState createState() => _ScoresScreenState();
}

const List<String> _competitionTags = [
  'Under 18',
  'Mens',
  'Womens',
  'Mixed',
  'Mixed Doubles',
  'U21 Junior',
  'Curling Club',
  'Seniors',
  'Masters',
  'Youth',
];
late List<dynamic> loadedCompetitions;

class _ScoresScreenState extends State<ScoresScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<http.Response> competitionDataFuture;
  late int page;
  bool hasMore = true;
  bool isLoading = false;
  late List<scoresCompetition> newCompetitions;

  static const routeName = '/competitions';
  late int defaultChoiceIndex;

  filterCompetitions() {}

  @override
  void initState() {
    defaultChoiceIndex = -1;
    loadedCompetitions = [];
    page = 1;
    competitionDataFuture = scoresCompetition.getCompetitionData('', page);
    competitionDataFuture.then((value) {
      newCompetitions = scoresCompetition.parseCompetitionData(value);
      loadedCompetitions.addAll(newCompetitions);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        fetch();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> fetch() async {
    List<scoresCompetition> newCompetitions = [];
    if (isLoading) return;
    isLoading = true;
    http.Response response =
        await scoresCompetition.getCompetitionData('', page);

    newCompetitions = scoresCompetition.parseCompetitionData(response);

    setState(() {
      page++;
      isLoading = false;
      if (newCompetitions.length < 10) hasMore = false;

      loadedCompetitions.addAll(newCompetitions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: _scrollController, slivers: [
      SliverAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        expandedHeight: 145,
        floating: true,
        actionsIconTheme: IconThemeData(opacity: 0.0),
              flexibleSpace: Stack(
                children: <Widget>[
                  FlexibleSpaceBar(background: Positioned.fill(
                      child: buildWrap(),
                  
              )),],
              ),),
      FutureBuilder(
          future: competitionDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SliverFillRemaining(
                  child: Center(child: CircularProgressBar()));

            return SliverList(
                delegate: SliverChildBuilderDelegate(
              ((context, index) {
                if (index < loadedCompetitions.length)
                  return CompetitionTile(loadedCompetitions[index]);
                else
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: hasMore
                          ? Center(child: CircularProgressBar())
                          : Text('No more data to load'));
              }),
              childCount: loadedCompetitions.length + 1,
            ));
          })
    ]);
  }

  Widget buildWrap() {
    return StatefulBuilder(
        builder: (context, setState) => Column(children: [
              Material(
                elevation: 1,
                child: Container(
                  height: 145,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 17, bottom: 15, left: 11, right: 11),
                      child: Wrap(
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          spacing: 15,
                          children: _competitionTags
                              .asMap()
                              .entries
                              .map((entry) => ChoiceChip(
                                  selected: defaultChoiceIndex == entry.key,
                                  selectedColor: Colors.grey.shade500,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Text(entry.value),
                                  onSelected: (bool isSelected) {
                                    setState(() {
                                      defaultChoiceIndex =
                                          (isSelected ? entry.key : null)!;
                                      competitionDataFuture = scoresCompetition
                                          .getCompetitionData(entry.value
                                              .replaceAll(' ', '%20'));
                                      competitionDataFuture.then((value) =>
                                          loadedCompetitions = scoresCompetition
                                              .parseCompetitionData(value));
                                    });
                                  }))
                              .toList())),
                ),
              ),
            ]));
  }
}
