import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/screens/home_feed_screen.dart';
import 'package:curl_manitoba/screens/mainTabs/scores_screen.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';

import 'news_screen.dart';
import '../twitter_feed_screen.dart';

class HomeScreen extends StatefulWidget with PreferredSizeWidget {
  List<NewsStory> loadedNews;
  List<scoresCompetition> loadedCompetitions;
  HomeScreen(this.loadedCompetitions, this.loadedNews);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
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
        appBar: CustomAppBar(context,''),
        body: TabBarView(
          children: [HomeFeedScreen(loadedCompetitions, loadedNews), TwitterFeedScreen()],
        ),
      
     
    );
  }
}
