import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  late Icon icon;

  ///Boolean that determines whether a tabbar is required or not
  late final BuildContext context;
  late final String pageTitle;
  late final bool searchBar;

  @override
  Size get preferredSize =>
      //Determine the size of AppBar based on whether or not a tabbar exists
      (searchBar) ? Size.fromHeight(98) : Size.fromHeight(50);

  CustomAppBar(BuildContext context, String pageTitle,
      [bool searchBar = false]) {
    this.searchBar = searchBar;
    this.context = context;
    this.pageTitle = pageTitle;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        child: AppBar(
            leading: Builder(
                builder: (context) => IconButton(
                    icon: Icon(FontAwesomePro.bars, size: 24),
                    onPressed: () => Scaffold.of(context).openDrawer())),
            backgroundColor: Theme.of(context).primaryColor,
            title: pageTitle!=''?Text(
              pageTitle,
              style: TextStyle(
                  fontSize: 20.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ):buildAppBarImage(),
            bottom: searchBar ? buildSearchBar() : null));
  }

  buildSearchBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(10),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            height: 38,
            alignment: Alignment.center,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.search),
                  isCollapsed: true,
                  hintText: 'Search by name or location'),
            )),
      ),
    );
  }

  buildAppBarImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 1.5),
      child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
          height: 24, fit: BoxFit.cover),
    );
  }
}
