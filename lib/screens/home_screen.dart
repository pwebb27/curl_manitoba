import 'package:curl_manitoba/screens/home_feed_screen.dart';
import 'package:flutter/material.dart';

import '../screens/news_feed_screen.dart';
import '../screens/twitter_feed_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
          children: [HomeFeedScreen(), TwitterFeedScreen()],
        );
  }
}
