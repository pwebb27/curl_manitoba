import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/screens/grid_view_content.dart';
import 'package:curl_manitoba/screens/news_feed_screen.dart';
import 'package:curl_manitoba/screens/news_story_screen.dart';
import 'package:curl_manitoba/screens/scores_webpage_screen.dart';
import 'package:curl_manitoba/screens/tabs_screen.dart';
import 'package:curl_manitoba/screens/grid_view_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => TabsScreen());
      case '/news':
        return MaterialPageRoute(builder: (_) => NewsFeedScreen());
      case '/scoresWebPage':
        return MaterialPageRoute(builder: (_) => ScoresWebpageScreen(args as String));
      case '/newsStory':
        return MaterialPageRoute(builder: (_) => NewsStoryScreen(args as NewsStory));
      case '/gridView':
        return MaterialPageRoute(builder: (_) => GridViewScreen(args as String));
      case '/gridViewContent':
        return MaterialPageRoute(builder: (_) => GridViewContentScreen(args as String));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(body: Center(child: Text('ERROR')));
    });
  }
}
