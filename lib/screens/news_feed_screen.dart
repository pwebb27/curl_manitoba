import 'dart:convert';

import 'package:curl_manitoba/widgets/custom_app_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter_svg/flutter_svg.dart';

import '../models/news_story.dart';
import '../widgets/circular_progress_bar.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  static const routeName = '/news';

  List<NewsStory> newsStories = [];

  static const URL = 'https://curlmanitoba.org/wp-json/wp/v2/posts?_fields=id,title,date,author';

Future<List<dynamic>> _getDataFromWeb() async {
 var response = await 
    http.get(Uri.parse(URL));
  
  return json.decode(response.body);
}

  void buildContent(List<dynamic> posts) {
    posts.forEach((post) { 
      newsStories.add(NewsStory.fromJson(post));
    });
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
            buildContent(snapshot.data as List<dynamic>);
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
                    return buildNewsStoryItem(context,
                      newsStories[index],
                    );
                  },
                  itemCount: newsStories.length),
                  Divider(),
                  SvgPicture.asset('assets/icons/folder.svg'),
                  Text('Looking for more news?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13, top: 5, left: 8, right: 8.0),
                    child: Text('Visit the new archive for a history of published articles',textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
                  )
                        ]),
              ));
        });
  }
}

buildNewsStoryItem(BuildContext context, NewsStory newsStory) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, '/newsStory', arguments: newsStory);
    },
    child: Card(
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
                newsStory.imageURL as String,
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
        )),
  );
}
