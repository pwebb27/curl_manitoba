import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  late Icon icon;
  ///Boolean that determines whether a tabbar is required or not
  late bool tabbar;
  late BuildContext context;

  @override
  Size get preferredSize =>
      //Determine the size of AppBar based on whether or not a tabbar exists
      (!tabbar) ? Size.fromHeight(56) : Size.fromHeight(98);

  CustomAppBar(Icon icon, BuildContext context, [bool tabbar = false]) {
    this.icon = icon;
    this.tabbar = tabbar;
    this.context = context;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Builder(
              builder: (context) => IconButton(
                  icon: icon,
                  onPressed: () => Scaffold.of(context).openDrawer())),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
            padding: EdgeInsets.only(right: 150, left: 0),
            child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
                fit: BoxFit.cover)),
        bottom: _buildTabbar());
  }

  _buildTabbar() {
    if (!tabbar)
      return null;
    else
      return PreferredSize(
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
                Tab(child: Text('LEAGUE NEWS', style: TextStyle(fontSize: 13))),
                Tab(
                    child:
                        Text('SOCIAL MEDIA', style: TextStyle(fontSize: 13))),
              ],
            )),
      );
  }
}
