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
              headingRowHeight: 45,

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
                DataColumn(label: Text('Type', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Month', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Date', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Fees', style: TextStyle(color: Colors.white))),
                
                DataColumn(label: Text('Location', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Deadline', style: TextStyle(color: Colors.white))),
              ],
              rows: [
                for (Competition competition in competitionsList)
                  DataRow(cells: [
                  DataCell(Text(competition.type,)),
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
