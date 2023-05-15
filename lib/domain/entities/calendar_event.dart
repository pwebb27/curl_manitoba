class CalendarEvent {
  late final String name;
  late final DateTime startDate;
  late final DateTime endDate;
  late final String htmlDescription;
  late final String? venue;
  late final String? cost;

  CalendarEvent(
      {required this.name,
      required this.startDate,
      required this.endDate,
      required this.htmlDescription,
      required this.venue,
      required cost});
}
