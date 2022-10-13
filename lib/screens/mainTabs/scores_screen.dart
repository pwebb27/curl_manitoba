import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:flutter/material.dart';
import '../../widgets/circular_progress_bar.dart';
import 'package:http/http.dart' as http;

class ScoresScreen extends StatefulWidget {
  final List<scoresCompetition> preloadedCompetitions;
  ScoresScreen(this.preloadedCompetitions);

  @override
  _ScoresScreenState createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  static const routeName = '/competitions';
  static const List<String> _competitionTags = [
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

  final ScrollController _scrollController = ScrollController();
  late Future<http.Response> _competitionDataFuture;
  late int page;
  late int defaultChoiceIndex;
  late List<scoresCompetition> _loadedCompetitions;

  bool _hasMore = true;
  bool _isLoading = false;

  filterCompetitions() {}

  @override
  void initState() {
    defaultChoiceIndex = -1;
    page = 1;
    _competitionDataFuture = CurlingIOAPI().fetchCompetitions('', page);
    _loadedCompetitions = widget.preloadedCompetitions;

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
    if (_isLoading) return;
    _isLoading = true;
    http.Response response = await CurlingIOAPI().fetchCompetitions('', page);

    newCompetitions = scoresCompetition.parseCompetitionData(response);

    setState(() {
      page++;
      _isLoading = false;
      if (newCompetitions.length < 10) _hasMore = false;

      _loadedCompetitions.addAll(newCompetitions);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(controller: _scrollController, slivers: [
      SliverAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        expandedHeight: 145,
        floating: true,
        snap: true,
        actionsIconTheme: IconThemeData(opacity: 0.0),
        flexibleSpace: FlexibleSpaceBar(
          background: buildWrap(),
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        ((context, index) {
          if (index < _loadedCompetitions.length)
            return (_loadedCompetitions[index] as Widget);
          else
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: _hasMore
                    ? Center(child: CircularProgressBar())
                    : Text('No more data to load'));
        }),
        childCount: _loadedCompetitions.length + 1,
      ))
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
                                      _competitionDataFuture = CurlingIOAPI()
                                          .fetchCompetitions(entry.value
                                              .replaceAll(' ', '%20'));
                                      _competitionDataFuture.then((value) =>
                                          _loadedCompetitions =
                                              scoresCompetition
                                                  .parseCompetitionData(value));
                                    });
                                  }))
                              .toList())),
                ),
              ),
            ]));
  }
}
