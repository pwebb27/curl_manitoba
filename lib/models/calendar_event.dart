import 'package:flutter/material.dart';

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
    if (venue.isEmpty)
      return null;
    else
      return venue['venue'];
  }
}
