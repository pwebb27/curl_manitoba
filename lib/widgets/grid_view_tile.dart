import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

class gridViewTile {
  late String pageTitle;
  late SvgPicture icon;
  late String imagePath;
  late double iconSize;
  late double iconPadding;

  gridViewTile(String pageTitle, String iconPath, String imagePath, [double iconSize = 30, double iconPadding = 8]) {
    this.pageTitle = pageTitle;
    this.icon = SvgPicture.asset(iconPath);
    this.imagePath = imagePath;
    this.iconSize = iconSize;
    this.iconPadding = iconPadding;
      }

   Navigate(BuildContext context) {
    Navigator.pushNamed(context, '/gridViewContent', arguments: pageTitle);
  }
}
