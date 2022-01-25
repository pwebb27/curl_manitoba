import 'package:flutter/material.dart';

import '../screens/news_story_screen.dart';

class NewsStoryItem extends StatelessWidget {
  void selectNewsStory(BuildContext context) {
    Navigator.of(context).pushNamed(NewsStoryScreen.routeName, arguments: id);
  }

  final String id;
  final String title;
  final String imageUrl;
  final String author;
  final String date;
  final String subtext;

  NewsStoryItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.author,
      required this.date,
      required this.subtext});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => selectNewsStory(context),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Stack(children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.network(imageUrl,
                        height: 200, width: double.infinity, fit: BoxFit.cover))
              ]),
              Padding(
                  padding: EdgeInsets.only(left: 13, right: 13),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: Text(
                            '$title',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(Icons.person, size: 15, color: Theme.of(context).primaryColor,),
                              Text(' $author  |  $date',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.5,
                                      color: Theme.of(context).primaryColor)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text('$subtext',
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 12.5, fontWeight: FontWeight.w400)),
                        )
                      ]))
            ])));
  }
}
