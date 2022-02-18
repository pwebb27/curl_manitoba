import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import '../news_stories_data.dart';
import '../widgets/custom_app_bar.dart';

class NewsStoryScreen extends StatelessWidget {
  static const routeName = '/news-story';

  static const URL = 'https://curlmanitoba.org/news-2/news-archive/';

  Future<dom.Document> _getDataFromWeb() async {
    final response = await http.get(Uri.parse(URL));

    final body = response.body;
    dom.Document document = parser.parse(body);

    return document;
  }


  void goBack(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    
    final newsStoryId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedNewsStory =
        NEWS_STORIES.firstWhere((newsStory) => newsStory.id == newsStoryId);
    return Scaffold(
        appBar: CustomAppBar(Icon(Icons.arrow_back, size: 25), context,""),
        body: Column(
          children: <Widget>[
            Container(
              child:
                  Image.network(selectedNewsStory.imageURL, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${selectedNewsStory.headline}',
                        style: TextStyle(fontSize: 22, height: 1.2),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.solidUser,
                                size: 10,
                                color: Theme.of(context).primaryColor),
                            SizedBox(width: 5),
                            Text('${selectedNewsStory.author} Test',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('${selectedNewsStory.date}'),
                    ],
                  )),
            )
          ],
        ));
  }
}
