import 'package:curl_manitoba/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/circular_progress_bar.dart';
import 'package:table_calendar/table_calendar.dart';

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
        SizedBox(
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
                        color: Theme.of(context).textSelectionColor,
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
        ),
        Divider(thickness: 1, height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
              'Events for ' + DateFormat('LLL d, y').format(selectedDay),
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
        ),
        ...selectedEvents.map((event) => ExpansionTile(
                title: Text(event.eventName,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                expandedAlignment: Alignment.centerLeft,
                subtitle: Text(
                    DateFormat('LLL d, y').format(event.startDate) +
                        ' - ' +
                        DateFormat('LLL d, y').format(event.endDate),
                    style:
                        TextStyle(fontSize: 13.5, color: Colors.grey.shade700)),
                children: [
                  Column(
                    children: [
                      (event.venue != '')
                          ? Text('Venue: ' + event.venue)
                          : Text(''),
                      (event.details != '')
                          ? Text('Details: ' + event.details)
                          : Text('')
                    ],
                  )
                ]))
      ]),
    );
  }
}
