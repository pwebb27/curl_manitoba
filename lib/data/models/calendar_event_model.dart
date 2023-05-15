// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:curl_manitoba/domain/entities/calendar_event.dart';
import 'package:html/parser.dart';

class CalendarEventModel extends CalendarEvent {
  CalendarEventModel({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String htmlDescription,
    required String venue,
    required String cost,
  }) : super(
            cost: cost,
            venue: venue,
            name: name,
            htmlDescription: htmlDescription,
            endDate: endDate,
            startDate: startDate);

factory CalendarEventModel.fromJson(Map<String, dynamic> jsonMap){
      return CalendarEventModel(name :(jsonMap['title']).body!.text,
        startDate : DateTime.parse(jsonMap['start_date']),
        endDate : DateTime.parse(jsonMap['end_date']),
        htmlDescription : jsonMap['description'],
        venue : _getParsedHtmlText(jsonMap['venue']),
        cost : jsonMap['cost'] ??= jsonMap['cost_details']['values'][0];
);}
  static _getParsedHtmlText(dynamic json) {
    try {
      return parse(json['venue']).body!.text;
    } catch (e) {
      return null;
    }
  }

}