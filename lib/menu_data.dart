import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './menu.dart';

List<Menu> EXPANSION_MENU_DATA = [
  Menu('News', FontAwesomePro.newspaper, [
    'News Archive',
    'Newsletter',
    'Did you know?',
  ]),
  Menu('Competitions', FontAwesomeIcons.trophy, [
    'Rules',
    'Qualifying Information',
    'CurlManitoba Fees',
    'Provincial Championships',
    'Championship History',
    'Manitoba Open',
    'Manitoba Games 2022',
    'Canada Winter Games',
    'Free Agents',
    'O\'Grady Challenge',
    'Deneen Cup',
    'Youth Events',
    'Manitoba Sport Regions'
  ]),
  Menu('Development', FontAwesomePro.curling, [
    'Curling Programs',
    'Coaching',
    'Officiating',
    'Ice Tech',
    'LTAD',
    'Safe Sport'
  ], 18),
  Menu('High Perfomance', FontAwesomePro.gauge_max, [
    'High Performance Webinars',
    'Junior Development',
    'Junior High Performance Programs',
    'Junior ID Camps'
  ]),
  Menu('Getting Started', FontAwesomePro.hourglass_start, [
    'Find a Club',
    'What is Curling?',
    'Lessons',
    'League Openings',
    'Curling Tips',
    'Manitoba Stick Curling Association'
  ]),
  Menu('About Us', FontAwesomePro.circle_info, [
    'COVID-19 Information',
    'Contact Us',
    'Mission & Vision',
    'Staff',
    'Leadership & Governance',
    'Sponsors/Partners',
    'Club Information',
    'Hall of Fame and Museum',
    'Honourary Life Members',
    'Classified Ads',
    'Volunteer Opportunities',
    'Scholareships',
    'Awards',
    'History'
  ]),
];
List<Menu> LIST_MENU_DATA = [
  Menu.m2(
      'Curling I/O',
      AssetImage(
        'assets/images/curling-canada.png',
      )),
  Menu.m2('CurlManitoba Twitter', FontAwesomeIcons.twitter),
  Menu.m2('CurlManitoba Instagram', FontAwesomePro.instagram, 20),
  Menu.m2('CurlManitoba Facebook', FontAwesomeIcons.facebook),
];
