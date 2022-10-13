import 'package:curl_manitoba/models/news_story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

import 'package:intl/intl.dart';

class CalendarEvent {
  late String name;
  late DateTime startDate;
  late DateTime endDate;
  late String htmlDescription;
  late String? venue;
  late String? cost;

  CalendarEvent.fromJson(Map<String, dynamic> json) {
    name = parse(json['title']).body!.text;
    startDate = DateTime.parse(json['start_date']);
    endDate = DateTime.parse(json['end_date']);
    htmlDescription = json['description'];
    venue =
        json['venue'].isEmpty ? null : parse(json['venue']['venue']).body!.text;
    cost = json['cost'].isEmpty ? null : json['cost_details']['values'][0];
  }

  static Future<http.Response> getCalendarData() async {
    String calendarURL =
        'http://curlmanitoba.org/wp-json/tribe/events/v1/events?per_page=999&start_date=' +
            getEventsStartingDate();
    var response = await http.get(Uri.parse(calendarURL));
    return response;
  }

  static String getEventsStartingDate() {
    DateTime startingDate = DateTime(
      DateTime.now().year,
      09,
      01,
    );

    //Load events starting September of last year if we are before July 1st
    if (DateTime.now().isBefore(DateTime(DateTime.now().year, 7, 01)))
      startingDate =
          DateTime(startingDate.year - 1, startingDate.month, startingDate.day);
    return DateFormat('y-MM-dd').format(startingDate);
  }
  

  static Map<DateTime, List<CalendarEvent>> parseCalendarData(
      http.Response calendarResponse) {
    Map<String, dynamic> calendarMap = json.decode(calendarResponse.body);
    List<CalendarEvent> calendarEvents = [];

    for (var event in calendarMap['events']) {
      calendarEvents.add(CalendarEvent.fromJson(event));
    }
    return createEventsMap(calendarEvents);
  }

  static Map<DateTime, List<CalendarEvent>> createEventsMap(
      List<CalendarEvent> eventsList) {
    Map<DateTime, List<CalendarEvent>> eventsMap = {};
    for (CalendarEvent event in eventsList) {
      List<DateTime> days = getCalendarEventDates(event);
      addDaysToEventsMap(days, eventsMap, event);
    }
    return eventsMap;
  }

  static void addDaysToEventsMap(List<DateTime> days,
      Map<DateTime, List<CalendarEvent>> events, CalendarEvent event) {
    for (DateTime day in days) {
      if (!events.containsKey((day))) events[day] = [];
      events[day]!.add(event);
    }
  }

  //Return list of in
  static List<DateTime> getCalendarEventDates(CalendarEvent event) {
    //https://stackoverflow.com/questions/61362685/return-all-dates-between-two-dates-as-a-list-in-flutter-date-range-picker

    List<DateTime> calendarEventDates = [];
    for (int i = 0;
        i <= event.endDate.difference(event.startDate).inDays;
        i++) {
      calendarEventDates
          .add(DateUtils.dateOnly((event.startDate).add(Duration(days: i))));
    }
    return calendarEventDates;
  }
}
