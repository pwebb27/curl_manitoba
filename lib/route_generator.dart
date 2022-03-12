import 'package:curl_manitoba/screens/news_feed_screen.dart';
import 'package:curl_manitoba/screens/scores_screen.dart';
import 'package:curl_manitoba/screens/tabs_screen.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => TabsScreen());
      case '/news':
        return MaterialPageRoute(builder: (_) => NewsFeedScreen());
      case '/scores':
    
          return MaterialPageRoute(builder: (_) => ScoresScreen(args as String));
     

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
