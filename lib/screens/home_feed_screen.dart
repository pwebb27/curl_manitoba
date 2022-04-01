import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/screens/competitions_screen.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'competitions_screen.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';

import 'dart:convert';

import '../widgets/circular_progress_bar.dart';

class HomeFeedScreen extends StatefulWidget {
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

final List<String> imgList = [
  'assets/images/carousel-image-1.png',
  'assets/images/carousel-image-2.png',
  'assets/images/carousel-image-3.png',
  'assets/images/carousel-image-4.png'
];

Map<String, Icon> EventsProgramsAndNewsData = {
  'CurlManitoba Learn to Curl | Thistle Curling Club - March 29, 2022':
      EventsProgramsAndNewsIcons["Program"] as Icon,
  'Manitoba Curling Hall of Fame & Museum Induction Dinner Tickets':
      EventsProgramsAndNewsIcons["Event"] as Icon,
  'CurlManitoba Position on Vaccine':
      EventsProgramsAndNewsIcons["News"] as Icon,
  'New U21 and U23 Events | New events during the 2021-2022 season':
      EventsProgramsAndNewsIcons["Event"] as Icon
};

Map<String, Icon> EventsProgramsAndNewsIcons = {
  'Event': Icon(FontAwesomePro.calendar_day,
      size: 13.5, color: Colors.grey.shade700),
  'Program':
      Icon(FontAwesomePro.curling, size: 12, color: Colors.grey.shade700),
  'News': Icon(FontAwesomePro.newspaper, size: 14, color: Colors.grey.shade700)
};

List<String> titles = [];
List<String> dates = [];
List<String> authors = [];
List<String> content = [];

List<Widget> itemss = imgList
    .map((item) => Container(
          child: Center(child: Image.asset(item)),
        ))
    .toList();

List<Widget> competitionItems = [];

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  List<dynamic> competitions = [];
  List<Widget> newsStories = [];

  Future<List<dynamic>> _getDataFromWeb() async {
    const competitionURL =
        'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions.json?search=&tags=&page=1';
    const newsURL = 'https://curlmanitoba.org/news-2/news-archive/';
    var responses = await Future.wait([
      http.get(Uri.parse(competitionURL)),
      http.get(Uri.parse(newsURL)),
    ]);

    return responses;
  }

  buildCompetitionSection(
    List<dynamic> competitions,
  ) {
    List<Widget> competitionItems = [];
    for (int i = 0; i < 6; i++) {
      competitionItems.add(ListView(children: [
        buildCompetitionTile(competitions[i++]),
        buildCompetitionTile(competitions[i])
      ]));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(children: [
        CarouselSlider(
          items: competitionItems,
          options: CarouselOptions(
              height: 213,
              enableInfiniteScroll: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentCompetitionCarouselIndex = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: competitionItems.asMap().entries.map((entry) {
            return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(left: 3, right: 3),
                  decoration: _currentCompetitionCarouselIndex != entry.key
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 1, color: Colors.grey.shade700),
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade700),
                ));
          }).toList(),
        ),
      ]),
    );
  }

  void buildContent(List<dynamic> responses, BuildContext context) {
    final competitionsBody = responses[0].body;

    Map<String, dynamic> jsonMap = json.decode(competitionsBody);
    competitions = jsonMap["paged_competitions"]["competitions"];

    final body = responses[1].body;
    dom.Document document = parser.parse(body);

    final titleElements = document.getElementsByClassName('entry-title');
    titles = titleElements
        .map((element) => element.getElementsByTagName("a")[0].innerHtml)
        .toList();

    final dateElements = document.getElementsByTagName('time');
    dates = dateElements.map((element) => element.innerHtml).toList();

    final authorElements = document.getElementsByClassName('fn');
    authors = authorElements.map((element) => element.innerHtml).toList();

    final contentElements = document.getElementsByTagName("p");
    content = contentElements.map((element) => element.innerHtml).toList();

    newsStories = buildNewsStories(context);
  }

  int _currentBannerIndex = 0;
  int _currentCompetitionCarouselIndex = 0;
  final CarouselController _controller = CarouselController();

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
            buildContent(snapshot.data as List<dynamic>, context);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: itemss,
                      options: CarouselOptions(
                          autoPlayInterval: Duration(seconds: 5),
                          height: 194,
                          autoPlay: true,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentBannerIndex = index;
                            });
                          }),
                    ),
                    buildSection('Latest Competitions',
                        buildCompetitionSection(competitions)),
                    Divider(
                        height: 5, thickness: 5, color: Colors.grey.shade500),
                    buildSection(
                        'Latest News', buildNewsStorySegment(newsStories)),
                    Divider(
                        height: 5, thickness: 5, color: Colors.grey.shade500),
                    buildSection(
                        'Events, Programs & News',
                        buildEventsProgramsAndNewsSection(
                            EventsProgramsAndNewsData))
                  ]),
            ),
          );
        });
  }
}

buildEventsProgramsAndNewsSection(Map<String, Icon> EventsProgramsAndNewsData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 11),
    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      for (MapEntry e in EventsProgramsAndNewsData.entries)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.only(right: 12),
                child:
                    Padding(padding: EdgeInsets.only(top: 3), child: e.value)),
            Flexible(
                child: Text(e.key,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w500)))
          ]),
        )
    ]),
  );
}

List<Widget> buildNewsStories(BuildContext context) {
  List<Widget> newsStories = [];
  for (int i = 0; i < 4; i++) {
    newsStories.add(
      buildNewsStoryItem(
          NewsStory(
              id: 0,
              headline: titles[i],
              imageURL:
                  'https://images.thestar.com/CBZVV_aqoiPFukcZjs74JNLtlF8=/1200x798/smart/filters:cb(2700061000)/https://www.thestar.com/content/dam/thestar/sports/curling/2018/02/04/manitobas-jennifer-jones-heads-to-scotties-tournament-of-hearts-final/jennifer_jones.jpg',
              date: dates[i],
              author: authors[i],
              content: content[i]),
          context),
    );
  }
  return newsStories;
}

Widget buildNewsStorySegment(List<Widget> newsStories) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 6),
    child: GridView.count(
        shrinkWrap: true,
        childAspectRatio: 13 / 16,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(newsStories.length, (index) {
          return newsStories[index];
        })),
  );
}

Widget buildSection(String sectionName, Widget section) {
  return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 11.5, left: 10.0, bottom: 2),
          child: Text(
            sectionName,
            style: TextStyle(
              fontSize: 19.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        section
      ]));
}

void selectNewsStory(BuildContext context, NewsStory newsStory) {
  Navigator.of(context).pushNamed('/newsStory', arguments: newsStory);
}

@override
Widget buildNewsStoryItem(NewsStory newsStory, BuildContext context) {
  return InkWell(
      onTap: () => selectNewsStory(context, newsStory),
      child: Card(
          margin: EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade700, width: .3),
            borderRadius: BorderRadius.circular(5.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(newsStory.imageURL),
                          fit: BoxFit.cover),
                    ),
                  )),
              Expanded(
                flex: 7,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              newsStory.date,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ),
                          Text(
                            newsStory.headline,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13.5, fontWeight: FontWeight.bold),
                          ),
                        ])),
              ),
            ],
          )));
}
