import 'package:url_launcher/link.dart';

import '../../../models/tweet.dart';
import '../../../apis/twitter_api.dart';
import '../../../widgets/circular_progress_bar.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:linkfy_text/linkfy_text.dart';

class TwitterFeedScreen extends StatefulWidget {
  @override
  TwitterFeedScreenState createState() => TwitterFeedScreenState();
}

class TwitterFeedScreenState extends State<TwitterFeedScreen> {
  late TwitterApi _twitterApi;
  late Future _twitterApiDataFuture;
  late List<Tweet> _tweets;

  @override
  void initState() {
    super.initState();
    _tweets = [];
    _twitterApi = TwitterApi();
    _twitterApiDataFuture = _twitterApi.fetchTweets();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _twitterApiDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SliverFillRemaining(
              child: Center(child: CircularProgressBar()));
        _tweets = Tweet.parseTweetData(snapshot.data as http.Response);
        return CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                ((_, index) => TweetItem(_tweets[index])),
                childCount: _tweets.length),
          )
        ]);
      });
}

class TweetItem extends StatelessWidget {
  final Tweet tweet;

  TweetItem(this.tweet);

  @override
  Widget build(BuildContext context) => InkWell(
      child: Container(
    color: Colors.grey.shade400,
    child: Card(
        margin: EdgeInsets.only(bottom: 4),
        child: Container(
          padding: const EdgeInsets.only(
              left: 7, right: 7, bottom: 24, top: 12),
          child: Column(children: [
            if (tweet.isRetweet)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomePro.retweet,
                      size: 15, color: Colors.grey.shade700),
                  Text('   Curl Manitoba retweeted',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700)),
                ],
              ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 6),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          tweet.profilePicURL!,
                          height: 38,
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tweet.handle!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(tweet.timeAgo!)
                    ],
                  )
                ],
              ),
            ),
            if (tweet.text != null)
              LinkifyText(
                tweet.text!,
                linkStyle: TextStyle(color: Colors.blue),
                linkTypes: [
                  LinkType.email,
                  LinkType.url,
                  LinkType.hashTag,
                  LinkType.userTag
                ],
                onTap: (link) async {
                  if (link.value![0] == '#')
                    await launch(
                        'https://twitter.com/hashtag/${link.value!.substring(1)}?src=hashtag_click');
                  else if (link.value![0] == '@')
                    await launch('https://twitter.com/${link.value!.substring(1)}');
                  await launch(link.value!);
                },
              ),
            if (tweet.mediaURL != "")
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Image.network(tweet.mediaURL!),
              )
          ]),
        )),
  ));
}
