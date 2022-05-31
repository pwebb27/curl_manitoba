import 'models/drawer_tile.dart';


List<DrawerTile> PAGE_TILES_DATA = [
  DrawerTile('Competitions', 'medals', height: 24.5 ),
  DrawerTile('Development', 'gear-arrow',  width: 21.5, height: 21.5),
  DrawerTile('High Perfomance', 'gauge-max',),
  DrawerTile('Getting Started', 'hourglass-start', ),
  DrawerTile('About Us', 'circle-info',),
];

List<ExternalLinkDrawerTile> USEFUL_LINKS_DATA = [
  ExternalLinkDrawerTile('Curling I/O', 'curling-canada',
      'https://www.curling.ca', height: 27.5),
  ExternalLinkDrawerTile('CFL Endowment Fund', 'loan',
      'https://curlingforlife.com/',width: 21.5, height: 21.5),
];

List<ExternalLinkDrawerTile> SOCIAL_MEDIA_LINKS_DATA = [
  ExternalLinkDrawerTile('CurlManitoba Twitter', 'twitter',
      'https://twitter.com/curlmanitoba',width: 21.5, height: 21.5),
  ExternalLinkDrawerTile('CurlManitoba Instagram', 'instagram',
      'https://www.instagram.com/curlmanitoba/?hl=en', width: 22, height: 22),
  ExternalLinkDrawerTile('CurlManitoba Facebook', 'facebook',
      'https://www.facebook.com/CurlManitoba',width: 22, height: 22),
];

