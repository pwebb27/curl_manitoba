import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class scoresCompetition {
  String? name;
  String? id;
  DateTime? startDate;
  DateTime? endDate;
  String? venue;
  String? sponsorImageUrl;
  Map<String, List<Team>>? formatMap;

  scoresCompetition();

  scoresCompetition.fromJson(Map<String, dynamic> jsonCompetition)
      : name = jsonCompetition['title'],
        venue = _getVenueFromJsonCompetition(jsonCompetition),
        startDate = DateTime.parse(jsonCompetition['starts_on']),
        endDate = DateTime.parse(jsonCompetition['ends_on']),
        sponsorImageUrl = jsonCompetition['logo'],
        id = '${jsonCompetition['id']}';

  static String _getVenueFromJsonCompetition(Map<String, dynamic> jsonCompetition) {
    //If venue value exists return venue
    if (!['', null].contains(jsonCompetition["venue"]))
      return jsonCompetition["venue"];

    //Otherwise try to find venue in 'notes'
    final String notes = jsonCompetition['notes'];
    const List<String> stringsBeforeVenueName = [
      'played at the ',
      'played at ',
      'hosted by the ',
      'hosted by '
    ];
    bool foundVenue = false;
    String? venue;
    int i = 0;
    while (!foundVenue && i < stringsBeforeVenueName.length) {
      if (notes.contains(stringsBeforeVenueName[i])) {
        foundVenue = true;

        venue = notes.substring(notes.indexOf(stringsBeforeVenueName[i]) +
            stringsBeforeVenueName[i].length);

        //Check if '.' exists and remove everything after it
        if (venue.contains('.')) venue = venue.substring(0, venue.indexOf('.'));
      }
      i++;
    }
    //Return venue if found, otherwise try location or set as 'TBD Curling Club'
    return venue ?? jsonCompetition['location'] ?? 'TBD Curling Club';
  }

  static List<scoresCompetition> parseCompetitionData(
      http.Response competitionsResponse) {
    Map<String, dynamic> jsonMap = json.decode(competitionsResponse.body);
    List<dynamic> jsonCompetitions =
        jsonMap["paged_competitions"]["competitions"];
    return [
      for (Map<String, dynamic> jsonCompetition in jsonCompetitions)
        scoresCompetition.fromJson(jsonCompetition)
    ];
  }

  String formatDateRange() {
    if (startDate!.year != endDate!.year)
      return DateFormat('LLL d, y').format(startDate!) +
          ' - ' +
          DateFormat('LLL d, y').format(endDate!);
    else if (startDate!.month != endDate!.month)
      return DateFormat('LLL d').format(startDate!) +
          ' - ' +
          DateFormat('LLL d, y').format(endDate!);
    return DateFormat('LLL d').format(startDate!) +
        ' - ' +
        DateFormat('d, y').format(endDate!);
  }
}
