import 'package:curl_manitoba/data/repositories/word_press_repository.dart';
import 'package:curl_manitoba/domain/entities/news_story.dart';
import 'package:curl_manitoba/domain/useCases/wordpress_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/widgets/circular_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    newsStory = widget.newsStory;
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
              future: GetNewsStoryContent(WordPressRepositoryImp())(
                  '${newsStory.id}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CircularProgressBar(),
                  );
                newsStory.content = snapshot.data as String;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${newsStory.content}',
                      style: TextStyle(fontSize: 16)),
                );
              }),
        ])));
  }
}
