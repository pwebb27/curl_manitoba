
import 'drawer_widget.dart';
import '../widgets/font_awesome_pro_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<DrawerWidget> EXPANSION_TILES_DATA = [
  DrawerWidget('News', FontAwesomePro.newspaper, [
    'News Archive',
    'Newsletter',
    'Did you know?',
  ]),
  DrawerWidget('Competitions', FontAwesomeIcons.trophy, [
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
  DrawerWidget(
      'Development',
      FontAwesomePro.curling,
      [
        'Curling Programs',
        'Coaching',
        'Officiating',
        'Ice Tech',
        'LTAD',
        'Safe Sport'
      ],
      18),
  DrawerWidget('High Perfomance', FontAwesomePro.gauge_max, [
    'High Performance Webinars',
    'Junior Development',
    'Junior High Performance Programs',
    'Junior ID Camps'
  ]),
  DrawerWidget('Getting Started', FontAwesomePro.hourglass_start, [
    'Find a Club',
    'What is Curling?',
    'Lessons',
    'League Openings',
    'Curling Tips',
    'Manitoba Stick Curling Association'
  ]),
  DrawerWidget('About Us', FontAwesomePro.circle_info, [
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

List<DrawerWidget> LIST_TILES_DATA = [
  DrawerWidget.m2('Curling I/O', AssetImage('assets/images/curling-canada.png'),
      'https://www.curling.ca'),
  DrawerWidget.m2('CurlManitoba Twitter', FontAwesomeIcons.twitter,
     'https://twitter.com/curlmanitoba'),
  DrawerWidget.m2('CurlManitoba Instagram', FontAwesomePro.instagram,
      'https://www.instagram.com/curlmanitoba', 20),
  DrawerWidget.m2('CurlManitoba Facebook', FontAwesomeIcons.facebook,
      'https://www.facebook.com/CurlManitoba'),
];
