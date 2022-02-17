import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  late Icon icon;

  ///Boolean that determines whether a tabbar is required or not
  late bool tabbar;
  late BuildContext context;
  late String pageTitle;

  @override
  Size get preferredSize =>
      //Determine the size of AppBar based on whether or not a tabbar exists
      (!tabbar) ? Size.fromHeight(58) : Size.fromHeight(100);

  CustomAppBar(Icon icon, BuildContext context, String pageTitle,
      [bool tabbar = false]) {
    this.icon = icon;
    this.tabbar = tabbar;
    this.context = context;
    this.pageTitle = pageTitle;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(top: 15, left:6),
              child: Builder(
                  builder: (context) => IconButton(
                      icon: icon,
                      onPressed: () => Scaffold.of(context).openDrawer())),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            title: (pageTitle=="")? Padding(
                padding: EdgeInsets.only(top: 0.5, right: 150, left: 0),
                child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
                    fit: BoxFit.cover))
            
            :Padding(
              padding: const EdgeInsets.only(top:19),
              child: Text(pageTitle, style: TextStyle(fontSize: 22.5, color: Colors.white, fontWeight: FontWeight.w400),),
            ),           bottom: _buildTabbar()),
      ),
    );
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
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              indicatorColor: Color.fromRGBO(111, 17, 0, 1),
              tabs: <Widget>[
                Tab(child: Text('LEAGUE NEWS')),
                Tab(child: Text('SOCIAL MEDIA')),
              ],
            )),
      );
  }
}
