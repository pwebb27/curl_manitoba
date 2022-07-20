import 'package:curl_manitoba/models/calendar_event.dart';
import 'package:curl_manitoba/models/news_story.dart';
import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/widgets/competition_tile.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:http/http.dart' as http;

import '../../../widgets/circular_progress_bar.dart';

class HomeFeedScreen extends StatefulWidget {
  List<scoresCompetition> loadedCompetitions;
  List<NewsStory> loadedNews;
  HomeFeedScreen(this.loadedCompetitions, this.loadedNews);

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

const List<String> imgList = [
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

List<Widget> itemss = imgList
    .map((item) => Container(
          child: Center(child: Image.asset(item)),
        ))
    .toList();

List<Widget> competitionItems = [];

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  late List<scoresCompetition> loadedCompetitions;
  late List<NewsStory> loadedNews;
  late Map<DateTime, List<CalendarEvent>> calendarEvents;

  late Future<List<http.Response>> homeFeedFuture;

  Future<List<http.Response>> _getDataFromWeb() async {
    var responses = await Future.wait([
      CalendarEvent.getCalendarData(),
    ]);

    return responses;
  }

  buildCompetitionSection(
    List<scoresCompetition> competitions,
  ) {
    List<Widget> competitionItems = [];
    for (int i = 0; i < 6; i++) {
      competitionItems.add(ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            CompetitionTile(competitions[i++]),
            CompetitionTile(competitions[i])
          ]));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
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

  int _currentBannerIndex = 0;
  int _currentCompetitionCarouselIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    loadedCompetitions = widget.loadedCompetitions;
    loadedNews = widget.loadedNews;
    homeFeedFuture = _getDataFromWeb();

    homeFeedFuture.then((responses) {
      calendarEvents = CalendarEvent.parseCalendarData(responses[0]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: homeFeedFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressBar();
          }
          return SafeArea(
            top: false,
            bottom: false,
            child: Builder(
                builder: (context) => SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                buildCompetitionSection(loadedCompetitions)),
                            Divider(
                                height: 5,
                                thickness: 5,
                                color: Colors.grey.shade500),
                            buildSection('Latest News',
                                buildNewsStorySegment(loadedNews, context)),
                            Divider(
                                height: 5,
                                thickness: 5,
                                color: Colors.grey.shade500),
                            buildSection(
                                'Upcoming Events', buildEventsSection()),
                            Divider(
                                height: 5,
                                thickness: 5,
                                color: Colors.grey.shade500),
                            buildSection(
                                'Events, Programs & News',
                                buildEventsProgramsAndNewsSection(
                                    EventsProgramsAndNewsData)),
                          ]),
                    )),
          );
        });
  }
}

buildEventsSection() {
  return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: ((context, index) => buildEvent()));
}

buildEvent() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    child: Column(children: [
      ExpansionTile(
        tilePadding: EdgeInsets.only(left: 5),
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(3)),
          child: Container(
              child: Column(children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text('MAR',
                    style:
                        TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
              ),
              color: Colors.grey,
            ),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  '22',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Text('Wed', style: TextStyle(fontSize: 8))
            ])
          ])),
        ),
        title: Text(
          'Souris 22nd Annual 3rd times a charm “mini” Survivor Bonspiel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('April 28, 2022 - April 29, 2022'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Entry Fee: Mens & Ladies & Masters Mens (minimum combined age: 240) - 160.00 Mens/Ladies - Curl evenings and weekend starting Wednesday/ThursdayMasters Mens - Curl Monday and Tuesday Register and pay online at souriscurling.com All games will be in the curling club this year Mail entries to: Survivor Bonspiel, Box 771, Souris, MB R0K 2C0 Cheques payable to: Souris Curling Club Survivor Have questions? Mens - 204-483-3669 OR Ladies - Karen at 204-483-3534 Only entries that are accompanied by a cheque or online payment guarantee a spot OR souriscurling@mymts.net'),
          )
        ],
      ),
    ]),
  );
}

buildEventsProgramsAndNewsSection(Map<String, Icon> EventsProgramsAndNewsData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        TextStyle(fontSize: 15.5, fontWeight: FontWeight.w500)))
          ]),
        )
    ]),
  );
}

Widget buildNewsStorySegment(
    List<NewsStory> newsStories, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 3.5),
    child: GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        childAspectRatio: 13 / 16,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(4, (index) {
          return buildNewsStoryItem(newsStories[index], context);
        })),
  );
}

Widget buildSection(String sectionName, Widget section) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
  ]);
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
                  child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(newsStory.imageURL),
                      fit: BoxFit.cover),
                ),
              )),
              Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 10, left: 9, right: 9),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Text(
                            newsStory.date,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ),
                        Text(
                          newsStory.headline + '\n\n\n',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13.5, fontWeight: FontWeight.bold),
                        ),
                      ])),
            ],
          )));
}
