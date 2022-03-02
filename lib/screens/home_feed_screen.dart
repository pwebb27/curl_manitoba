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

List<Widget> itemss = imgList
    .map((item) => Container(
          child: Center(child: Image.asset(item)),
        ))
    .toList();

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  List<String> CompetitionTitles = [];
  List<String> CompetitionDates = [];
  static const URL =
      'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions.json?search=&tags=&page=1';

  Future<Map<String, dynamic>> _getDataFromWeb() async {
    final response = await http.get(Uri.parse(URL));

    final body = response.body;

    Map<String, dynamic> jsonMap = json.decode(body);

    return jsonMap;
  }

  void buildContent(Map<String, dynamic> jsonMap) {
    for (int i = 0; i < 3; i++) {
      CompetitionTitles.add(
          jsonMap["paged_competitions"]["competitions"][i]["title"]);
      String startDate =
          jsonMap["paged_competitions"]["competitions"][i]["starts_on"];
      startDate = DateFormat('yMMMMd').format(DateTime.parse(startDate));
      String endDate =
          jsonMap["paged_competitions"]["competitions"][i]["ends_on"];
      endDate = DateFormat('yMMMMd').format(DateTime.parse(endDate));
      CompetitionDates.add(startDate + ' - ' + endDate);
    }
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
            buildContent(snapshot.data as Map<String, dynamic>);

          return Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      CarouselSlider(
                        items: itemss,
                        options: CarouselOptions(
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
                                  width: 9.0,
                                  height: 9.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
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
                    buildTextWidget('Competitions'),
                    for (int i = 0; i < 3; i++)
                      buildCompetitionCard(
                          context, CompetitionTitles[i], CompetitionDates[i]),
                    buildTextWidget('Latest News'),
                  ]));
        });
  }
}

buildTextWidget(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, left: 10.0),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 21.5,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

buildCompetitionCard(BuildContext context, String title, String date) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.black, Theme.of(context).primaryColor],
          )),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(children: [
            Expanded(
                flex: 6,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
            Expanded(
                flex: 4,
                child: Text(date,
                    style: TextStyle(color: Colors.white, fontSize: 15)))
          ])),
    ),
  );
}
