import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class scoresCompetition {
  late String name;
  late String id;
  late DateTime startDate;
  late DateTime endDate;
  late String venue;
  late String sponsorImageUrl;

  scoresCompetition.fromJson(Map<String, dynamic> json) {
    name = json['title'];
    venue = getVenueFromJson(json);
    startDate = DateTime.parse(json['starts_on']);
    endDate = DateTime.parse(json['ends_on']);
    sponsorImageUrl = json["logo"];
    id = json["id"].toString();
  }

  String getVenueFromJson(Map competition) {
    if (competition["venue"] != null && competition["venue"] != "")
      return competition["venue"];

    String indexOfString = 'played at the ';

    if ((competition["notes"] as String).lastIndexOf(indexOfString) != -1)
      return (competition["notes"] as String).substring(
          (competition["notes"] as String).lastIndexOf(indexOfString) +
              indexOfString.length,
          (competition["notes"] as String).length);

    indexOfString = 'played at ';

    if ((competition["notes"] as String).lastIndexOf(indexOfString) != -1)
      return (competition["notes"] as String).substring(
          (competition["notes"] as String).lastIndexOf(indexOfString) +
              indexOfString.length,
          (competition["notes"] as String).length);

    indexOfString = 'hosted by ';

    if ((competition["notes"] as String).lastIndexOf(indexOfString) != -1)
      return (competition["notes"] as String).substring(
          (competition["notes"] as String).lastIndexOf(indexOfString) +
              indexOfString.length,
          (competition["notes"] as String).length);

    return 'Location TBA';
  }



  static List<scoresCompetition> parseCompetitionData(
      http.Response competitionsResponse) {
    Map<String, dynamic> jsonMap = json.decode(competitionsResponse.body);
    List<dynamic> competitionsData =
        jsonMap["paged_competitions"]["competitions"];
    List<scoresCompetition> competitions = [];
    for (var competition in competitionsData) {
      competitions.add(scoresCompetition.fromJson(competition));
    }
    return competitions;
  }



  String formatDateRange() {
    String dateRange = '';
    if (startDate.year != endDate.year)
      dateRange = DateFormat('LLL d, y').format(startDate) +
          ' - ' +
          DateFormat('LLL d, y').format(endDate);
    else if (startDate.month != endDate.month)
      dateRange = DateFormat('LLL d').format(startDate) +
          ' - ' +
          DateFormat('LLL d, y').format(endDate);
    else
      dateRange = DateFormat('LLL d').format(startDate) +
          ' - ' +
          DateFormat('d, y').format(endDate);
    return dateRange;
  }
}
