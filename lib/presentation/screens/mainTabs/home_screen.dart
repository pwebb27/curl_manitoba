import 'package:curl_manitoba/domain/entities/news_story.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/presentation/screens/mainTabs/homeTabs/home_feed_screen.dart';
import 'package:curl_manitoba/presentation/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';

import 'homeTabs/twitter_feed_screen.dart';

class HomeScreen extends StatefulWidget with PreferredSizeWidget {
  List<NewsStory> loadedNews;
  List<scoresCompetition> loadedCompetitions;
  HomeScreen(this.loadedCompetitions, this.loadedNews);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  late final TabController _tabController;
  late List<scoresCompetition> loadedCompetitions;
  late List<NewsStory> loadedNews;

  void initState() {
    loadedCompetitions = widget.loadedCompetitions;
    loadedNews = widget.loadedNews;

    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: homeTabbar(
        _tabController,
      ),
      body: TabBarView(
        children: [
          HomeFeedScreen(loadedCompetitions, loadedNews),
          TwitterFeedScreen()
        ],
      ),
    );
  }
}

class homeTabbar extends StatelessWidget with PreferredSizeWidget {
  homeTabbar(this._tabController);
  TabController _tabController;
  @override
  Size get preferredSize => Size.fromHeight(90);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        child: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: Builder(
                builder: (context) => IconButton(
                    icon: Icon(FontAwesomePro.bars, size: 24),
                    onPressed: () => Scaffold.of(context).openDrawer())),
            title: buildAppBarImage(),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(15),
                child: Container(
                    height: 39,
                    color: Colors.white,
                    child: TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        controller: _tabController,
                        indicatorWeight: 3.5,
                        unselectedLabelColor: Colors.grey.shade700,
                        unselectedLabelStyle:
                            TextStyle(fontWeight: FontWeight.w600),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                        indicatorColor: Color.fromRGBO(111, 17, 0, 1),
                        tabs: <Widget>[
                          Tab(child: Text('Home')),
                          Tab(child: Text('Social Media')),
                        ])))));
  }

  buildAppBarImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 1.5),
      child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
          height: 24, fit: BoxFit.cover),
    );
  }
}
