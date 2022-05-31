import 'package:curl_manitoba/widgets/grid_view_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class DrawerTile {
  late String title;
  late Widget icon;

  DrawerTile(this.title, String iconName, {double width = 20, double height = 20}) {
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
  
}

class ExternalLinkDrawerTile extends DrawerTile {
  String url;

  ExternalLinkDrawerTile(String title, String iconName,this.url,
      {double width = 20, double height = 20})
      : super(title, iconName, width: width, height: height) {
    this.url = url;
  }

  Navigate(BuildContext context) {
    () async {
      if (await canLaunch(url as String)) {
        await launch(
          url as String,
          forceSafariVC: false,
        );
      }
    };
  }
}
