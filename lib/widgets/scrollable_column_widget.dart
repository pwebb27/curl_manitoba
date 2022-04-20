import 'package:curl_manitoba/models/competition.dart';
import 'package:flutter/material.dart';

class ScrollableColumnWidget extends StatelessWidget {
  List<Competition> competitionsList;

  ScrollableColumnWidget(this.competitionsList);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(

              dataRowHeight: 90,
              headingRowColor: MaterialStateProperty.all(Colors.green[100]),
              columnSpacing: 40,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              columns: [
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Month')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Fees')),
                
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Deadline')),
              ],
              rows: [
                for (Competition competition in competitionsList)
                  DataRow(cells: [
                  DataCell(Text(competition.type)),
                  DataCell(Text(competition.month)),
                  DataCell(Text(competition.dates)),
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
