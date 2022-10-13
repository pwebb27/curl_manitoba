import 'package:curl_manitoba/models/scoresCompetitionModels/team.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamDataScreen extends StatefulWidget {
  final Team team;
  TeamDataScreen(this.team);

  @override
  State<TeamDataScreen> createState() => _TeamDataScreenState();
}

class _TeamDataScreenState extends State<TeamDataScreen> {
  void initState() {
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
                          widget.team.name!,
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
          itemCount: widget.team.players!.length,
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
                                widget.team.players![index].profilePicUrl));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            widget.team.players![index].profilePicUrl),
                      )),
                  subtitle: Text(
                    widget.team.players![index].position,
                    style: TextStyle(fontSize: 14),
                  ),
                  title: Text(
                    widget.team.players![index].name,
                    style: TextStyle(fontSize: 16),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                          'City: ' + (widget.team.players![index].city!),
                          style: TextStyle(fontSize: 16)),
                    ),
                    (widget.team.players![index].delivery != null)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                                'Delivery: ' +
                                    (widget.team.players![index].delivery!),
                                style: TextStyle(fontSize: 16)))
                        : SizedBox.shrink(),
                    (widget.team.players![index].club != null)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Club: ' + (widget.team.players![index].club!),
                              style: TextStyle(fontSize: 16),
                            ))
                        : SizedBox.shrink()
                  ],
                ),
              ))),
        ),
        if (widget.team.location != null)
          _TeamCard('Location', widget.team.location!, 'whistle'),
        if (widget.team.affiliation != null)
          _TeamCard('Affiliation', widget.team.affiliation!, 'location-dot'),
        if (widget.team.coach != null)
          _TeamCard('Coach', widget.team.coach!, 'landmark'),
        Padding(padding: EdgeInsets.all(12)),
        Row(children: [buildDrawsTable()]),
      ]),
    ));
  }
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;
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

class _TeamCard extends StatelessWidget {
  const _TeamCard(this.title, this.name, this.iconName);
  final String title;
  final String name;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
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
