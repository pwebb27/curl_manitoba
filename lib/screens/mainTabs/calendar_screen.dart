import 'package:curl_manitoba/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:http/http.dart' as http;

class CalendarScreen extends StatefulWidget {
  Map<DateTime, List<CalendarEvent>> preloadedEvents;
  CalendarScreen(this.preloadedEvents);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  late Future<http.Response> calendarDataFuture;
  late Map<DateTime, List<CalendarEvent>> preLoadedEvents;

  late DateTime selectedDay;
  late DateTime focusedDay;
  late List<CalendarEvent> selectedEvents;
  late Map<DateTime, List<CalendarEvent>> additionalEvents;
  bool loadedAdditionalEvents = false;

  @override
  void initState() {
    super.initState();
    preLoadedEvents = widget.preloadedEvents;
    selectedEvents = [];
    selectedDay = DateUtils.dateOnly(DateTime.now());
    focusedDay = DateUtils.dateOnly(DateTime.now());
    calendarDataFuture = CalendarEvent.getCalendarData();
    calendarDataFuture.then(
        (value) => preLoadedEvents = CalendarEvent.parseCalendarData(value));
  }

  List<CalendarEvent> _getEventsFromDay(DateTime date) {
    return preLoadedEvents[DateUtils.dateOnly(date)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        buildTableCalendar(context),
        Divider(thickness: 1, height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
              'Events for ' + DateFormat('LLL d, y').format(selectedDay),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
        ),
        ...selectedEvents.map((event) => Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: _eventTile(event)))
      ]),
    );
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
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      preLoadedEvents[DateUtils.dateOnly(day)]!
                          .length
                          .toString(),
                      ),
                    ),
                );
            })),
            focusedDay: selectedDay,
            firstDay: DateTime(2021, 1, 1),
            lastDay: DateTime(2022, 12, 31),
            headerStyle: HeaderStyle(formatButtonVisible: false),
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: (day) {
              return _getEventsFromDay(day);
            },
            calendarStyle: CalendarStyle(
                markersMaxCount: 1,
                todayDecoration: BoxDecoration(
                    color: Color.fromRGBO(169, 113, 102, 1),
                    shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle)),
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
                selectedEvents =
                    _getEventsFromDay(DateUtils.dateOnly(selectedDay));
              });
            },
          ),
    );
  }
}

class _eventTile extends StatelessWidget {
  const _eventTile(this.event);
  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: (event.htmlDescription != '')
          ? ExpansionTile(
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
            )
          : ListTile(
                title: _TileTitle(
                  event: event,
              ),
                subtitle: _TileSubtitle(event: event)));
  }
}

class _TileSubtitle extends StatelessWidget {
  const _TileSubtitle({
    required this.event,
  });

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
          DateFormat('hh:mm:ss').format(event.startDate) != '00:00:00'
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
  }) ;

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
