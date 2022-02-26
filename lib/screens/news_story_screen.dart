import 'package:curl_manitoba/models/news_story.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';


import '../widgets/custom_app_bar.dart';

class NewsStoryScreen extends StatefulWidget {
  static const routeName = '/news-story';

  static const URL = 'https://curlmanitoba.org/news-2/news-archive/';

  @override
  State<NewsStoryScreen> createState() => _NewsStoryScreenState();
}

class _NewsStoryScreenState extends State<NewsStoryScreen> {
  Future<dom.Document> _getDataFromWeb(String url) async {
    final response = await http.get(Uri.parse(url));

    final body = response.body;
    dom.Document document = parser.parse(body);

    return document;
  }

  @override void initState() {
    // TODO: implement initState
     NewsStory selectedNewsStory = ModalRoute.of(context)!.settings.arguments as NewsStory;
     
     String urlDate = DateFormat.yMd().format(DateTime.parse(selectedNewsStory.date));
     String urlHeadline = selectedNewsStory.headline.replaceAll(' ', '-');
     String url = 'https://curlmanitoba.org/2022/' + urlDate + urlHeadline;
     print(url);
     
    _getDataFromWeb(url);

    super.initState();
  }

  void goBack(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    
    final selectedNewsStory = ModalRoute.of(context)!.settings.arguments as NewsStory;
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