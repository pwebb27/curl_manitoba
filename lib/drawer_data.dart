import 'package:curl_manitoba/screens/news_feed_screen.dart';

import 'widgets/drawer_tile.dart';
import '../widgets/font_awesome_pro_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'gridview_tile_data.dart';

List<DrawerTile> BASIC_TILES_DATA = [
  DrawerTile.asPage('Competitions', FontAwesomePro.half_filled_star, '/gridView', COMPETITION_GRID_VIEW_TILES_DATA ),
  DrawerTile.asPage('Development', FontAwesomePro.gear_arrow,'/gridView', DEVELOPMENT_GRID_VIEW_TILES_DATA,  iconSize: 25),
  DrawerTile.asPage('High Perfomance', FontAwesomePro.gauge_max,'/gridView', HIGH_PERFORMANCE_GRID_VIEW_TILES_DATA),
  DrawerTile.asPage('Getting Started', FontAwesomePro.hourglass_start,'/gridView',GETTING_STARTED_GRID_VIEW_TILES_DATA ),
  DrawerTile.asPage('About Us', FontAwesomePro.circle_info,'/gridView', ABOUT_US_TILES_DATA),
];

List<DrawerTile> USEFUL_LINKS_DATA = [
  DrawerTile.asUsefulLink('Curling I/O', AssetImage('assets/images/curling-canada.png'),
      'https://www.curling.ca'),
  DrawerTile.asUsefulLink('CurlManitoba Twitter', FontAwesomeIcons.twitter,
      'https://twitter.com/curlmanitoba',iconSize: 21),
  DrawerTile.asUsefulLink('CurlManitoba Instagram', FontAwesomePro.instagram,
      'https://www.instagram.com/curlmanitoba/?hl=en', iconSize: 21),
  DrawerTile.asUsefulLink('CurlManitoba Facebook', FontAwesomeIcons.facebook,
      'https://www.facebook.com/CurlManitoba',iconSize: 21),
];
