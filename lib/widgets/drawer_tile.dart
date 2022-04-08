import 'package:curl_manitoba/widgets/grid_view_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DrawerTile {
  late String title;
  late double iconSize;
  String? url;
  String? route;
  Widget? icon;
  late Map<String,dynamic> drawerTileArguments;

  ///Creates a ListTile widget for the drawer
  DrawerTile.asPage(String title, IconData iconData, String route, List<gridViewTile> gridViewData
      ,{double iconSize = 19}) {
    this.icon = Icon(iconData, size: iconSize, color: Colors.grey.shade700);
    this.title = title;
    this.route = route;
    drawerTileArguments = {'title': title, 'gridViewData': gridViewData};
  }

  DrawerTile.asUsefulLink(String title, dynamic iconData, String url,
      {double iconSize = 19}) {
    this.icon = icon;
    this.title = title;
    this.url = url;

    //icon may be an image
    (iconData.runtimeType == AssetImage)
        ? this.icon = Image(image: iconData, height: 28)
        : this.icon = Icon(iconData as IconData,
            size: iconSize, color: Colors.grey.shade700);
  }

  String? get getTitle {
    return title;
  }

  Widget? get getIcon {
    return icon;
  }

  String? get routeName {
    return routeName;
  }

  String? get getUrl {
    return url;
  }

  Navigate(BuildContext context) {
    (url != null)
        ? {
            () async {
              if (await canLaunch(url as String)) {
                await launch(
                  url as String,
                  forceSafariVC: false,
                );
              }
            }
          }
        : Navigator.pushNamed(context, route as String, arguments: drawerTileArguments);
  }
}
