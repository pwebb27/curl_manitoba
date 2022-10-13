import 'dart:convert';

import 'package:curl_manitoba/main_color_pallete.dart';
import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:curl_manitoba/models/calendar_event.dart';
import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/screens/mainTabs/news/news_screen.dart';
import 'package:curl_manitoba/screens/mainTabs/scores_screen.dart';
import 'package:curl_manitoba/widgets/circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/main_drawer.dart';
import '../mainTabs/calendar_screen.dart';
import '../mainTabs/e_entry_screen.dart';
import '../mainTabs/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late PageController _pageController;
  late List<Future<http.Response>> tabsScreenFutures;
  late List<scoresCompetition> loadedCompetitions;
  late Map<DateTime, List<CalendarEvent>> loadedEvents;
  late List<NewsStory> loadedNews;
  late final List<Widget> _pages;
  late String test;
  Future<void>? resultsFuture;
  late CurlingIOAPI curlingIoApi;

  late int _selectedPageIndex;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void initState() {
    _selectedPageIndex = 0;
    final curlingIoApi = CurlingIOAPI();

    curlingIoApi.client = MockClient((request) async {
      return http.Response(await rootBundle.loadString('assets/json/competitions.json'), 200);
    });

    tabsScreenFutures = [
      curlingIoApi.fetchCompetitions(),
      NewsStory.getNewsData(8),
      CalendarEvent.getCalendarData(),
    ];
    resultsFuture = Future.wait(tabsScreenFutures).then((data) {
      loadedCompetitions = scoresCompetition.parseCompetitionData(data[0]);
      loadedNews = NewsStory.parseNewsData(data[1]);
      loadedEvents = CalendarEvent.parseCalendarData(data[2]);

      _pages = [
        HomeScreen(loadedCompetitions, loadedNews),
        eEntryScreen(),
        NewsFeedScreen(loadedNews),
        ScoresScreen(loadedCompetitions),
        CalendarScreen(loadedEvents),
      ];
      _pageController = PageController(initialPage: _selectedPageIndex);
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  _buildBottomNavigationBarItem(String title, String iconName,
      [double iconSize = 24]) {
    return BottomNavigationBarItem(
      label: title,
      activeIcon: SvgPicture.asset('assets/icons/' + iconName + '.svg',
          height: iconSize, color: Theme.of(context).colorScheme.primary),
      icon: SvgPicture.asset(
        'assets/icons/' + iconName + '.svg',
        height: iconSize,
        color: Colors.grey.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Scaffold(body: CircularProgressBar());

          return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: (_selectedPageIndex != 0)
                    ? CustomAppBar(
                        context,
                        (_selectedPageIndex == 1)
                            ? 'Electronic Entry'
                            : (_selectedPageIndex == 2)
                                ? 'News'
                                : (_selectedPageIndex == 3)
                                    ? 'Live Scores & Results'
                                    : (_selectedPageIndex == 4)
                                        ? 'Calendar of Events'
                                        : "",
                        (_selectedPageIndex == 3) ? true : false)
                    : null,
                drawer: MainDrawer(),
                body: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: _pages,
                ),
                bottomNavigationBar: SizedBox(
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.shade700, width: .4))),
                    child: BottomNavigationBar(
                      elevation: 10,
                      currentIndex: _selectedPageIndex,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: Colors.grey.shade700,
                      selectedItemColor: MainColorPallette.kToDark.shade100,
                      onTap: (selectedPageIndex) {
                        setState(() {
                          _selectedPageIndex = selectedPageIndex;
                          _pageController.jumpToPage(selectedPageIndex);
                        });
                      },
                      items: [
                        _buildBottomNavigationBarItem('Home', 'home', 23.5),
                        _buildBottomNavigationBarItem(
                            'e-Entry', 'add-group', 24),
                        _buildBottomNavigationBarItem(
                            'News', 'newspaper', 22.5),
                        _buildBottomNavigationBarItem(
                            'Scores', 'scoreboard', 23.5),
                        _buildBottomNavigationBarItem(
                            'Calendar', 'calendar-days', 25),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
