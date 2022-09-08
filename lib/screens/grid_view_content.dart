import 'dart:convert';

import 'package:curl_manitoba/models/apis/wordpress_api.dart';
import 'package:curl_manitoba/models/e_entry_competition.dart';
import 'package:curl_manitoba/screens/mainTabs/e_entry_screen.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class GridViewContentScreen extends StatefulWidget {
  String pageTitle;

  GridViewContentScreen(this.pageTitle);

  @override
  State<GridViewContentScreen> createState() => _GridViewContentScreenState();
}

class _GridViewContentScreenState extends State<GridViewContentScreen> {
  late WordPressAPI api;
  late Future gridViewFuture;

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
    api = WordPressAPI();
    gridViewFuture = api.call('1996');
    gridViewFuture.then(
        (response) => eEntryCompetition.parseElectronicEntryData(response));
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
