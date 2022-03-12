import 'package:curl_manitoba/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../drawer_data.dart';

class MainDrawer extends StatelessWidget {
 
  Widget buildBasicTile(DrawerTile drawerTile) {
    return ListTile(
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
        ));
  }

  buildUsefulLinkTile(DrawerTile drawerTile) {
    return GestureDetector(
        onTap: () async {
          final url = drawerTile.getUrl;
          if (await canLaunch(url as String)) {
            await launch(
              url,
              forceSafariVC: false,
            );
          }
        },
        child: buildBasicTile(drawerTile));
  }

  buildTiles() {
    List<Widget> tiles = [];
    for (var tile in BASIC_TILES_DATA) tiles.add(buildBasicTile(tile));
    tiles.add(buildDivider());
    for (var tile in USEFUL_LINKS_DATA) tiles.add(buildUsefulLinkTile(tile));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: tiles,);
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
                            fit: BoxFit.contain),
                      ),
                      height: 170),
                  buildTiles()
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
