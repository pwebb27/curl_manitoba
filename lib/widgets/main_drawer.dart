import 'package:curl_manitoba/widgets/drawer_tile.dart';
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
            leading: Container(alignment: Alignment.centerLeft, height: drawerTile.height, width: drawerTile.width, child:drawerTile.icon),
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
    for (var tile in BASIC_TILES_DATA) tiles.add(buildTile(tile, context));
    tiles.add(buildDivider());
    for (var tile in USEFUL_LINKS_DATA) tiles.add(buildTile(tile, context));
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
              SingleChildScrollView(child: buildTiles(context))
            ]),
          ),
        ));
  }

  Widget buildDivider() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Divider(
        height: 10,
        thickness: 1,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12, top: 10),
        child: Text("Useful Links",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontFamily: 'NeuzeitOffice',
              fontWeight: FontWeight.bold,
            )),
      )
    ]);
  }
}
