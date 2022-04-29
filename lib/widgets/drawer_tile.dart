import 'package:curl_manitoba/widgets/grid_view_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DrawerTile {
  late String title;
  String? url;
  String? route;
  Widget? icon;
  late Map<String, dynamic> drawerTileArguments;
  late double width;
  late double height;

  ///Creates a ListTile widget for the drawer
  DrawerTile.asPage(
      String title, String iconName, List<gridViewTile> gridViewData,
      {double width = 21, double height = 21}) {
    this.width = width;
    this.height = height;
    this.icon = SvgPicture.asset(
      'assets/icons/' + iconName + '.svg',
      color: Colors.grey.shade700,
      fit: BoxFit.fitHeight,
    );

    this.title = title;

    drawerTileArguments = {'title': title, 'gridViewData': gridViewData};
  }

  DrawerTile.asUsefulLink(String title, String iconName, String url,
      {double width = 21, double height = 21}) {
    this.icon = icon;
    this.title = title;
    this.url = url;
    this.height = height;
    this.width = width;
    this.icon = SvgPicture.asset(
      'assets/icons/' + iconName + '.svg',
      color: Colors.grey.shade700,
    );
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
        : Navigator.pushNamed(context, '/gridView',
            arguments: drawerTileArguments);
  }
}
