import 'package:curl_manitoba/gridview_tile_data.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:curl_manitoba/widgets/grid_view_tile.dart';
import 'package:flutter/material.dart';

class GridViewScreen extends StatefulWidget {
  GridViewScreen(this.gridViewArguments);

  Map<String,dynamic> gridViewArguments;
  


  @override
  State<GridViewScreen> createState() => _GridViewScreenState(gridViewArguments);
}

class _GridViewScreenState extends State<GridViewScreen> {
  List<Widget> gridViewItems = [];
  Map<String,dynamic> gridViewArguments;
  

  

  _GridViewScreenState(this.gridViewArguments);


  @override


  Widget build(BuildContext context,) {
  String Pagetitle = gridViewArguments['title'];
  List<gridViewTile> gridViewTiles = gridViewArguments['gridViewData'];

    return Scaffold(
        appBar: CustomAppBar(
          Icon(FontAwesomePro.bars),
          context,
          Pagetitle,
        ),
        body: buildGridView(context,gridViewTiles));
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
            gridViewTiles[i].Navigate(context);},
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(.68), BlendMode.darken),
                  image:
                      AssetImage(gridViewTiles[i].imagePath),
                  fit: BoxFit.cover,
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: gridViewTiles[i].icon,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: gridViewTiles[i].iconPadding,
                      left: 12,
                      right: 12),
                  child: Text(
                    gridViewTiles[i].pageTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
