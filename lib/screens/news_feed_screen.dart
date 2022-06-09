import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import '../models/news_story.dart';
import '../widgets/circular_progress_bar.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  static const routeName = '/news';
  late Future<http.Response> newsStoryDataFuture;

  late List<NewsStory> newsStories;

  @override
  void initState() {
    newsStoryDataFuture = NewsStory.getNewsData(30);
    newsStoryDataFuture
        .then((value) => newsStories = NewsStory.parseNewsData(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: newsStoryDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressBar();
          return Scaffold(
              body: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Sign up for our ', style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    child: Text('newsletter',
                        style: TextStyle(fontSize: 15, color: Colors.blue)),
                  )
                ]),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return buildNewsStoryItem(
                      context,
                      newsStories[index],
                    );
                  },
                  itemCount: newsStories.length),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SvgPicture.asset('assets/icons/folder.svg', height: 30),
              ),
              Text('Looking for more news?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 13, top: 5, left: 8, right: 8.0),
                child: Text(
                  'Visit the new archive for a history of published articles',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
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
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                      ),
                    ),
                    Text(newsStory.headline + '\n\n\n',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ]),
        )),
  );
}
