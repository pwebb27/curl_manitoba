import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TeamDataScreen extends StatefulWidget {
  Team team;

  TeamDataScreen(this.team);

  @override
  State<TeamDataScreen> createState() => _TeamDataScreenState();
}

class _TeamDataScreenState extends State<TeamDataScreen> {
  late Team team;

  void initState() {
    team = widget.team;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10.0),
          child: Text(
            team.name!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: team.players!.length,
          itemBuilder: ((context, index) => ListTileTheme(
              dense: true,
              child: Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  expandedAlignment: Alignment.centerLeft,
                  leading: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                ImageDialog(team.players![index].profilePicUrl));
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(team.players![index].profilePicUrl),
                      )),
                  subtitle: Text(
                    team.players![index].position,
                    style: TextStyle(fontSize: 14),
                  ),
                  title: Text(
                    team.players![index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                          'City: ' + (team.players![index].city!),
                          style: TextStyle(fontSize: 16)),
                    ),
                    (team.players![index].delivery != null)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                                'Delivery: ' +
                                    (team.players![index].delivery!),
                                style: TextStyle(fontSize: 16)))
                        : SizedBox.shrink(),
                    (team.players![index].club != null)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Club: ' + (team.players![index].club!),
                              style: TextStyle(fontSize: 16),
                            ))
                        : SizedBox.shrink()
                  ],
                ),
              ))),
        ),
        Padding(padding: EdgeInsets.all(12)),
        Row(children: [buildDrawsTable()]),
      ]),
    ));
  }
}

class ImageDialog extends StatelessWidget {
  String imageUrl;
  ImageDialog(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: CircleBorder(),
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
            )),
      ),
    );
  }
}

buildDrawsTable() {
  return Expanded(
    child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),child:SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        border: TableBorder.symmetric(outside: BorderSide(width: .2)),
        headingRowHeight: 40,
        dataRowHeight: 40,
        headingRowColor: MaterialStateProperty.all(Colors.grey.shade400),
        columnSpacing: 30,
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
              label: Text('Draw', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Started at', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Result', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Score', style: TextStyle(color: Colors.white))),
          DataColumn(
              label: Text('Opponent', style: TextStyle(color: Colors.white))),
        ],
        rows: [],
      ),
    ),
  ));
}
