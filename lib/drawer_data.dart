import 'drawer_widget.dart';
import '../widgets/font_awesome_pro_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<DrawerTile> BASIC_TILES_DATA = [
  DrawerTile('News', FontAwesomePro.newspaper),
  DrawerTile('Competitions', FontAwesomeIcons.trophy),
  DrawerTile('Development', FontAwesomePro.curling, iconSize: 18),
  DrawerTile('High Perfomance', FontAwesomePro.gauge_max),
  DrawerTile('Getting Started', FontAwesomePro.hourglass_start),
  DrawerTile('About Us', FontAwesomePro.circle_info),
];

List<DrawerTile> USEFUL_LINKS_DATA = [
  DrawerTile('Curling I/O', AssetImage('assets/images/curling-canada.png'),
      url: 'https://www.curling.ca'),
  DrawerTile('CurlManitoba Twitter', FontAwesomeIcons.twitter,
      url: 'https://twitter.com/curlmanitoba'),
  DrawerTile('CurlManitoba Instagram', FontAwesomePro.instagram,
      url: 'https://www.instagram.com/curlmanitoba/?hl=en', iconSize: 20),
  DrawerTile('CurlManitoba Facebook', FontAwesomeIcons.facebook,
      url: 'https://www.facebook.com/CurlManitoba'),
];
