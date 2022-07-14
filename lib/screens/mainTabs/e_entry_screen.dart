import 'package:curl_manitoba/models/e_entry_competition.dart';
import 'package:curl_manitoba/widgets/fixed_column_widget.dart';
import 'package:curl_manitoba/widgets/scrollable_column_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/circular_progress_bar.dart';
import 'package:http/http.dart' as http;

class eEntryScreen extends StatefulWidget {
  @override
  State<eEntryScreen> createState() => _eEntryScreenState();
}

class _eEntryScreenState extends State<eEntryScreen> with AutomaticKeepAliveClientMixin{
    bool get wantKeepAlive => true;

  late Map<String, dynamic> competitionsMap;
  late Future<http.Response> eEntryDataFuture;

  @override
  void initState() {
    eEntryDataFuture = eEntryCompetition.getElectronicEntryData();
    eEntryDataFuture.then((value) =>
        competitionsMap = eEntryCompetition.parseElectronicEntryData(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: eEntryDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressBar();
          }
          return SingleChildScrollView(
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var entry in competitionsMap.entries)
                    Column(children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                                top: BorderSide(
                                    width: .3, color: Colors.grey.shade500))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            entry.key.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FixedColumnWidget(entry.value),
                            ScrollableColumnWidget(entry.value)
                          ]),
                    ])
                ],
              ),
            ),
          );
        });
  }
}
