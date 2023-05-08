import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/scores_competition.dart';

class scoresCompetitionModel extends scoresCompetition {
  scoresCompetitionModel(
      {required name,
      required venue,
      required startDate,
      required endDate,
      required sponsorImageUrl,
      required id})
      : super(
            name: name,
            id: id,
            startDate: startDate,
            endDate: endDate,
            sponsorImageUrl: sponsorImageUrl);

  factory scoresCompetitionModel.fromJson(
      Map<String, dynamic> jsonCompetition) {
    return scoresCompetitionModel(
        name: jsonCompetition['title'],
        venue: _getVenueFromJsonCompetition(jsonCompetition),
        startDate: DateTime.parse(jsonCompetition['starts_on']),
        endDate: DateTime.parse(jsonCompetition['ends_on']),
        sponsorImageUrl: jsonCompetition['logo'],
        id: '${jsonCompetition['id']}');
  }
  static String _getVenueFromJsonCompetition(
      Map<String, dynamic> jsonCompetition) {
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
}
