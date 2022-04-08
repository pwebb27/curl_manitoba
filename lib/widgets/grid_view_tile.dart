import 'package:flutter/cupertino.dart';

class gridViewTile {
  late String pageName;
  late IconData iconData;
  late String imagePath;
  late double iconSize;
  late double iconPadding;

  gridViewTile(String pageName, IconData iconData, String imagePath, [double iconSize = 30, double iconPadding = 8]) {
    this.pageName = pageName;
    this.iconData = iconData;
    this.imagePath = imagePath;
    this.iconSize = iconSize;
    this.iconPadding = iconPadding;
      }

  String get getPageName {
    return pageName;
  }

  IconData get getIconData {
    return iconData;
  }

  String get getImagePath {
    return imagePath;
  }
  
  double get getIconSize{
    return iconSize;
  }

  double get getIconPadding{
    return iconPadding;
  }
}
