import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';

class Menu {
  String? menuTitle;
  Widget? icon;
  List<String>? subMenus = null;

  Menu(String menuTitle, IconData iconData, List<String> subMenus, [double iconSize = 19]) {
    this.menuTitle = menuTitle;
    this.subMenus = subMenus;

    this.icon = Icon(
      iconData,
      size: iconSize,
    );
  }
  Menu.m2(String menuTitle, dynamic iconData,[double iconSize = 19]) {
    this.icon = icon;
    this.menuTitle = menuTitle;

    iconData.runtimeType == AssetImage
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
