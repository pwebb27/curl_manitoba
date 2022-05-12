import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

class gridViewTile {
  late String pageTitle;
  late SvgPicture icon;
  late String imagePath;
  late double iconHeight;
  late double iconWidth;

  gridViewTile(String pageTitle, String iconPath, String imagePath, [double iconWidth = 30, double iconHeight = 30]) {
    this.pageTitle = pageTitle;
    this.icon = SvgPicture.asset('assets/icons/' + iconPath, height: iconWidth, width: iconHeight,color: Colors.white);
    this.imagePath = 'assets/images/' + imagePath;
    this.iconHeight = iconHeight;
    this.iconWidth = iconWidth;
      }

   Navigate(BuildContext context) {
    Navigator.pushNamed(context, '/gridViewContent', arguments: pageTitle);
  }
}
