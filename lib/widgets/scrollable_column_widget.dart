import 'package:curl_manitoba/models/e_entry_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:flutter/material.dart';

class ScrollableColumnWidget extends StatelessWidget {
  List<eEntryCompetition> competitionsList;

  ScrollableColumnWidget(this.competitionsList);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 45,
          border: TableBorder.symmetric(outside: BorderSide(width: .2)),
          dataRowHeight: 90,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade400),
          columnSpacing: 40,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
          ),
          columns: [
            DataColumn(
                label: Text('Type', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Month', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Date', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Fees', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Location', style: TextStyle(color: Colors.white))),
            DataColumn(
                label: Text('Deadline', style: TextStyle(color: Colors.white))),
          ],
          rows: [
            for (eEntryCompetition competition in competitionsList)
              DataRow(cells: [
                DataCell(Text(
                  competition.type,
                )),
                DataCell(Text(competition.month)),
                DataCell(Text(competition.dateRange)),
                DataCell(Text(competition.fee)),
                DataCell(Text(competition.location)),
                DataCell(Text(competition.deadline))
              ])
          ],
        ),
      ),
    );
  }
}
