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

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({Key? key}) : super(key: key);

  @override
  _CompetitionScreenState createState() => _CompetitionScreenState();
}

List<String> competitionTags = [
  'Under 18',
  'Mens',
  'Womens',
  'Mixed',
  'Mixed Doubles',
  'U 21 Junior',
  'Curling Club',
  'Seniors',
  'Masters',
  'Youth',
];
List<dynamic> competitions = [];

Future<List<dynamic>> _getDataFromWeb() async {
  const competitionURL =
      'https://legacy-curlingio.global.ssl.fastly.net/api/organizations/MTZFJ5miuro/competitions.json?search=&tags=&page=1';
  const newsURL = 'https://curlmanitoba.org/news-2/news-archive/';
  var responses = await Future.wait([
    http.get(Uri.parse(competitionURL)),
    http.get(Uri.parse(newsURL)),
  ]);

  buildContent(responses);
  return responses;
}

void buildContent(List<dynamic> responses) {
  final competitionsBody = responses[0].body;

  Map<String, dynamic> jsonMap = json.decode(competitionsBody);
  competitions = jsonMap["paged_competitions"]["competitions"];
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  static const routeName = '/competitions';
  bool selected = false;

  filterCompetitions() {}

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
          return Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
              child: Container(
                  child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 15,
                      children: [
                    for (String tag in competitionTags)
                      FilterChip(
                          label: Text(tag),
                          onSelected: (bool value) {
                            selected = value;
                          }),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                color: Theme.of(context).primaryColor,
                thickness: .75,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return buildCompetitionTile(
                        competitions[index],
                      );
                    },
                    itemCount: 8),
              ),
            ),
          ]);
        });
  }

  buildCompetitionTile(Map competition) {
    return ListTile(
        title: Text(competition["title"]),
        subtitle: Text(DateFormat('LLL d, y')
                .format(DateTime.parse(competition['starts_on'])) +
            ' - ' +
            DateFormat('LLL d, y')
                .format(DateTime.parse(competition['ends_on']))));
  }
}
