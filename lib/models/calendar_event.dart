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
        venue = _getParsedHtmlText(jsonMap['venue']),
        cost = jsonMap['cost'] ??= jsonMap['cost_details']['values'][0];

  static _getParsedHtmlText(dynamic json) {
    try {
      return parse(json['venue']).body!.text;
    } catch(e){
      return null;
    }
  }

  static Map<DateTime, List<CalendarEvent>> parseCalendarData(
      http.Response calendarResponse) {
    Map<String, dynamic> calendarMap = json.decode(calendarResponse.body);

    List<CalendarEvent> calendarEvents = [
      for (var event in calendarMap['events']) (CalendarEvent.fromJson(event))
    ];
    return _createEventsMap(calendarEvents);
  }

  static Map<DateTime, List<CalendarEvent>> _createEventsMap(
      List<CalendarEvent> eventsList) {
    //eventsMap maps all events with same days with one DateTime instance of the date
    Map<DateTime, List<CalendarEvent>> eventsMap = {};
    for (CalendarEvent event in eventsList) {
      //Get list of days that the calendar event falls on
      List<DateTime> eventDays = [
        for (int i = 0;
            i <= event.endDate.difference(event.startDate).inDays;
            i++)
          (DateUtils.dateOnly((event.startDate).add(Duration(days: i))))
      ];
      ;
      //Add event to eventsMap for each day event falls on
      for (DateTime day in eventDays) {
        //Create empty day map if no events exist for day
        eventsMap[day] ??= [];
        eventsMap[day]!.add(event);
      }
    }
    return eventsMap;
  }
}
