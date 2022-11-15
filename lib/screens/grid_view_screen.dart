import 'package:curl_manitoba/data/gridview_tile_data.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GridViewScreen extends StatefulWidget {
  GridViewScreen(this.pageTitle);
  final String pageTitle;

  @override
  State<GridViewScreen> createState() => _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  late List<GridViewTile> gridViewTiles;

  @override
  void initState() {
    super.initState();
    gridViewTiles = _selectGridViewTiles(widget.pageTitle);
  }

  _selectGridViewTiles(String pageTitle) {
    switch (pageTitle) {
      case 'Competitions':
        return COMPETITION_GRID_VIEW_TILES;
      case 'Development':
        return DEVELOPMENT_GRID_VIEW_TILES;
      case 'High Performance':
        return HIGH_PERFORMANCE_GRID_VIEW_TILES;
      case 'Getting Started':
        return GETTING_STARTED_GRID_VIEW_TILES;
      case 'About Us':
        return ABOUT_US_TILES;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: CustomAppBar(
        context,
        widget.pageTitle,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.count(
              padding: EdgeInsets.zero,
              childAspectRatio: 3 / 2,
              crossAxisCount: 2,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
              children: [...gridViewTiles])));
}

class GridViewTile extends StatelessWidget {
  final String _pageTitle;
  final SvgPicture _icon;
  final String _imageFileName;

  GridViewTile(
      {required String pageTitle,
      required String iconFileName,
      required String imageFileName,
      double iconWidth = 30,
      double iconHeight = 30})
      : this._pageTitle = pageTitle,
        this._icon = SvgPicture.asset('assets/icons/' + iconFileName + '.svg',
            height: iconWidth, width: iconHeight, color: Colors.white),
        this._imageFileName = imageFileName;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/gridViewContent',
              arguments: _pageTitle);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(.68), BlendMode.darken),
                image: AssetImage(_imageFileName),
                fit: BoxFit.cover,
              )),
          child: Stack(
            children: [
              Align(alignment: FractionalOffset(.5, .35), child: _icon),
              Align(
                alignment: FractionalOffset(.5, .75),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text(
                    _pageTitle + '\n',
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
