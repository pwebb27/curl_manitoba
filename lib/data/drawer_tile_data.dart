import 'package:curl_manitoba/widgets/main_drawer.dart';

//Data used inside MainDrawer widget

final List<DrawerTile> PAGE_DRAWER_TILES = [
  DrawerTile(title: 'Competitions', iconFileName: 'medals', iconHeight: 24.5),
  DrawerTile(
      title: 'Development',
      iconFileName: 'gear-arrow',
      iconWidth: 21.5,
      iconHeight: 21.5),
  DrawerTile(
    title: 'High Performance',
    iconFileName: 'gauge-max',
  ),
  DrawerTile(
    title: 'Getting Started',
    iconFileName: 'hourglass-start',
  ),
  DrawerTile(
    title: 'About Us',
    iconFileName: 'circle-info',
  ),
];

final List<ExternalLinkDrawerTile> USEFUL_LINKS_DRAWER_TILES = [
  ExternalLinkDrawerTile(
      title: 'Curling I/O',
      iconFileName: 'curling-canada',
      url: 'https://www.curling.ca',
      iconHeight: 27.5),
  ExternalLinkDrawerTile(
      title: 'CFL Endowment Fund',
      iconFileName: 'loan',
      url: 'https://curlingforlife.com/',
      iconWidth: 21.5,
      iconHeight: 21.5),
];

final List<ExternalLinkDrawerTile> SOCIAL_MEDIA_DRAWER_TILES = [
  ExternalLinkDrawerTile(
      title: 'CurlManitoba Twitter',
      iconFileName: 'twitter',
      url: 'https://twitter.com/curlmanitoba',
      iconWidth: 21.5,
      iconHeight: 21.5),
  ExternalLinkDrawerTile(
      title: 'CurlManitoba Instagram',
      iconFileName: 'instagram',
      url: 'https://www.instagram.com/curlmanitoba/?hl=en',
      iconWidth: 22,
      iconHeight: 22),
  ExternalLinkDrawerTile(
      title: 'CurlManitoba Facebook',
      iconFileName: 'facebook',
      url: 'https://www.facebook.com/CurlManitoba',
      iconWidth: 22,
      iconHeight: 22),
];
