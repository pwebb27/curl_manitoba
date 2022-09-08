import 'dart:convert';

import 'package:curl_manitoba/models/apis/wordpress_api.dart';
import 'package:curl_manitoba/models/e_entry_competition.dart';
import 'package:curl_manitoba/screens/mainTabs/e_entry_screen.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import 'package:http/http.dart' as http;

class GridViewContentScreen extends StatefulWidget {
  String pageTitle;

  GridViewContentScreen(this.pageTitle);

  @override
  State<GridViewContentScreen> createState() => _GridViewContentScreenState();
}

class _GridViewContentScreenState extends State<GridViewContentScreen> {
  String? pageContent;

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;

    _getDataFromWeb();
  }

  Future<Map<String, dynamic>> _getDataFromWeb() async {
    WordPressAPI api = WordPressAPI();
    http.Response response = await api.fetchPage('1996');

    return json.decode(response.body);
  }

  void buildContent(Map<String, dynamic> contentMap) {
    final document = parse(contentMap['content']['rendered']);
    pageContent = parse(document.body!.text).documentElement!.text;
  }

  late String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          context,
          pageTitle,
        ),
        body: FutureBuilder(
            future: _getDataFromWeb(),
            builder: (context, snapshot) {
              buildContent(snapshot.data as Map<String, dynamic>);
              return Text(pageContent!);
            }));
  }
}
