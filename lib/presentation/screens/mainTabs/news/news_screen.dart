import 'package:curl_manitoba/data/repositories/word_press_repository.dart';
import 'package:curl_manitoba/domain/useCases/wordpress_repository_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

import '../../../../domain/entities/news_story.dart';
import '../../../widgets/circular_progress_bar.dart';

class NewsFeedScreen extends StatefulWidget {
  NewsFeedScreen(this.loadedNews);
  final List<NewsStory> loadedNews;

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  static const routeName = '/news';
  late List<NewsStory> preloadedNews;

  @override
  void initState() {
    preloadedNews = widget.loadedNews;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
            child: new RichText(
              text: new TextSpan(children: [
                new TextSpan(
                  text: 'Sign up for our ',
                  style:
                      new TextStyle(color: Colors.grey.shade800, fontSize: 17),
                ),
                new TextSpan(
                  text: 'newsletter',
                  style: new TextStyle(color: Colors.blue, fontSize: 17),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                          context: context, builder: (context) => PopUp());
                    },
                ),
              ]),
              textAlign: TextAlign.center,
            )),
        buildNewsWidgets(preloadedNews),
        FutureBuilder(
          future:
              GetNewsStoryPosts(WordPressRepositoryImp())(amountOfPosts: 22),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressBar();
            return buildNewsWidgets(snapshot.data as List<NewsStory>);
          },
        ),
        buildEndOfScrollMessage()
      ]),
    ));
  }

  buildNewsWidgets(List<NewsStory> newsStories) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return buildNewsStoryItem(
            context,
            newsStories[index],
          );
        },
        itemCount: newsStories.length);
  }

  buildEndOfScrollMessage() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: <Widget>[
          Expanded(child: Divider(thickness: 2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SvgPicture.asset(
              'assets/icons/magnifying-glass-plus.svg',
              height: 42,
              color: Colors.blue,
            ),
          ),
          Expanded(child: Divider(thickness: 2)),
        ]),
      ),
      Text('Looking for older stories?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      Padding(
          padding:
              const EdgeInsets.only(bottom: 13, top: 5, left: 8, right: 8.0),
          child: new RichText(
            text: new TextSpan(children: [
              new TextSpan(
                text: 'Visit the ',
                style: new TextStyle(color: Colors.grey.shade800, fontSize: 17),
              ),
              new TextSpan(
                text: 'news archive',
                style: new TextStyle(color: Colors.blue, fontSize: 17),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://curlmanitoba.org/news-2/news-archive/');
                  },
              ),
              new TextSpan(
                text: ' for a history of published articles',
                style: new TextStyle(color: Colors.grey.shade800, fontSize: 17),
              ),
            ]),
            textAlign: TextAlign.center,
          ))
    ]);
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
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                          newsStory.formattedPublishedDate,
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
}

class PopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AlertDialog(
          contentPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 145),
          content: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                    top: -55,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 38,
                    )),
                Positioned(
                  top: -42,
                  child: SvgPicture.asset('assets/icons/envelope-open-text.svg',
                      color: Colors.white, height: 46),
                ),
                Positioned(
                  right: 0,
                  child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/xmark.svg',
                        color: Colors.grey.shade500,
                        height: 25,
                      )),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Text('Join our newsletter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Receive e-newsletters twice monthly during the curling season and monthly in the off season to keep informed about programs, services and events happening within CurlManitoba.',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          NewsletterFormField('First name'),
                          NewsletterFormField('Last name'),
                          NewsletterFormField('Email address'),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, top: 5),
                            child: ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Subscribe',
                                  style: TextStyle(fontSize: 18),
                                )),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'Your privacy is very important to CurlManitoba. Information will not be shared and is only accessible to CurlManitoba.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ])),
    ]);
  }
}

class NewsletterFormField extends StatelessWidget {
  final String hintText;

  NewsletterFormField(this.hintText);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 7.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          height: 40,
          alignment: Alignment.center,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                    isCollapsed: true,
                    hintText: hintText),
              )),
        ));
  }
}
