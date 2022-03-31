import 'package:curl_manitoba/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';

import '../drawer_data.dart';

class MainDrawer extends StatelessWidget {
  buildTile(DrawerTile drawerTile, BuildContext context) {
    return GestureDetector(
        onTap: () {
          drawerTile.Navigate(context);
        },
        child: ListTile(
            dense: true,
            leading: drawerTile.getIcon,
            title: Text(
              drawerTile.getTitle as String,
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
            child: Container(
          width: MediaQuery.of(context).size.width * .73,
          child: Drawer(
            child: ListView(children: <Widget>[
              FittedBox(
                      child: Image.asset("assets/images/DrawerImage.PNG"),
                      fit: BoxFit.cover),
              Padding(padding: EdgeInsets.only(top: 3)),
              SingleChildScrollView(child: buildTiles(context))
            ]),
          ),
        )));
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
