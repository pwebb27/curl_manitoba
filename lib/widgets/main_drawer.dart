import 'package:curl_manitoba/models/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../drawer_data.dart';

class MainDrawer extends StatelessWidget {
  buildTile(DrawerTile drawerTile, BuildContext context) {
    return GestureDetector(
        onTap: () {
          drawerTile.Navigate(context);
        },
        child: ListTile(
            dense: true,
            leading: Container(child:drawerTile.icon),
            title: Text(
              drawerTile.title as String,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontFamily: 'NeuzeitOffice',
                fontWeight: FontWeight.bold,
              ),
            )));
  }

  buildTiles(BuildContext context) {
    List<Widget> tiles = [];
    for (var tile in PAGE_TILES_DATA) tiles.add(buildTile(tile, context));
    tiles.add(buildDivider('Useful Links'));
    for (var tile in USEFUL_LINKS_DATA) tiles.add(buildTile(tile, context));
    tiles.add(buildDivider('Social Media'));
    for (var tile in SOCIAL_MEDIA_LINKS_DATA) tiles.add(buildTile(tile, context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: SafeArea(
          child: Drawer(
            child: Column(children: <Widget>[
              Flexible(
                  child: Image(
                      image: AssetImage("assets/images/DrawerImage.PNG"),
                      )),
              Padding(padding: EdgeInsets.only(top: 3)),
              SingleChildScrollView(physics: ScrollPhysics(), child: buildTiles(context))
            ]),
          ),
        ));
  }

  Widget buildDivider(String title) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Divider(
        height: 10,
        thickness: 1,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12, top: 10),
        child: Text(title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontFamily: 'NeuzeitOffice',
              fontWeight: FontWeight.bold,
            )),
      )
    ]);
}

class DrawerTile extends StatelessWidget {
  late String title;
  late Widget icon;

  DrawerTile(this.title, String iconName,
      {double width = 20, double height = 20}) {
    this.icon = Container(
        alignment: Alignment.centerLeft,
        height: height,
        width: width,
        child: SvgPicture.asset(
          'assets/icons/' + iconName + '.svg',
          color: Colors.grey.shade700,
        ));
  }

  Navigate(BuildContext context) {
    Navigator.pushNamed(context, '/gridView', arguments: title);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        Navigate(context);
      },
      child: ListTile(
          dense: true,
          leading: Container(child: icon),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontFamily: 'NeuzeitOffice',
              fontWeight: FontWeight.bold,
            ),
          )));
}

class ExternalLinkDrawerTile extends DrawerTile {
  String url;

  ExternalLinkDrawerTile(String title, String iconName, this.url,
      {double width = 20, double height = 20})
      : super(title, iconName, width: width, height: height) {
    this.url = url;
  }

  Navigate(BuildContext context) {
    () async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
        );
      }
    };
  }
}
