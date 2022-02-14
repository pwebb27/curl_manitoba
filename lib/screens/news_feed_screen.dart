import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../news_stories_data.dart';
import '../widgets/news_story_item.dart';
import '../widgets/circular_progress_bar.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List<String> titles = [];
  List<String> dates = [];
  List<String> authors = [];
  List<String> content = [];

  static const URL = 'https://curlmanitoba.org/news-2/news-archive/';

  Future<dom.Document> _getDataFromWeb() async {
    final response = await http.get(Uri.parse(URL));

    final body = response.body;
    dom.Document document = parser.parse(body);

    return document;
  }

  void buildContent(dom.Document document) {
    final titleElements = document.getElementsByClassName('entry-title');
    titles = titleElements
        .map((element) => element.getElementsByTagName("a")[0].innerHtml)
        .toList();

    final dateElements = document.getElementsByTagName('time');
    dates = dateElements.map((element) => element.innerHtml).toList();

    final authorElements = document.getElementsByClassName('fn');
    authors = authorElements.map((element) => element.innerHtml).toList();

    final contentElements = document.getElementsByTagName("p");
    content = contentElements.map((element) => element.innerHtml).toList();
  }

  @override
  void initState() {
    _getDataFromWeb();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDataFromWeb(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressBar();
          } else
            buildContent(snapshot.data as dom.Document);
            return ListView.builder(
                itemBuilder: (ctx, index) {
                  return NewsStoryItem(
                    id: NEWS_STORIES[index].id,
                    imageUrl: NEWS_STORIES[index].imageURL,
                    title: titles[index],
                    author: authors[index],
                    date: dates[index],
                    subtext: content[index],
                  );
                },
                itemCount: 2);
        });
  }
}
