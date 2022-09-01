import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/screens/competitionTabs/reports_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/scoreboard_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/standings_and_draws_screen.dart';
import 'package:curl_manitoba/screens/competitionTabs/teams/teams_screen.dart';
import 'package:curl_manitoba/screens/mainTabs/homeTabs/home_feed_screen.dart';
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

var top = 0.0;

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class _CompetitionScreenState extends State<CompetitionScreen>
    with TickerProviderStateMixin {
  late scoresCompetition competition;
  late TabController _controller;
  late ScrollController _scrollController;
  late Animation headerAnimation;

  late AnimationController _animationController;
  double currentExtent = 0.0;
  double get minExtent => 0.0;
  double get maxExtent => _scrollController.position.maxScrollExtent;
  double get deltaExtent => maxExtent - minExtent;

  @override
  void initState() {
    super.initState();

    competition = widget.competition;
    _controller = new TabController(length: 3, vsync: this);
    _animationController = new AnimationController(
        duration: Duration(milliseconds: 200), vsync: this);
    _scrollController = ScrollController();
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
                    title: FadeOnScroll(
                      scrollController: _scrollController,
                      fullOpacityOffset: 180,
                      child: Text(competition.name),
                    ),
                    leading: Container(
                        height: 20,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade500.withOpacity(.5),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                    floating: true,
                    pinned: true,
                    expandedHeight: 290.0,
                    collapsedHeight: 60,
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

  _scrollListener() {
    currentExtent = _scrollController.offset;
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

//https://gist.github.com/smkhalsa/ec33ec61993f29865a52a40fff4b81a2
class FadeOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget child;

  FadeOnScroll(
      {Key? key,
      required this.scrollController,
      required this.child,
      this.zeroOpacityOffset = 0,
      this.fullOpacityOffset = 0});

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  late double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    print(_offset);

    if (widget.fullOpacityOffset > widget.zeroOpacityOffset) {
      // fading in
      if (_offset <= widget.fullOpacityOffset / 1.1) {
        return 0;
      } else if (_offset >= widget.fullOpacityOffset)
        return 1;
      else {
        return (widget.fullOpacityOffset - _offset) /
            (widget.fullOpacityOffset - (widget.fullOpacityOffset / 1.1));
      }
    } else {
      // fading out
      if (_offset <= widget.fullOpacityOffset)
        return 1;
      else if (_offset >= widget.zeroOpacityOffset)
        return 0;
      else
        return (_offset - widget.fullOpacityOffset) /
            (widget.zeroOpacityOffset - widget.fullOpacityOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _calculateOpacity(),
      child: widget.child,
    );
  }
}
