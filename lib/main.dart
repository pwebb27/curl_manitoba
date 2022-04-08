import 'package:curl_manitoba/route_generator.dart';
import 'package:curl_manitoba/screens/news_story_screen.dart';
import 'package:curl_manitoba/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());

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
