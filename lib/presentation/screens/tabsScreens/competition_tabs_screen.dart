import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/presentation/providers/sliverappbar_arrow_provider.dart';
import 'package:curl_manitoba/presentation/providers/sliverappbar_title_provider.dart';
import 'package:curl_manitoba/presentation/screens/competitionTabs/reports_screen.dart';
import 'package:curl_manitoba/presentation/screens/competitionTabs/scoreboard_screen.dart';
import 'package:curl_manitoba/presentation/screens/competitionTabs/teams/teams_screen.dart';
import 'package:curl_manitoba/presentation/widgets/scores_competition_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CompetitionScreen extends StatefulWidget {
  CompetitionScreen(this.competition);
  final scoresCompetition competition;
  static const routeName = '/competition';

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class _CompetitionScreenState extends State<CompetitionScreen>
    with TickerProviderStateMixin {
  late scoresCompetition competition;
  late TabController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    competition = widget.competition;
    _controller = new TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    _scrollController.addListener(_setOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _setOffset() {
    context.read<SliverAppBarTitle>().calculateOpacity(
        _scrollController.offset, _scrollController.position.maxScrollExtent);
    context.read<SliverAppBarArrow>().calculateOpacity(
        _scrollController.offset, _scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: SafeArea(
      child: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          // Setting floatHeaderSlivers to true is required in order to float
          // the outer slivers over the inner scrollable.

          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                    title: Title(competition),
                    leading: Arrow(),
                    floating: true,
                    pinned: true,
                    expandedHeight: 290.0,
                    collapsedHeight: kToolbarHeight,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: FlexibleSpaceBar(
                        background: MyHeaderDelegate(competition)),
                    bottom: _SliverAppBarDelegate(TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      controller: _controller,
                      tabs: [
                        new Tab(
                          text: 'Scoreboards',
                        ),
                        new Tab(
                          text: 'Teams/Standings',
                        ),
                        new Tab(
                          text: 'Analysis',
                        ),
                      ],
                    ))),
              )
            ];
          },
          body: TabBarView(
            controller: _controller,
            children: [
              ScoreboardScreen(competition),
              TeamsScreen(competition),
              ReportsScreen(competition)
            ],
          ),
        ),
      ),
    ));
  }
}

class Title extends StatelessWidget {
  scoresCompetition competition;
  Title(this.competition);
  Widget build(BuildContext context) {
    return Opacity(
        opacity: context.watch<SliverAppBarTitle>().opacity,
        child: (Text(
          competition.name!,
          style: TextStyle(fontSize: 22, color: Colors.white),
        )));
  }
}

class Arrow extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey.shade500
                .withOpacity(context.watch<SliverAppBarArrow>().opacity),
            shape: BoxShape.circle),
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Colors.white,
        ));
  }
}

class MyHeaderDelegate extends StatelessWidget {
  MyHeaderDelegate(this.competition);
  scoresCompetition competition;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      elevation: 1,
      child: IntrinsicHeight(
        child: Container(
          color: Colors.white,
          child: new Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: scoresCompetitionCachedNetworkImage(competition: competition, height: 70)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  bottom: 12,
                  top: 3,
                ),
                child: Text(
                  competition.name!,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgPicture.asset('assets/icons/landmark.svg',
                      height: 13, color: Colors.grey.shade700),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      competition.venue!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ]),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                      child: Text(
                        competition.formatDateRange(),
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _SliverAppBarDelegate extends StatelessWidget with PreferredSizeWidget {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  Size get preferredSize {
    return new Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      color: Colors.white, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: _tabBar,
    );
  }
}
