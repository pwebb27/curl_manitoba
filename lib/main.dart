import 'package:curl_manitoba/route_generator.dart';
import 'package:curl_manitoba/screens/mainTabs/news/news_article_screen.dart';
import 'package:curl_manitoba/screens/tabsScreens/home_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());
final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Color.fromRGBO(111, 18, 0, 1),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
            fontFamily: 'Roboto'),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}
