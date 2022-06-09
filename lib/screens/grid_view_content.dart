import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';

class GridViewContentScreen extends StatefulWidget {
  String pageTitle;

  GridViewContentScreen(this.pageTitle);

  @override
  State<GridViewContentScreen> createState() => _GridViewContentScreenState();
}

class _GridViewContentScreenState extends State<GridViewContentScreen> {
  
  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
  }

  late String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
         
          context,
          pageTitle,
        ),
        body: null);
  }
}
