import 'package:curl_manitoba/models/competition.dart';
import 'package:curl_manitoba/widgets/fixed_column_widget.dart';
import 'package:curl_manitoba/widgets/scrollable_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/circular_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';
import 'package:html/dom.dart' as html;
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';

class eEntryScreen extends StatefulWidget {
  @override
  State<eEntryScreen> createState() => _eEntryScreenState();
}

class _eEntryScreenState extends State<eEntryScreen> {
  Map<String, dynamic> competitionsMap = {};
  Future<Map<String, dynamic>> _getDataFromWeb() async {
    String URL =
        'https://curlmanitoba.org/wp-json/wp/v2/pages/1979?_fields=content';

    final response = await http.get(Uri.parse(URL));
    return json.decode(response.body);
  }

  Map<String, dynamic> buildContent(Map<String, dynamic> map) {
    String htmlData = map['content']['rendered'];
    var document = parse(htmlData);
    List<html.Element> htmlRows =
        document.getElementsByTagName('table')[1].getElementsByTagName('tr');

    String category = '';
    List<html.Element> htmlCells;
    Map<String, List<Competition>> competitionsMap = {};

    htmlRows.forEach((row) {
      htmlCells = row.getElementsByTagName('td');

      if (htmlCells[0].text == '' && htmlCells.length != 1) {
        category = htmlCells[4].text;
        competitionsMap[category] = [];
      } else if (htmlCells[0].text != 'Type' && htmlCells[0].text != '') {
        competitionsMap[category]!.add(Competition(
            type: htmlCells[0].text,
            month: htmlCells[1].text,
            dates: htmlCells[2].text,
            fee: '\$' +
                ((htmlCells[3].text.replaceAll(new RegExp(r'[^0-9]'), ''))),
            eventName: htmlCells[4].text,
            location: htmlCells[5].text,
            deadline: htmlCells[6].text));
      }
    });
    return competitionsMap;
  }

  @override
  void initState() {
    _getDataFromWeb();
  }

  List<Competition> competitionsData = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDataFromWeb(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressBar();
          } else
            competitionsMap =
                buildContent(snapshot.data as Map<String, dynamic>);
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
                            border: Border(top: BorderSide(width: .3, color: Colors.grey.shade500))
                            ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            
                            entry.key.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white,fontSize: 13.5, fontWeight: FontWeight.bold),
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
