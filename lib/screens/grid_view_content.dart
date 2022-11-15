import 'dart:convert';
import 'package:curl_manitoba/apis/wordpress_api.dart';
import 'package:curl_manitoba/providers/clients/wordpressClient.dart';
import 'package:curl_manitoba/widgets/circular_progress_bar.dart';
import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GridViewContentScreen extends StatefulWidget {
  final String pageTitle;

  GridViewContentScreen(this.pageTitle);

  @override
  State<GridViewContentScreen> createState() => _GridViewContentScreenState();
}

class _GridViewContentScreenState extends State<GridViewContentScreen> {
  String? pageContent;
  late final WordPressApi _wordPressApi;
  late final String pageTitle;

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
    _wordPressApi = WordPressApi()
      ..client =
          Provider.of<WordPressClientProvider>(context, listen: false).getClient();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: CustomAppBar(
        context,
        pageTitle,
      ),
      body: FutureBuilder(
          future: _wordPressApi.fetchPage('1996'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return SliverFillRemaining(
                  child: Center(child: CircularProgressBar()));
            http.Response wordPressPageResponse =
                snapshot.data as http.Response;
            final document = parse((json.decode(wordPressPageResponse.body)
                as Map<String, dynamic>)['content']['rendered']);
            pageContent = parse(document.body!.text).documentElement!.text;
            return Text(pageContent!);
          }));
}
