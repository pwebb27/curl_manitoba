import 'package:flutter/material.dart';


class DrawerTile {
  late String title;
  late double iconSize;
  Widget? icon;
  String? url;


  ///Creates a ListTile widget for the drawer
  DrawerTile(String title, dynamic iconData,{String url = '', double iconSize = 19}) {
    this.icon = icon;
    this.title = title;
    this.url = url;

    //icon may be an image
    (iconData.runtimeType == AssetImage)
        ? this.icon = Image(image: iconData, height: 28)
        : this.icon = Icon(
            iconData as IconData,
            size: iconSize,
            color: Colors.grey.shade700
          );
  }

  String? get getTitle {
    return title;
  }

  Widget? get getIcon {
    return icon;
  }

  String? get getUrl{
    return url;
  }
}
