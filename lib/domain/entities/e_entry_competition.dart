import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

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

  //Takes electronic-entry webpage content response and builds all eEntryCompetitions from existing table mapped to categories
  static Map<String, dynamic> parseElectronicEntryData(
      http.Response eEntryResponse) {
    Map<String, dynamic> eEntryJsonMap = json.decode(eEntryResponse.body);
    dom.Document eEntryHtmlDocument =
        parse(eEntryJsonMap['content']['rendered']);
        
    List<html.Element> eEntryHtmlRows = eEntryHtmlDocument
        .getElementsByTagName('table')[1]
        .getElementsByTagName('tr');
    return getEEntryCompetitionsMapFromHtmlRows(eEntryHtmlRows);
  }

  static getEEntryCompetitionsMapFromHtmlRows(List<html.Element> eEntryHtmlRows) {
    String competitionCategory = '';
    List<html.Element> htmlRowCells;
    Map<String, List<eEntryCompetition>> competitionsMap = {};
    int rowCellsOccupied;

    eEntryHtmlRows.forEach((htmlRow) {
      rowCellsOccupied = 0;

      htmlRowCells = htmlRow.getElementsByTagName('td');

      //Determine if row is beginning of new category (only one cell will be occupied with category title)
      htmlRowCells.forEach((htmlCell) {
        if (htmlCell.text.isNotEmpty) ++rowCellsOccupied;
      });

      if (rowCellsOccupied == 1) {
        competitionCategory = htmlRowCells[4].text;
        competitionsMap[competitionCategory] = [];

        //If it is not an empty row and not a header row, create eEntryCompetition from row data
      } else if (htmlRowCells[0].text.toLowerCase() != 'type' && rowCellsOccupied > 1) {
        competitionsMap[competitionCategory]!.add(eEntryCompetition(
            type: htmlRowCells[0].text,
            month: htmlRowCells[1].text,
            dateRange: htmlRowCells[2].text,
            fee: '\$' +
                ((htmlRowCells[3].text.replaceAll(new RegExp(r'[^0-9]'), ''))),
            name: htmlRowCells[4].text,
            location: htmlRowCells[5].text,
            deadline: htmlRowCells[6].text));
      }
    });
    return competitionsMap;
  }
}
