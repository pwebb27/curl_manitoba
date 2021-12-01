import 'package:flutter/material.dart';
import '../news_stories_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsStoryScreen extends StatelessWidget {
  static const routeName = '/news-story';

  void goBack(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final newsStoryId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedNewsStory =
        NEWS_STORIES.firstWhere((newsStory) => newsStory.id == newsStoryId);
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )),
          backgroundColor: Theme.of(context).primaryColor,
          title: Padding(
              padding: EdgeInsets.only(right: 150, left: 0),
              child: Image.asset('assets/images/Curl_Manitoba_Logo.png',
                  fit: BoxFit.cover)),
        ),
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
