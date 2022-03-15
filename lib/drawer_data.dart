import 'package:curl_manitoba/screens/news_feed_screen.dart';

import 'widgets/drawer_tile.dart';
import '../widgets/font_awesome_pro_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<DrawerTile> BASIC_TILES_DATA = [
  DrawerTile.asPage('News', FontAwesomePro.newspaper, '/news'),
  DrawerTile.asPage('Competitions', FontAwesomeIcons.trophy, ''),
  DrawerTile.asPage('Development', FontAwesomePro.curling,'', iconSize: 18),
  DrawerTile.asPage('High Perfomance', FontAwesomePro.gauge_max,''),
  DrawerTile.asPage('Getting Started', FontAwesomePro.hourglass_start,''),
  DrawerTile.asPage('About Us', FontAwesomePro.circle_info,''),
];

List<DrawerTile> USEFUL_LINKS_DATA = [
  DrawerTile.asUsefulLink('Curling I/O', AssetImage('assets/images/curling-canada.png'),
      'https://www.curling.ca'),
  DrawerTile.asUsefulLink('CurlManitoba Twitter', FontAwesomeIcons.twitter,
      'https://twitter.com/curlmanitoba'),
  DrawerTile.asUsefulLink('CurlManitoba Instagram', FontAwesomePro.instagram,
      'https://www.instagram.com/curlmanitoba/?hl=en', iconSize: 20),
  DrawerTile.asUsefulLink('CurlManitoba Facebook', FontAwesomeIcons.facebook,
      'https://www.facebook.com/CurlManitoba'),
];
