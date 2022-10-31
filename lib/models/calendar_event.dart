import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';

class CalendarEvent {
  late final String name;
  late final DateTime startDate;
  late final DateTime endDate;
  late final String htmlDescription;
  late final String? venue;
  late final String? cost;

  CalendarEvent.fromJson(Map<String, dynamic> jsonMap)
      : name = parse(jsonMap['title']).body!.text,
        startDate = DateTime.parse(jsonMap['start_date']),
        endDate = DateTime.parse(jsonMap['end_date']),
        htmlDescription = jsonMap['description'],
        venue = jsonMap['venue'].isEmpty
            ? null
            : parse(jsonMap['venue']['venue']).body!.text,
        cost = jsonMap['cost'].isEmpty ? null : jsonMap['cost_details']['values'][0];

  static Map<DateTime, List<CalendarEvent>> parseCalendarData(
      http.Response calendarResponse) {
    Map<String, dynamic> calendarMap = json.decode(calendarResponse.body);

    List<CalendarEvent> calendarEvents = [
      for (var event in calendarMap['events']) (CalendarEvent.fromJson(event))
    ];
    return createEventsMap(calendarEvents);
  }

  static Map<DateTime, List<CalendarEvent>> createEventsMap(
      List<CalendarEvent> eventsList) {
    Map<DateTime, List<CalendarEvent>> eventsMap = {};
    for (CalendarEvent event in eventsList) {
      List<DateTime> eventDays = getListOfDaysForCalendarEvent(event);
      addEventForEachDayToEventsMap(eventDays, eventsMap, event);
    }
    return eventsMap;
  }

  static void addEventForEachDayToEventsMap(List<DateTime> eventDays,
      Map<DateTime, List<CalendarEvent>> events, CalendarEvent event) {
    for (DateTime day in eventDays) {
      //Create empty day map if no events exist for day
      events[day] ??= [];      
      events[day]!.add(event);
    }
  }

  static List<DateTime> getListOfDaysForCalendarEvent(CalendarEvent event) {
    //https://stackoverflow.com/questions/61362685/return-all-dates-between-two-dates-as-a-list-in-flutter-date-range-picker
   
    return [
      for (int i = 0;
          i <= event.endDate.difference(event.startDate).inDays;
          i++)
        (DateUtils.dateOnly((event.startDate).add(Duration(days: i))))
    ];
  }
}
