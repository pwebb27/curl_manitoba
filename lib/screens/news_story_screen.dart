import 'dart:convert';

import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/widgets/circular_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import '../widgets/custom_app_bar.dart';

class NewsStoryScreen extends StatefulWidget {
  NewsStory newsStory;
  NewsStoryScreen(this.newsStory);
  static const routeName = '/news-story';

  @override
  State<NewsStoryScreen> createState() => _NewsStoryScreenState();
}

class _NewsStoryScreenState extends State<NewsStoryScreen> {
  late NewsStory newsStory;

  void buildContent(Map<String, dynamic> contentMap) {
    final document = parse(contentMap['content']['rendered']);

    newsStory.content = parse(document.body!.text).documentElement!.text;
  }

  Future<Map<String, dynamic>> _getDataFromWeb() async {
    String URL = 'https://curlmanitoba.org/wp-json/wp/v2/posts/' +
        newsStory.id.toString() +
        '?_fields=content';

    var response = await http.get(Uri.parse(URL));
    return json.decode(response.body);
  }

  @override
  void initState() {
    newsStory = widget.newsStory;
    _getDataFromWeb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(Icon(Icons.arrow_back, size: 25), context, ""),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            child: Image.network(newsStory.imageURL, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${newsStory.headline}',
                      style: TextStyle(
                          fontSize: 23,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.solidUser,
                              size: 14, color: Theme.of(context).primaryColor),
                          SizedBox(width: 5),
                          Text('${newsStory.author}',
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    Text('${newsStory.date}'),
                  ],
                )),
          ),
          FutureBuilder(
              future: _getDataFromWeb(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CircularProgressBar(),
                  );
                } else
                  buildContent(snapshot.data as Map<String, dynamic>);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${newsStory.content}',
                      style: TextStyle(fontSize: 16)),
                );
              }),
        ])));
  }
}
