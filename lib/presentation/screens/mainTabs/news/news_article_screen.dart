import 'dart:convert';

import 'package:curl_manitoba/apis/wordpress_api.dart';
import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/presentation/widgets/circular_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/custom_app_bar.dart';

class NewsStoryScreen extends StatefulWidget {
  final NewsStory newsStory;
  NewsStoryScreen(this.newsStory);
  static const routeName = '/news-story';

  @override
  State<NewsStoryScreen> createState() => _NewsStoryScreenState();
}

class _NewsStoryScreenState extends State<NewsStoryScreen> {
  late NewsStory newsStory;
  late Future<http.Response> _newsArticleFuture;
  late WordPressApi _wordPressApi;

  @override
  void initState() {
    newsStory = widget.newsStory;
    _newsArticleFuture = _wordPressApi.fetchPost('${newsStory.id}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(context, ""),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            child: Image.network(newsStory.imageURL, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${newsStory.headline}',
                      style: TextStyle(
                          fontSize: 23,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(FontAwesomeIcons.solidUser,
                              size: 14, color: Theme.of(context).primaryColor),
                          SizedBox(width: 5),
                          Text('${newsStory.author}',
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    Text(newsStory.formattedPublishedDate),
                  ],
                )),
          ),
          FutureBuilder(
              future: _newsArticleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CircularProgressBar(),
                  );
                http.Response newsArticleResponse =
                    snapshot.data as http.Response;
                final document = parse(json
                    .decode(newsArticleResponse.body)['content']['rendered']);

                newsStory.content =
                    parse(document.body!.text).documentElement!.text;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${newsStory.content}',
                      style: TextStyle(fontSize: 16)),
                );
              }),
        ])));
  }
}
