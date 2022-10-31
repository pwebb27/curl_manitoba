import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';

class eEntryCompetition {
  final String name;
  final String fee;
  final String deadline;
  final String type;
  final String month;
  final String dateRange;
  final String location;

  eEntryCompetition(
      {required this.type,
      required this.dateRange,
      required this.month,
      required this.fee,
      required this.name,
      required this.location,
      required this.deadline});

  static Map<String, dynamic> parseElectronicEntryData(
      http.Response electronicEntryDataResponse) {
    Map<String, dynamic> map = json.decode(electronicEntryDataResponse.body);
    String htmlData = map['content']['rendered'];
    var document = parse(htmlData);
    List<html.Element> htmlRows =
        document.getElementsByTagName('table')[1].getElementsByTagName('tr');

    String category = '';
    List<html.Element> htmlCells;
    Map<String, List<eEntryCompetition>> competitionsMap = {};

    htmlRows.forEach((row) {
      htmlCells = row.getElementsByTagName('td');

      if (htmlCells[0].text == '' && htmlCells.length != 1) {
        category = htmlCells[4].text;
        competitionsMap[category] = [];
      } else if (htmlCells[0].text != 'Type' && htmlCells[0].text != '') {
        competitionsMap[category]!.add(eEntryCompetition(
            type: htmlCells[0].text,
            month: htmlCells[1].text,
            dateRange: htmlCells[2].text,
            fee: '\$' +
                ((htmlCells[3].text.replaceAll(new RegExp(r'[^0-9]'), ''))),
            name: htmlCells[4].text,
            location: htmlCells[5].text,
            deadline: htmlCells[6].text));
      }
    });
    return competitionsMap;
  }
}
