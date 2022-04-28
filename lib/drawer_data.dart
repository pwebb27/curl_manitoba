import 'widgets/drawer_tile.dart';
import 'gridview_tile_data.dart';


List<DrawerTile> BASIC_TILES_DATA = [
  DrawerTile.asPage('Competitions', 'medals', COMPETITION_GRID_VIEW_TILES_DATA, height: 28 ),
  DrawerTile.asPage('Development', 'gear-arrow',DEVELOPMENT_GRID_VIEW_TILES_DATA,  width: 22.5, height: 22.5),
  DrawerTile.asPage('High Perfomance', 'gauge-max',HIGH_PERFORMANCE_GRID_VIEW_TILES_DATA),
  DrawerTile.asPage('Getting Started', 'hourglass-start',GETTING_STARTED_GRID_VIEW_TILES_DATA ),
  DrawerTile.asPage('About Us', 'circle-info',ABOUT_US_TILES_DATA),
];

List<DrawerTile> USEFUL_LINKS_DATA = [
  DrawerTile.asUsefulLink('Curling I/O', 'curling-canada',
      'https://www.curling.ca', height: 28),
  DrawerTile.asUsefulLink('CurlManitoba Twitter', 'twitter',
      'https://twitter.com/curlmanitoba',width: 22, height: 22),
  DrawerTile.asUsefulLink('CurlManitoba Instagram', 'instagram',
      'https://www.instagram.com/curlmanitoba/?hl=en', width: 22, height: 22),
  DrawerTile.asUsefulLink('CurlManitoba Facebook', 'facebook',
      'https://www.facebook.com/CurlManitoba',width: 22, height: 22),
];
