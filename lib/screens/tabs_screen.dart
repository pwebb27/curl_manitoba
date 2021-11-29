import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'e_entry_screen.dart';
import 'calendar_screen.dart';
import 'scores_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = [
    HomeScreen(),
    eEntryScreen(),
    ScoresScreen(),
    CalendarScreen(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  buildBottomNavigationBarItem(String title, IconData icon,
      [double iconSize = 24]) {
    return BottomNavigationBarItem(
      label: title,
      icon: Icon(icon, size: iconSize),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Builder(
              builder: (context) => IconButton(
                  icon: new Icon(FontAwesomePro.bars, size: 21),
                  onPressed: () => Scaffold.of(context).openDrawer())),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
            padding: EdgeInsets.only(right: 150, left: 0),
            child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
                fit: BoxFit.cover)),
        bottom: (_selectedPageIndex == 0)
            ? PreferredSize(
                preferredSize: Size.fromHeight(42),
                child: Container(
                    height: 42,
                    color: Colors.white,
                    child: TabBar(
                      indicatorWeight: 3.5,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey.shade700,
                      indicatorColor: Color.fromRGBO(111, 17, 0, 1),
                      tabs: <Widget>[
                        Tab(
                            child: Text('LEAGUE NEWS',
                                style: TextStyle(fontSize: 13))),
                        Tab(
                            child: Text('SOCIAL MEDIA',
                                style: TextStyle(fontSize: 13))),
                      ],
                    )),
              )
            : null);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildAppBar(),
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
                  buildBottomNavigationBarItem(
                      'Home', FontAwesomeIcons.home, 24.6),
                  buildBottomNavigationBarItem(
                      'e-Entry', FontAwesomePro.memo_circle_check, 23),
                  buildBottomNavigationBarItem(
                    'Scores',
                    FontAwesomePro.bank,
                  ),
                  buildBottomNavigationBarItem(
                      'Calendar', FontAwesomePro.calendar_days),
                ],
              ),
            ),
          ),
        ));
  }
}
