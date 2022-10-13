import 'package:curl_manitoba/models/apis/wordpress_api.dart';
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

class _eEntryScreenState extends State<eEntryScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  late Future _eEntryDataFuture;
  late Map<String, dynamic> _eEntryCompetitions;

  @override
  void initState() {
    super.initState();
    _eEntryDataFuture = WordPressAPI().fetchPage('1979');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _eEntryDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressBar();
          }
          _eEntryCompetitions = eEntryCompetition
              .parseElectronicEntryData(snapshot.data as http.Response);
          return SingleChildScrollView(
            child: Expanded(
              child: ListView.separated(
                separatorBuilder: ((context, index) => SizedBox(
                      height: 30,
                    )),
                shrinkWrap: true,
                itemCount: _eEntryCompetitions.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [  
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _eEntryCompetitions.entries.elementAt(index).key,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FixedColumnWidget(
                                    _eEntryCompetitions.values.elementAt(index)),
                                ScrollableColumnWidget(
                                    _eEntryCompetitions.values.elementAt(index))
                              ]),
                        ])),
              ),
            ),
          );
        });
  }
}
