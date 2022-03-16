import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../models/news_story.dart';
import '../widgets/circular_progress_bar.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  static const routeName = '/news';

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
          return Scaffold(
            appBar: CustomAppBar(Icon(FontAwesomePro.bars), context, 'News'),
            body: ListView.builder(
                itemBuilder: (ctx, index) {
                  NewsStory newsStory = NewsStory(
                    id: index,
                    imageURL:
                        'https://images.thestar.com/CBZVV_aqoiPFukcZjs74JNLtlF8=/1200x798/smart/filters:cb(2700061000)/https://www.thestar.com/content/dam/thestar/sports/curling/2018/02/04/manitobas-jennifer-jones-heads-to-scotties-tournament-of-hearts-final/jennifer_jones.jpg',
                    headline: titles[index],
                    author: authors[index],
                    date: dates[index],
                    content: content[index],
                  );
                  return buildNewsStoryItem(
                    newsStory,
                  );
                },
                itemCount: 8),
          );
        });
  }
}

buildNewsStoryItem(NewsStory newsStory) {
  return Card(
      child: Row(children: [
    Image.network(newsStory.imageURL, height: 30),
    Column(
      children: [Text(newsStory.date), Text(newsStory.headline)],
    )
  ]));
}
