import 'package:curl_manitoba/screens/news_feed_screen.dart';
import 'package:curl_manitoba/screens/scores_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/font_awesome_pro_icons.dart';
import '../widgets/main_drawer.dart';
import 'calendar_screen.dart';
import 'e_entry_screen.dart';
import 'home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: (_selectedPageIndex!=0)? CustomAppBar(
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
              
              (_selectedPageIndex == 3) ? true : false):null,
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
                  _buildBottomNavigationBarItem('Home', 'home', 23.5),
                  _buildBottomNavigationBarItem('e-Entry', 'add-group', 24),
                  _buildBottomNavigationBarItem('News', 'newspaper', 23),
                  _buildBottomNavigationBarItem('Scores', 'scoreboard', 23),
                  _buildBottomNavigationBarItem('Calendar', 'calendar-days', 25),
                ],
              ),
            ),
          ),
        ));
  }
}
