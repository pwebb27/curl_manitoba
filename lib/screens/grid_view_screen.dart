import 'package:curl_manitoba/gridview_tile_data.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:curl_manitoba/widgets/grid_view_tile.dart';
import 'package:flutter/material.dart';

class GridViewScreen extends StatefulWidget {
  GridViewScreen(this.gridViewArguments);

  Map<String, dynamic> gridViewArguments;

  @override
  State<GridViewScreen> createState() =>
      _GridViewScreenState();
}

class _GridViewScreenState extends State<GridViewScreen> {
  List<Widget> gridViewItems = [];
  late Map<String, dynamic> gridViewArguments;

  @override
  void initState(){
    super.initState();
    gridViewArguments = widget.gridViewArguments;
  }


  @override
  Widget build(
    BuildContext context,
  ) {
    String Pagetitle = gridViewArguments['title'];
    List<gridViewTile> gridViewTiles = gridViewArguments['gridViewData'];

    return Scaffold(
        appBar: CustomAppBar(
          Icon(FontAwesomePro.bars),
          context,
          Pagetitle,
        ),
        body: buildGridView(context, gridViewTiles));
  }

  Widget buildGridView(BuildContext context, List<gridViewTile> gridViewTiles) {
    buildGridViewItems(context, gridViewTiles);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        padding: EdgeInsets.zero,
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        children: List.generate(gridViewItems.length, (index) {
          return gridViewItems[index];
        }),
      ),
    );
  }

  buildGridViewItems(BuildContext context, List<gridViewTile> gridViewTiles) {
    for (int i = 0; i < gridViewTiles.length; i++) {
      gridViewItems.add(
        InkWell(
          onTap: () {
            gridViewTiles[i].Navigate(context);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(.68), BlendMode.darken),
                  image: AssetImage(gridViewTiles[i].imagePath),
                  fit: BoxFit.cover,
                )),
            child: Stack(
              children: [
                Align(
                    alignment: FractionalOffset(.5, .35),
                    child: gridViewTiles[i].icon),
                Align(
                  alignment: FractionalOffset(.5, .75),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Text(
                      gridViewTiles[i].pageTitle + '\n',
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
        ),
      );
    }
  }
}
