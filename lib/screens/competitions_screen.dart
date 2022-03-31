import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:search_widget/search_widget.dart';

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

buildCompetitionTile(Map competition) {
  return Card(
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey.shade700, width: .3),
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 1.5,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(competition["title"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.5),
                  child: Icon(FontAwesomePro.calendar_range,
                      size: 10, color: Colors.grey.shade700),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    DateFormat('LLL d, y').format(
                          DateTime.parse(competition['starts_on']),
                        ) +
                        ' - ' +
                        DateFormat('LLL d, y')
                            .format(DateTime.parse(competition['ends_on'])),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ]),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.5),
                  child: Icon(FontAwesomePro.location_dot,
                      size: 10, color: Colors.grey.shade700),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(getVenue(competition),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)))
              ])
            ]),
            Image.network(
              competition["logo"],
              height: 30,
            ),
          ]),
        ),
      ]),
    ),
  );
}

String getVenue(Map competition) {
  if (competition["venue"] != null && competition["venue"] != "")
    return competition["venue"];

  String indexOfString = 'played at the ';

  if ((competition["notes"] as String).lastIndexOf(indexOfString) != -1)
    return (competition["notes"] as String).substring(
        (competition["notes"] as String).lastIndexOf(indexOfString) +
            indexOfString.length,
        (competition["notes"] as String).length);

  indexOfString = 'played at ';

  if ((competition["notes"] as String).lastIndexOf(indexOfString) != -1)
    return (competition["notes"] as String).substring(
        (competition["notes"] as String).lastIndexOf(indexOfString) +
            indexOfString.length,
        (competition["notes"] as String).length);

  indexOfString = 'hosted by ';

  if ((competition["notes"] as String).lastIndexOf(indexOfString) != -1)
    return (competition["notes"] as String).substring(
        (competition["notes"] as String).lastIndexOf(indexOfString) +
            indexOfString.length,
        (competition["notes"] as String).length);

  return 'Location TBA';
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
    return Column(children: [
      Padding(
          padding:
              const EdgeInsets.only(top: 17, bottom: 12, left: 11, right: 11),
          child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              spacing: 15,
              children: [
                for (String tag in competitionTags)
                  ChoiceChip(
                      selected: false,
                      selectedColor: Theme.of(context).primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(tag),
                      onSelected: (bool value) {
                        selected = value;
                      }),
              ])),
      Divider(thickness: 1, height: 1),
      FutureBuilder(
          future: _getDataFromWeb(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressBar());
            } else
              buildContent(snapshot.data as List<dynamic>);
            return Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, left: 5, right: 5),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return buildCompetitionTile(competitions[index]);
                      },
                      itemCount: 8),
                ),
              ),
            );
          }),
    ]);
  }
}
