import 'package:curl_manitoba/models/news_story.dart';
import 'package:flutter/material.dart';

import '../screens/news_story_screen.dart';

class NewsStoryItem extends StatelessWidget {
  void selectNewsStory(BuildContext context) {
    Navigator.of(context)
        .pushNamed(NewsStoryScreen.routeName, arguments: newsStory);
  }

  final NewsStory newsStory;

  NewsStoryItem({
    required this.newsStory,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => selectNewsStory(context),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(newsStory.imageURL),
                        fit: BoxFit.cover),
                  ),
                )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                          Text(
                        newsStory.date,
                        style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        newsStory.headline,
                        style: TextStyle(fontSize: 13.0),
                      ),
  
                    ])),
              ],
            )));
  }
}
