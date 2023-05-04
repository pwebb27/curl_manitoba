import 'package:curl_manitoba/data/main_color_pallete.dart';
import 'package:curl_manitoba/apis/curling_io_api.dart';
import 'package:curl_manitoba/data/repositories/curling_io_repository.dart';
import 'package:curl_manitoba/data/repositories/word_press_repository.dart';
import 'package:curl_manitoba/domain/entities/calendar_event.dart';
import 'package:curl_manitoba/domain/entities/news_story.dart';
import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';
import 'package:curl_manitoba/domain/useCases/curling_io_repository_use_cases.dart';
import 'package:curl_manitoba/domain/useCases/wordpress_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/screens/mainTabs/news/news_screen.dart';
import 'package:curl_manitoba/presentation/screens/mainTabs/scores_screen.dart';
import 'package:curl_manitoba/presentation/widgets/circular_progress_bar.dart';
import 'package:flutter/material.dart';
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
  late List<Future<dynamic>> tabsScreenFutures;
  late List<scoresCompetition> loadedCompetitions;
  late Map<DateTime, List<CalendarEvent>> loadedEvents;
  late List<NewsStory> loadedNews;
  late final List<Widget> _pages;
  Future<void>? resultsFuture;
  late MockCurlingIOApi _mockCurlingIOApi;

  late int _selectedPageIndex;

  void initState() {
    _selectedPageIndex = 0;
    resultsFuture = Future.wait([
      GetScoresCompetitions(CurlingIORepositoryImp())(),
      GetNewsStoryPosts(WordPressRepositoryImp())(amountOfPosts: 8),
      GetCalendarEvents(WordPressRepositoryImp())()
    ]).then((data) {
      loadedCompetitions = data[0];
      loadedNews = data[1];
      loadedEvents = data[2];

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

  _buildBottomNavigationBarItem(String title, String iconName,
      [double iconSize = 24]) {
    return BottomNavigationBarItem(
      label: title,
      activeIcon: SvgPicture.asset('assets/icons/' + iconName + '.svg',
          height: iconSize, color: Theme.of(context).primaryColor),
      icon: SvgPicture.asset(
        'assets/icons/' + iconName + '.svg',
        height: iconSize,
        color: Colors.grey.shade700,
      ),
    );
  }
}
