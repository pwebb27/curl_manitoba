import 'package:curl_manitoba/data/main_color_pallete.dart';
import 'package:curl_manitoba/presentation/providers/hasMoreCompetitionsProvider.dart';
import 'package:curl_manitoba/presentation/providers/loadedCompetitionsProvider.dart';
import 'package:curl_manitoba/presentation/providers/loadingProvider.dart';
import 'package:curl_manitoba/presentation/providers/sliverappbar_arrow_provider.dart';
import 'package:curl_manitoba/presentation/providers/sliverappbar_title_provider.dart';
import 'package:curl_manitoba/data/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SliverAppBarTitle()),
    ChangeNotifierProvider(create: (_) => SliverAppBarArrow()),
    ChangeNotifierProvider(create: (_) => LoadingProvider()),
    ChangeNotifierProvider(create: (_) => HasMoreCompetitionsProvider()),
    ChangeNotifierProvider(create: (_) => LoadedCompetitionsProvider()),
  ], child: MyApp()));
}

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
        SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xff6f1200),

          primaryColorLight:const Color.fromRGBO(143, 108, 102, 1), //40%
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute);
  }
}
