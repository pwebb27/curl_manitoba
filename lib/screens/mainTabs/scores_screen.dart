import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/providers/hasMoreCompetitionsProvider.dart';
import 'package:curl_manitoba/providers/loadedCompetitionsProvider.dart';
import 'package:curl_manitoba/providers/loadingProvider.dart';
import 'package:curl_manitoba/widgets/competition_tile.dart';
import 'package:flutter/material.dart';
import '../../widgets/circular_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

  late ScrollController _scrollController;
  late Future<http.Response> _competitionDataFuture;
  late int _pageIndex;
  late int defaultChoiceIndex;
  late CurlingIOAPI _curlingIOAPI;

  filterCompetitions() {}

  @override
  void initState() {
    defaultChoiceIndex = -1;
    _pageIndex = 0;
    _curlingIOAPI = CurlingIOAPI();
    _competitionDataFuture = _curlingIOAPI.fetchCompetitions('', _pageIndex);
    context.read<LoadedCompetitionsProvider>().loadedCompetitions =
        widget.preloadedCompetitions;

    _scrollController = ScrollController()..addListener(_loadMoreCompetitions);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_loadMoreCompetitions);
    _scrollController.dispose();
  }

  void _loadMoreCompetitions() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !context.read<LoadingProvider>().isLoading &&
        context.read<HasMoreCompetitionsProvider>().hasMoreCompetitions) {
      context.read<LoadingProvider>().isLoading = true;

      _pageIndex++;

      http.Response response =
          await _curlingIOAPI.fetchCompetitions('', _pageIndex);

      List<scoresCompetition> newCompetitions =
          scoresCompetition.parseCompetitionData(response);

      if (newCompetitions.length < 10)
        context.read<HasMoreCompetitionsProvider>().hasMoreCompetitions = false;

      context
          .read<LoadedCompetitionsProvider>()
          .addCompetitions(newCompetitions);

      context.read<LoadingProvider>().isLoading = false;
    }
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
              background: Column(children: [
            Material(
                elevation: 1,
                child: Container(
                    height: 145,
                    width: double.infinity,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 17, bottom: 15, left: 11, right: 11),
                      child: buildWrap(),
                    ))),
          ]))),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        ((_, index) {
          return (CompetitionTile(context
              .read<LoadedCompetitionsProvider>()
              .loadedCompetitions[index]));
        }),
        childCount: context
            .read<LoadedCompetitionsProvider>()
            .loadedCompetitions
            .length,
      )),
      SliverToBoxAdapter(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: context.watch<LoadingProvider>().isLoading
                  ? Center(child: CircularProgressBar())
                  : !context
                          .read<HasMoreCompetitionsProvider>()
                          .hasMoreCompetitions
                      ? Text('No more data to load')
                      : null)),
    ]);
  }

  Widget buildWrap() {
    return Wrap(
      runSpacing: 10,
      alignment: WrapAlignment.center,
      spacing: 15,
      children: _competitionTags.asMap().entries.map((entry) {
        print(defaultChoiceIndex);
        return ChoiceChip(
            selected: defaultChoiceIndex == entry.key,
            selectedColor: Colors.grey.shade500,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(entry.value),
            onSelected: (bool isSelected) async {
              setState(() {
                defaultChoiceIndex == entry.key
                    ? defaultChoiceIndex = -1
                    : defaultChoiceIndex = entry.key;
              });

              http.Response response = await _curlingIOAPI
                  .fetchCompetitions(entry.value.replaceAll(' ', '%20'));

              context.read<LoadedCompetitionsProvider>().loadedCompetitions =
                  scoresCompetition.parseCompetitionData(response);

              if (context
                      .read<LoadedCompetitionsProvider>()
                      .loadedCompetitions
                      .isEmpty ||
                  context
                          .read<LoadedCompetitionsProvider>()
                          .loadedCompetitions
                          .length <
                      10)
                context
                    .read<HasMoreCompetitionsProvider>()
                    .hasMoreCompetitions = false;

              ;
            });
      }).toList(),
    );
  }
}
