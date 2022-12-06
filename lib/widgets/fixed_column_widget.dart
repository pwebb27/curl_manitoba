import 'package:curl_manitoba/models/e_entry_competition.dart';
import 'package:curl_manitoba/models/scoresCompetitionModels/scores_competition.dart';
import 'package:flutter/material.dart';

class FixedColumnWidget extends StatelessWidget {
  List<eEntryCompetition> competitionsList;

  FixedColumnWidget(this.competitionsList);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DataTable(
          border: TableBorder.symmetric(
            outside: BorderSide(color: Colors.grey.shade400, width: .2),
          ),
          headingRowHeight: 45,
          dataRowHeight: 90,
          headingRowColor:
              MaterialStateProperty.all<Color?>(Theme.of(context).primaryColor),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          columns: [
            DataColumn(
              label: Text('Event', style: TextStyle(color: Colors.black)),
            ),
          ],
          rows: [
            for (var competition in competitionsList)
              DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: 145,
                      child: Text(
                        competition.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                    ),
                  )
                ],
              )
          ]),
    );
  }
}
