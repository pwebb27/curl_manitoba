import 'package:curl_manitoba/models/competition.dart';
import 'package:flutter/material.dart';

class FixedColumnWidget extends StatelessWidget {
  List<Competition> competitionsList;


  FixedColumnWidget(this.competitionsList);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DataTable(
        dataRowHeight: 90,
          horizontalMargin: 10,
          columnSpacing: 10,
          headingRowColor: MaterialStateProperty.all(Colors.green[300]),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
          columns: [
            DataColumn(
              label: Text('Event'),
            ),
          ],
          rows: [
            for (Competition competition in competitionsList)
              DataRow(
                cells: [
                  DataCell(
                    Container(
                      width: 145,
                      child: Text(
                        competition.eventName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
          ]),
    );
  }
}
