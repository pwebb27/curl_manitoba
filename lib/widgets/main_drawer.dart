import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/drawer_tile_data.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.black,
      child: SafeArea(
        child: Drawer(
          child: Column(children: <Widget>[
            Flexible(
                child: Image(
              image: AssetImage("assets/images/DrawerImage.PNG"),
            )),
            Padding(padding: EdgeInsets.only(top: 3)),
            SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...PAGE_DRAWER_TILES,
                      drawerSection(sectionName: 'Useful Links'),
                      ...USEFUL_LINKS_DRAWER_TILES,
                      drawerSection(sectionName: 'Social Media'),
                      ...SOCIAL_MEDIA_DRAWER_TILES
                    ]))
          ]),
        ),
      ));
}

class drawerSection extends StatelessWidget {
  const drawerSection({
    required this.sectionName,
  });

  final String sectionName;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Divider(
          height: 10,
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12, top: 10),
          child: Text(sectionName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'NeuzeitOffice',
                fontWeight: FontWeight.bold,
              )),
        )
      ]);
}

class DrawerTile extends StatelessWidget {
  final String _title;
  final Container _icon;

  DrawerTile(
      {required title, required iconFileName, double iconWidth = 20, double iconHeight = 20})
      : _title = title,
        _icon = Container(
            height: iconHeight,
            width: iconWidth,
            child: SvgPicture.asset(
              'assets/icons/' + iconFileName + '.svg',
              color: Colors.grey.shade700,
              height: iconHeight,
              width: iconWidth,
            ));

  void Navigate(BuildContext context) {
    Navigator.pushNamed(context, '/gridView', arguments: _title);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        Navigate(context);
      },
      child: ListTile(
          dense: true,
          leading: Container(child: _icon),
          title: Text(
            _title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontFamily: 'NeuzeitOffice',
              fontWeight: FontWeight.bold,
            ),
          )));
}

class ExternalLinkDrawerTile extends DrawerTile {
  final String _url;

  ExternalLinkDrawerTile(
      {required String title,
      required String iconFileName,
      required String url,
      double iconWidth = 20,
      double iconHeight = 20})
      : _url = url,
        super(
            title: title,
            iconFileName: iconFileName,
            iconWidth: iconWidth,
            iconHeight: iconHeight);

  void Navigate(BuildContext context) {
    () async {
      if (await canLaunch(_url))
        await launch(
          _url,
          forceSafariVC: false,
        );
    };
  }
}
