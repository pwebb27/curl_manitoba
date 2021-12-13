import 'package:curl_manitoba/screens/news_story_screen.dart';
import 'package:curl_manitoba/screens/tabs_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromRGBO(111, 18, 0, 1),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
          fontFamily: 'Ani Dimitrova'

          ),
          
      routes: {
        '/': (ctx) => TabsScreen(),
        NewsStoryScreen.routeName: (ctx) => NewsStoryScreen(),
      },
      onUnknownRoute: (settings) {
        return;
      },
    );
  }
}
