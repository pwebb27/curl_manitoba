import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/screens/tabsScreens/competition_tabs_screen.dart';
import 'package:curl_manitoba/screens/grid_view_content.dart';
import 'package:curl_manitoba/screens/mainTabs/news/news_screen.dart';
import 'package:curl_manitoba/screens/mainTabs/news/news_article_screen.dart';
import 'package:curl_manitoba/screens/tabsScreens/home_tabs_screen.dart';
import 'package:curl_manitoba/screens/grid_view_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => TabsScreen());
      case '/scoresWebPage':
        return MaterialPageRoute(builder: (_) => NewsStoryScreen(args as NewsStory));
      case '/gridView':
        return MaterialPageRoute(builder: (_) => GridViewScreen(args as String));
      case '/gridViewContent':
        return MaterialPageRoute(builder: (_) => GridViewContentScreen(args as String));
      case '/competition':
        return MaterialPageRoute(builder: (_) => CompetitionScreen(args as scoresCompetition));
              case '/competition':
        return MaterialPageRoute(builder: (_) => CompetitionScreen(args as scoresCompetition));


      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() =>
     MaterialPageRoute(builder: (_) =>
       Scaffold(body: Center(child: Text('ERROR')))
    );
  }

