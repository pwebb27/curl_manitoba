import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/team.dart';
import 'package:intl/intl.dart';

class scoresCompetition {
  String? name;
  String? id;
  DateTime? startDate;
  DateTime? endDate;
  String? venue;
  String? sponsorImageUrl;
  Map<String, List<Team>>? formatMap;

  scoresCompetition(
      {required this.name,
      required this.id,
      required this.startDate,
      this.endDate,
      this.venue,
      this.sponsorImageUrl,
      this.formatMap});

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
