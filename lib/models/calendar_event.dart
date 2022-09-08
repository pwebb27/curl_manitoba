import 'package:curl_manitoba/models/news_story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class CalendarEvent {
  late String eventName;
  late DateTime startDate;
  late DateTime endDate;
  late String details;
  late String venue;

  CalendarEvent.fromJson(Map<String, dynamic> json) {
    eventName = json['title'];
    startDate = DateUtils.dateOnly(DateTime.parse(json['start_date']));
    endDate = DateUtils.dateOnly(DateTime.parse(json['end_date']).toUtc());
    details = json['description'];
    venue = getVenue(json['venue']);
  }

  getVenue(dynamic venue) {
    if (venue.isEmpty) return '';
    return venue['venue'];
  }

  static Future<http.Response> getCalendarData() async {
    String calendarURL =
        'http://curlmanitoba.org/wp-json/tribe/events/v1/events?per_page=999&start_date=' +
            (DateFormat('y-MM-dd').format(DateTime.now()));
    var response = await http.get(Uri.parse(calendarURL));
    return response;
  }

  static Map<DateTime, List<CalendarEvent>> parseCalendarData(
      http.Response newsStoriesResponse) {
    Map<String, dynamic> calendarMap = json.decode(newsStoriesResponse.body);
    List<CalendarEvent> calendarEvents = [];
    Map<DateTime, List<CalendarEvent>> events = {};
    for (var event in calendarMap['events']) {
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

    return events;
  }
}
