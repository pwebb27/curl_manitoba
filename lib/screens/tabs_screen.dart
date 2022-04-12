import 'package:curl_manitoba/screens/news_feed_screen.dart';
import 'package:curl_manitoba/screens/scores_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/font_awesome_pro_icons.dart';
import '../widgets/main_drawer.dart';
import 'calendar_screen.dart';
import 'e_entry_screen.dart';
import 'home_screen.dart';
import 'scores_webpage_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    eEntryScreen(),
    NewsFeedScreen(),
    ScoresScreen(),
    CalendarScreen(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  _buildBottomNavigationBarItem(String title, IconData icon,
      [double iconSize = 24]) {
    return BottomNavigationBarItem(
      label: title,
      icon: Icon(icon, size: iconSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(
              Icon(FontAwesomePro.bars, size: 24),
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
              (_selectedPageIndex == 0) ? true : false,
              (_selectedPageIndex == 3) ? true : false),
          drawer: MainDrawer(),
          body: _pages[_selectedPageIndex],
          bottomNavigationBar: SizedBox(
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade700, width: .4))),
              child: BottomNavigationBar(
                elevation: 10,
                currentIndex: _selectedPageIndex,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Colors.grey.shade700,
                selectedItemColor: Theme.of(context).primaryColor,
                onTap: _selectPage,
                items: [
                  _buildBottomNavigationBarItem(
                      'Home', FontAwesomeIcons.home, 24.6),
                  _buildBottomNavigationBarItem(
                      'e-Entry', FontAwesomePro.memo_circle_check, 23),
                                        _buildBottomNavigationBarItem(
                      'News', FontAwesomePro.newspaper),
                  _buildBottomNavigationBarItem(
                    'Scores',
                    FontAwesomePro.scoreboard,
                  ),
                  _buildBottomNavigationBarItem(
                      'Calendar', FontAwesomePro.calendar_days),
                ],
              ),
            ),
          ),
        ));
  }
}
