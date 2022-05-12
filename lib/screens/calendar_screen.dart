import 'package:curl_manitoba/models/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/circular_progress_bar.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<Map<String, dynamic>> dataFuture;
  WebViewController? _myController;
  List<CalendarEvent> calendarEvents = [];

  bool _loadedPage = false;
  DateTime selectedDay = DateUtils.dateOnly(DateTime.now());
  DateTime focusedDay = DateUtils.dateOnly(DateTime.now());
  List<CalendarEvent> selectedEvents = [];
  late Map<DateTime, List<CalendarEvent>> events;

  Future<Map<String, dynamic>> _getDataFromWeb() async {
    String URL =
        'http://curlmanitoba.org/wp-json/tribe/events/v1/events?per_page=999&start_date=2022-03-01&end_date=2022-05-31';

    final response = await http.get(Uri.parse(URL));
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    dataFuture = _getDataFromWeb();
    dataFuture.then((value) => buildContent(value));
    events = {};
    // dataFuture.then((value) => buildContent(value));
  }

  List<CalendarEvent> _getEventsFromDay(DateTime date) {
    return events[DateUtils.dateOnly(date)] ?? [];
  }

  buildContent(Map<String, dynamic> json) {
    for (var event in json['events']) {
      calendarEvents.add(CalendarEvent.fromJson(event));
    }
    for (CalendarEvent event in calendarEvents) {
      //https://stackoverflow.com/questions/61362685/return-all-dates-between-two-dates-as-a-list-in-flutter-date-range-picker

      List<DateTime> days = [];
      for (int i = 0;
          i <= event.endDate.difference(event.startDate).inDays;
          i++) {
        days.add(event.startDate.add(Duration(days: i)));
      }
      for (DateTime day in days) {
        if (!events.containsKey(day)) events[day] = [];
        events[day]!.add(event);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dataFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressBar());
          }
          return SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TableCalendar(
                calendarBuilders: CalendarBuilders(
                    singleMarkerBuilder: ((context, day, event) => Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle,
                          ),
                          child:
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Text(events[DateUtils.dateOnly(day)]!.length.toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                        ))),
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
              Divider(thickness: 1, height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                    'Events for ' + DateFormat('LLL d, y').format(selectedDay),
                    style:
                        TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              ),
              ...selectedEvents.map((event) => ExpansionTile(
                      title: Text(event.eventName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      expandedAlignment: Alignment.centerLeft,
                      subtitle: Text(
                          DateFormat('LLL d, y').format(event.startDate) +
                              ' - ' +
                              DateFormat('LLL d, y').format(event.endDate),style: TextStyle(fontSize: 13.5, color: Colors.grey.shade700)) ,
                      children: [
                        Column(
                          children: [
                            (event.venue != null)
                                ? Text('Venue: ' + event.venue)
                                : Text(''),
                            (event.details != null)
                                ? Text('Details: ' + event.details)
                                : Text('')
                          ],
                        )
                      ]))
            ]),
          );
        });
  }
}
