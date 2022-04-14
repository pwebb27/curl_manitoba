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
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8,left:8,right:8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('Sign up for our ', style: TextStyle(fontSize: 16)), GestureDetector(child: Text('newsletter', style: TextStyle(fontSize: 15, color: Colors.blue)),
                            )]),
                            ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
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
                        ]),
              ));
        });
  }
}

buildNewsStoryItem(NewsStory newsStory) {
  return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade700, width: .3),
        borderRadius: BorderRadius.circular(5.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            flex: 20,
            child: Image.network(
              newsStory.imageURL,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text(
                      newsStory.date,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ),
                  Text(newsStory.headline + '\n\n\n',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
        ]),
      ));
}
