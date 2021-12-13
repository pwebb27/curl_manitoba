import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../drawer_data.dart';

class MainDrawer extends StatelessWidget {
  Theme buildExpansionTiles(BuildContext context, int index) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.grey.shade700, // here for close state
        colorScheme: ColorScheme.light(
          primary: Theme.of(context).primaryColor,
        ), // here for open state in replacement of deprecated accentColor
        dividerColor: Colors.transparent, // if you want to remove the border
      ),
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
            collapsedIconColor: Colors.grey.shade700,
            collapsedTextColor: Colors.grey.shade700,
            leading: (EXPANSION_TILES_DATA[index].getIcon as Icon),
            title: Text(
              EXPANSION_TILES_DATA[index].getMenuTitle as String,
              style: TextStyle(
                fontFamily: 'Neuzeit Office',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 20, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <ListTileTheme>[
                    for (int i = 0;
                        i < EXPANSION_TILES_DATA[index].getSubmenus!.length;
                        i++)
                      ListTileTheme(
                        dense: true,
                        child: ListTile(
                            title: Text(
                          EXPANSION_TILES_DATA[index].getSubmenus![i].toString(),
                          style: TextStyle(
                              fontFamily: 'Neuzeit Office',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey.shade700),
                        )),
                      )
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Column buildListTiles(BuildContext context) {
    List<Widget> widgets = [];

    for (int i = 0; i < LIST_TILES_DATA.length; i++) {
      widgets.add(ListTile(
          dense: true,
          leading: LIST_TILES_DATA[i].getIcon,
          title: Text(
            LIST_TILES_DATA[i].getMenuTitle as String,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontFamily: 'Neuzeit Office',
              fontWeight: FontWeight.bold,
            ),
          )));
    }
    Column column = new Column(children: widgets);
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 290,
        child: Drawer(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 100),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/DrawerImage.PNG'),
                      fit: BoxFit.fill),
                ),
                
                height: 180
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < EXPANSION_TILES_DATA.length; i++)
                    buildExpansionTiles(context, i),
                  Divider(
                    height: 10,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12, top: 9),
                    child: Text("Useful Links",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontFamily: 'Neuzeit Office',
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Container(
                    child: buildListTiles(context),
                  )
                ],
              ),
            ]),
          ),
        ));
  }
}
