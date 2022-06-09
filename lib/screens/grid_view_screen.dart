import 'package:curl_manitoba/gridview_tile_data.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/grid_view_tile.dart';
import 'package:flutter/material.dart';

class GridViewScreen extends StatefulWidget {
  GridViewScreen(this.title);

  String title;

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  late String title;
  late List<gridViewTile> gridViewTiles;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    gridViewTiles = getGridViewData(title);
  }

  getGridViewData(String title) {
    switch (title) {
      case 'Competitions':
        return COMPETITION_GRID_VIEW_TILES_DATA;
      case 'Development':
        return DEVELOPMENT_GRID_VIEW_TILES_DATA;
      case 'High Performance':
        return HIGH_PERFORMANCE_GRID_VIEW_TILES_DATA;
      case 'Getting Started':
        return GETTING_STARTED_GRID_VIEW_TILES_DATA;
      case 'About Us':
        return ABOUT_US_TILES_DATA;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: CustomAppBar(
          context,
          title,
        ),
        body: buildGridView(context, gridViewTiles));
  }

  Widget buildGridView(BuildContext context, List<gridViewTile> gridViewTiles) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
            padding: EdgeInsets.zero,
            childAspectRatio: 3 / 2,
            crossAxisCount: 2,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            children: gridViewTiles
                .map<Widget>((tile) => buildGridViewTile(context, tile))
                .toList()));
  }
}

buildGridViewTile(BuildContext context, gridViewTile tile) {
  return InkWell(
    onTap: () {
      tile.Navigate(context);
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(.68), BlendMode.darken),
            image: AssetImage(tile.imagePath),
            fit: BoxFit.cover,
          )),
      child: Stack(
        children: [
          Align(alignment: FractionalOffset(.5, .35), child: tile.icon),
          Align(
            alignment: FractionalOffset(.5, .75),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Text(
                tile.pageTitle + '\n',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
