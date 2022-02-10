import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import '../news_stories_data.dart';
import '../widgets/news_story_item.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  Iterable<String> content = [];

  static const URL = 'https://curlmanitoba.org/news-2/news-archive/';

  void _getDataFromWeb() async {
    

    final response = await http.get(Uri.parse(URL));

    final body = response.body;
    dom.Document document = parser.parse(body);
    final contentElements = document.getElementsByClassName('entry-title');
    content = contentElements.map((element) => element.getElementsByTagName("a")[0].innerHtml);
    for (var c in content){
      print(c);
    }

  }

  @override
  void initState() {
    _getDataFromWeb();
  }

  @override
  Widget build(BuildContext context) {
    for(var c in content){
      print(c);
    }
    return ListView.builder(
        itemBuilder: (ctx, index) {
          return NewsStoryItem(
            id: NEWS_STORIES[index].id,
            imageUrl: NEWS_STORIES[index].imageURL,
            title: NEWS_STORIES[index].headline,
            author: NEWS_STORIES[index].author,
            date: NEWS_STORIES[index].date,
            subtext: NEWS_STORIES[index].subtext,
          );
        },
        itemCount: NEWS_STORIES.length);
  }
}
