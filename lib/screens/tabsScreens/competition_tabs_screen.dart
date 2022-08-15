import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/screens/competitionTabs/reports_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/scoreboard_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/standings_and_draws_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/teams/teams_screen.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompetitionScreen extends StatefulWidget {
  CompetitionScreen(this.competition);
  scoresCompetition competition;
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

  late AnimationController _animationController;
  double currentExtent = 0.0;
  double get minExtent => 0.0;
  double get maxExtent => _scrollController.position.maxScrollExtent;
  double get deltaExtent => maxExtent - minExtent;

  final Tween<double> headerImageHeightTween = Tween(begin: 60, end: 20);
  final Tween<double> titleFontSize = Tween(begin: 22, end: 18);

  @override
  void initState() {
    super.initState();
    competition = widget.competition;
    _controller = new TabController(length: 3, vsync: this);
    _animationController = new AnimationController(
        duration: Duration(milliseconds: 200), vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 100);
    _scrollController.addListener(() {
      _scrollListener();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: CustomAppBar(context, 'Live Scores & Results'),
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      automaticallyImplyLeading: false,
                      expandedHeight: 250,
                      pinned: true,
                      floating: true,
                      actionsIconTheme: IconThemeData(
                        size: 0.0),
                      flexibleSpace: FlexibleSpaceBar(
                        
                        background: 
                        buildHeader(),
                      ),
                      bottom: 
                        TabBar(
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
                        ),
                    
                    )
                  ],
              body: Navigator(
                  key: navKey,
                  onGenerateRoute: (_) => MaterialPageRoute(
                        builder: (_) => TabBarView(
                          controller: _controller,
                          children: <Widget>[
                            ScoreboardScreen(competition),
                            TeamsScreen(competition),
                            ReportsScreen(competition),
                          ],
                        ),
                      ))),
        ));
  }

  buildHeader() {
    return Column(children: <Widget>[
      Material(
        elevation: 1,
        child: Container(
          color: Colors.white,
          child: new Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child:
                      Image.network(competition.sponsorImageUrl, height: 60)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  bottom: 12,
                  top: 3,
                ),
                child: Text(
                  competition.name,
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
                      competition.venue,
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
      )
    ]);
  }

  _scrollListener() {
    setState(() {
      currentExtent = _scrollController.offset;
      print(currentExtent);


    });
  }

  _remapCurrentExtent(Tween<double> target) {
    final double deltaTarget = target.end! - target.begin!;

    double currentTarget =
        (((currentExtent - minExtent) * deltaTarget) / deltaExtent) +
            target.begin!;



  }
}

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: tabBar,
          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          )));
}
