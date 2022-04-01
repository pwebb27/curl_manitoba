import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  late Icon icon;

  ///Boolean that determines whether a tabbar is required or not
  late bool tabbar;
  late BuildContext context;
  late String pageTitle;
  late bool searchBar;

  @override
  Size get preferredSize =>
      //Determine the size of AppBar based on whether or not a tabbar exists
      (tabbar)
          ? Size.fromHeight(89)
          : (searchBar)
              ? Size.fromHeight(98)
              : Size.fromHeight(50);

  CustomAppBar(Icon icon, BuildContext context, String pageTitle,
      [bool tabbar = false, bool searchBar = false]) {
    this.icon = icon;
    this.tabbar = tabbar;
    this.searchBar = searchBar;
    this.context = context;
    this.pageTitle = pageTitle;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      child: AppBar(
          leading: Builder(
              builder: (context) => IconButton(
                  icon: icon,
                  onPressed: () => Scaffold.of(context).openDrawer())),
          backgroundColor: Theme.of(context).primaryColor,
          title: (pageTitle == "")
              ? Padding(
                  padding: const EdgeInsets.only(top: 1.5),
                  child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
                      height: 24, fit: BoxFit.cover),
                )
              : Text(
                  pageTitle,
                  style: TextStyle(
                      fontSize: 20.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
          bottom: _buildTabbar()),
    );
  }

  _buildTabbar() {
    if (tabbar)
      return PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
            height: 39,
            color: Colors.white,
            child: TabBar(
              indicatorWeight: 3.5,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey.shade700,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              indicatorColor: Color.fromRGBO(111, 17, 0, 1),
              tabs: <Widget>[
                Tab(child: Text('HOME')),
                Tab(child: Text('SOCIAL MEDIA')),
              ],
            )),
      );
    if (searchBar)
      return PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              height: 38,
              alignment: Alignment.center,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  
                    prefixIcon: Icon(Icons.search),
                    isCollapsed: true,
                    hintText: 'Search by name or location'),
              )),
        ),
      );

    return null;
  }
}
