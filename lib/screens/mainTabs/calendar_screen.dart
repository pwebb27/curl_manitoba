import 'package:curl_manitoba/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

class CalendarScreen extends StatefulWidget {
  final Map<DateTime, List<CalendarEvent>> preloadedEvents;
  CalendarScreen(this.preloadedEvents);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  final ScrollController scrollController = ScrollController();

  late Future<http.Response> calendarDataFuture;

  late DateTime _selectedDay;
  late List<CalendarEvent> selectedEvents;

  @override
  void initState() {
    super.initState();
    selectedEvents = [];
    _selectedDay = DateUtils.dateOnly(DateTime.now());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildTableCalendar(context),
        Divider(thickness: 1, height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
                'Events for ' + DateFormat('LLL d, y').format(_selectedDay),
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
          ),
        ),
        ...selectedEvents.map((event) => Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: _eventTile(event, scrollController)))
      ]),
    );
  }

  List<CalendarEvent> _getEventsFromDay(DateTime date) {
    return widget.preloadedEvents[DateUtils.dateOnly(date)] ?? [];
  }

  SizedBox buildTableCalendar(BuildContext context) {
    return SizedBox(
      height: 370,
      child: TableCalendar(
        shouldFillViewport: true,
        calendarBuilders:
            CalendarBuilders(markerBuilder: ((context, day, events) {
          if (events.isNotEmpty)
            return Positioned(
              top: -2,
              right: -2,
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.preloadedEvents[DateUtils.dateOnly(day)]!.length
                      .toString(),
                ),
              ),
            );
        })),
        focusedDay: _selectedDay,
        firstDay:
            (DateTime.now().isBefore(DateTime(DateTime.now().year, 7, 01)))
                ? DateTime(DateTime.now().year - 1, 7, 1)
                : DateTime(DateTime.now().year, 07, 1),
        lastDay: (DateTime.now().isAfter(DateTime(DateTime.now().year, 6, 30)))
            ? DateTime(DateTime.now().year + 1, 6, 30)
            : DateTime(DateTime.now().year, 6, 30),
        headerStyle: HeaderStyle(formatButtonVisible: false),
        selectedDayPredicate: (DateTime date) {
          return isSameDay(_selectedDay, date);
        },
        //Tells the calendar the events to display with markers
        eventLoader: (day) {
          return _getEventsFromDay(day);
        },
        calendarStyle: CalendarStyle(
            markersMaxCount: 1,
            todayDecoration: BoxDecoration(
                color: Color.fromRGBO(169, 113, 102, 1),
                shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle)),

        onDaySelected: (DateTime selectedDay, DateTime focusDay) {
          setState(() {
            if (!isSameDay(_selectedDay, selectedDay)) {
              _selectedDay = selectedDay;
              selectedEvents = _getEventsFromDay(selectedDay);
            }
          });
        },
      ),
    );
  }
}

class _eventTile extends StatelessWidget {
  _eventTile(this.event, this.scrollController);
  final ScrollController scrollController;

  final CalendarEvent event;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 17.0),
        child: (event.htmlDescription != '')
            ? eventExpansionTile(event: event)
            : ListTile(
                title: _TileTitle(
                  event: event,
                ),
                subtitle: _TileSubtitle(event: event)));
  }
}

class eventExpansionTile extends StatelessWidget {
  const eventExpansionTile({
    Key? key,
    required this.event,
  }) : super(key: key);

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        //Key value required to prevent other event tiles from pre-expanding
        key: Key(event.name),
        onExpansionChanged: ((value) => {
              if (value)
                {
                  Future.delayed(Duration(milliseconds: 100))
                      .then((value) {
                    Scrollable.ensureVisible(context,
                        duration: Duration(milliseconds: 200));
                  })
                }
            }),

        title: _TileTitle(event: event),
        subtitle: _TileSubtitle(event: event),
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Html(
                    data: event.htmlDescription,
                    style: {
                      "p": Style(
                        margin: EdgeInsets.only(bottom: 8),
                      )
                    },
                    onLinkTap:
                        ((url, context, attributes, element) async {
                      if (await canLaunch(url!))
                        await launch(url);
                      else
                        throw "Error occurred";
                    })),
              )
            ],
          )
        ],
      );
  }
}

class _TileSubtitle extends StatelessWidget {
  const _TileSubtitle({
    required this.event,
  });

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    print(DateFormat('hh:mm:ss').format(event.startDate));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          DateFormat('hh:mm:ss').format(event.startDate) != '12:00:00'
              ? DateFormat('LLLL d @ hh:mm aaa').format(event.startDate) +
                  ' - ' +
                  DateFormat('LLLL d @ hh:mm aaa').format(event.endDate)
              : DateFormat('LLLL d').format(event.startDate) +
                  ' - ' +
                  DateFormat('LLLL d').format(event.endDate),
          style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700)),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (event.venue != null || event.cost != null)
              DefaultTextStyle(
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
                child: Row(
                  children: [
                    if (event.venue != null)
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/landmark.svg',
                            height: 13,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 12),
                            child: Text(
                              event.venue!,
                            ),
                          ),
                        ],
                      ),
                    if (event.cost != null)
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/circle-dollar.svg',
                              height: 14),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(event.cost!),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ]))
    ]);
  }
}

class _TileTitle extends StatelessWidget {
  const _TileTitle({
    required this.event,
  });

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Text(event.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}
