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
            width: 290,
            child: Drawer(
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(bottom: 100),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/DrawerImage.PNG'),
                            ),
                      ),
                      height: 173
                      ),
                      Padding(padding: EdgeInsets.only(top:3)),
                  buildTiles(context)
                ]),
              ),
            )),
      ),
    );
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
