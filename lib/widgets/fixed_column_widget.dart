import 'package:curl_manitoba/models/competition.dart';
import 'package:flutter/material.dart';

class FixedColumnWidget extends StatelessWidget {
  List<Competition> competitionsList;


  FixedColumnWidget(this.competitionsList);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: DataTable(
        headingRowHeight: 45,

         
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade600),
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
              label: Text('Event', style: TextStyle(color: Colors.white)),
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
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.5),
                      ),
                    ),
                  )
                ],
              )
          ]),
    );
  }
}
