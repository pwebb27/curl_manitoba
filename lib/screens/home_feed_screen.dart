
import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

Map<String, IconData> EventsProgramsAndNewsData = {
  'CurlManitoba Learn to Curl | Thistle Curling Club - March 29, 2022':
      FontAwesomePro.curling,
  'Manitoba Curling Hall of Fame & Museum Induction Dinner Tickets':
      FontAwesomePro.newspaper,
  'CurlManitoba Position on Vaccine': FontAwesomePro.newspaper,
  'New U21 and U23 Events | Two new events during the 2021-2022 season':
      FontAwesomePro.calendar_day
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

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  List<String> competitionTitles = [];
  List<String> competitionStartDates = [];
  List<String> competitionEndDates = [];
  List<String> competitionIDs = [];
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

  void buildContent(List<dynamic> responses, BuildContext context) {
    final competitionsBody = responses[0].body;

    Map<String, dynamic> jsonMap = json.decode(competitionsBody);

    for (int i = 0; i < 3; i++) {
      competitionIDs.add(
          jsonMap["paged_competitions"]["competitions"][i]["id"].toString());
      competitionTitles
          .add(jsonMap["paged_competitions"]["competitions"][i]["title"]);
      String startDate =
          jsonMap["paged_competitions"]["competitions"][i]["starts_on"];
      startDate = DateFormat('LLL d').format(DateTime.parse(startDate));
      String endDate =
          jsonMap["paged_competitions"]["competitions"][i]["ends_on"];
      endDate = DateFormat('LLL d').format(DateTime.parse(endDate));
      competitionStartDates.add(startDate);
      competitionEndDates.add(endDate);
    }

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

  int _current = 0;
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
              padding: const EdgeInsets.only(top: 5.0, bottom: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      CarouselSlider(
                        items: itemss,
                        options: CarouselOptions(
                            autoPlayInterval: Duration(seconds: 5),
                            height: 233,
                            autoPlay: true,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      Positioned(
                        bottom: 6,
                        child: Row(
                          children: itemss.asMap().entries.map((entry) {
                            return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 4.0),
                                  decoration: _current != entry.key
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              width: 1, color: Colors.white),
                                        )
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.white),
                                ));
                          }).toList(),
                        ),
                      )
                    ]),
                    wrapSectionInCard(
                        'Competitions',
                        buildCompetitionSection(
                            context,
                            competitionTitles,
                            competitionEndDates,
                            competitionStartDates,
                            competitionIDs)),
                    wrapSectionInCard(
                        'Latest News', buildNewsStorySegment(newsStories)),
                    wrapSectionInCard(
                        'Events, Programs & News',
                        buildEventsProgramsAndNewsSection(
                            EventsProgramsAndNewsData))
                  ]),
            ),
          );
        });
  }
}

buildEventsProgramsAndNewsSection(
    Map<String, IconData> EventsProgramsAndNewsData) {
  return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
    for (MapEntry e in EventsProgramsAndNewsData.entries)
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(right: 12),
              child: Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(e.value, size: 15, color: Colors.grey.shade700))),
          Flexible(
              child: Text(e.key,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)))
        ]),
      )
  ]);
}

buildCompetitionSection(BuildContext context, List<String> titles,
    List<String> startDates, List<String> endDates, List<String> IDs) {
  return Column(children: <Widget>[
    for (int i = 0; i < 3; i++)
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.black, Theme.of(context).primaryColor],
              )),
          child: Padding(
              padding: EdgeInsets.all(9),
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .pushNamed('/scores', arguments: IDs[i]),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 7,
                          child: Text(
                            titles[i],
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Expanded(
                            flex: 3,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(startDates[i] + ' - ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                  Text(endDates[i],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)),
                                ])),
                      )
                    ]),
              )),
        ),
      ),
  ]);
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
  return GridView.count(
      shrinkWrap: true,
      primary: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(newsStories.length, (index) {
        return newsStories[index];
      }));
}

Widget wrapSectionInCard(String sectionName, Widget section) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade800, width: .3),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10.0),
                      child: Text(
                        sectionName,
                        style: TextStyle(
                            fontSize: 21.5,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    section
                  ]))));
}

void selectNewsStory(BuildContext context, NewsStory newsStory) {
  Navigator.of(context).pushNamed('/newsStory', arguments: newsStory);
}

@override
Widget buildNewsStoryItem(NewsStory newsStory, BuildContext context) {
  return InkWell(
      onTap: () => selectNewsStory(context, newsStory),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            newsStory.date,
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        Text(
                          newsStory.headline,
                          style: TextStyle(
                              fontSize: 13.0, fontWeight: FontWeight.bold),
                        ),
                      ])),
            ],
          )));
}
