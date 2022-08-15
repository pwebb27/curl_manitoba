import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black)),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                  color: Color.fromRGBO(251, 208, 7, 1),
                      border: Border(right: BorderSide(width: 2))),
                  height: 30,
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 30,
                    color: Theme.of(context).primaryColor,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          team.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                            builder: (context) => ImageDialog(
                                team.players![index].profilePicUrl));
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
                      child: Text('City: ' + (team.players![index].city!),
                          style: TextStyle(fontSize: 16)),
                    ),
                    (team.players![index].delivery != null)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                                'Delivery: ' + (team.players![index].delivery!),
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
        if (team.location != null)
          buildTeamCard('Location', team.location!, 'whistle'),
        if (team.affiliation != null)
          buildTeamCard('Affiliation', team.affiliation!, 'location-dot'),
        if (team.coach != null) buildTeamCard('Coach', team.coach!, 'landmark'),
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

buildTeamCard(String title, String name, String iconName) {
  return Padding(
    padding: const EdgeInsets.only(left:15.0,right:15,top:10),
    child: Card(
        elevation: 5,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: SvgPicture.asset(
                  'assets/icons/' + iconName + '.svg',
                  height: 20,
                  alignment: Alignment.center,
                ),
              ),
              Text(
                title + ': ' + name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              )
            ],
          ),
        )),
  );
}

buildDrawsTable() {
  return Expanded(
      child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: SingleChildScrollView(
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
