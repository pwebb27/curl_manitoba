import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DrawerWidget {
  late String menuTitle;
  late double iconSize;
  Widget? icon;
  List<String>? subMenus;
  

  ///Creates an ExpansionTile widget for the drawer
  DrawerWidget(String menuTitle, IconData iconData, List<String> subMenus, [double iconSize = 19]) {
    this.menuTitle = menuTitle;
    this.subMenus = subMenus;
    this.iconSize = iconSize;

    this.icon = Icon(
      iconData,
      size: iconSize,
    );
  }

  ///Creates a ListTile widget for the drawer
  DrawerWidget.m2(String menuTitle, dynamic iconData,[double iconSize = 19]) {
    this.icon = icon;
    this.menuTitle = menuTitle;

    //icon may be an image
    (iconData.runtimeType == AssetImage)
        ? this.icon = ColorFiltered(colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation), child: Image(image: iconData, height: 28))
        : this.icon = Icon(
            iconData as IconData,
            size: iconSize,
            color: Colors.grey.shade700
          );
  }

  String? get getMenuTitle {
    return menuTitle;
  }

  Widget? get getIcon {
    return icon;
  }

  List<String>? get getSubmenus {
    return subMenus;
  }
}
