import 'package:curl_manitoba/data/repositories/word_press_repository.dart';
import 'package:curl_manitoba/domain/useCases/wordpress_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/widgets/fixed_column_widget.dart';
import 'package:curl_manitoba/presentation/widgets/scrollable_column_widget.dart';
import 'package:flutter/material.dart';
import '../../widgets/circular_progress_bar.dart';

class eEntryScreen extends StatefulWidget {
  @override
  State<eEntryScreen> createState() => _eEntryScreenState();
}

class _eEntryScreenState extends State<eEntryScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  late Map<String, dynamic> _eEntryCompetitions;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: GetElectronicEntryMap(WordPressRepositoryImp())(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressBar();
          }
          _eEntryCompetitions = snapshot.data as Map<String, dynamic>;
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
                                FixedColumnWidget(_eEntryCompetitions.values
                                    .elementAt(index)),
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
