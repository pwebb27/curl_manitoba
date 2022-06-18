import 'package:curl_manitoba/screens/home_feed_screen.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';

import '../screens/news_feed_screen.dart';
import '../screens/twitter_feed_screen.dart';

class HomeScreen extends StatefulWidget with PreferredSizeWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      NestedScrollView(
        floatHeaderSlivers: true,
        
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: false,
                bottom: PreferredSize(
                      preferredSize: Size.fromHeight(38),
                      child: Container(
                          height: 39,
                          color: Colors.white,
                          child: TabBar(
                            indicatorWeight: 3.5,
                            labelColor: Theme.of(context).primaryColor,
                            unselectedLabelColor: Colors.grey.shade700,
                            unselectedLabelStyle:
                                TextStyle(fontWeight: FontWeight.w600),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12),
                            indicatorColor: Color.fromRGBO(111, 17, 0, 1),
                            tabs: <Widget>[
                              Tab(child: Text('HOME')),
                              Tab(child: Text('SOCIAL MEDIA')),
                            ],
                          )),
                    ),
                  ),
                
              
            ]),
        body: TabBarView(
          children: [HomeFeedScreen(), TwitterFeedScreen()],
        ),
      ),
      Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
              child: SafeArea(
            top: false,
            child: AppBar(
              leading: Builder(
                  builder: (context) => IconButton(
                      icon: Icon(FontAwesomePro.bars, size: 24),
                      onPressed: () => Scaffold.of(context).openDrawer())),
              backgroundColor: Theme.of(context).primaryColor,
              title: Padding(
                padding: const EdgeInsets.only(top: 1.5),
                child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
                    height: 24, fit: BoxFit.cover),
              ),
            ),
          )))
    ]));
  }
}
