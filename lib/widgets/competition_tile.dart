import 'package:curl_manitoba/models/scores_competition.dart';
import 'package:curl_manitoba/widgets/font_awesome_pro_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CompetitionTile extends StatelessWidget {
  scoresCompetition competition;
  CompetitionTile(this.competition);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 0),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/competition',
                arguments: competition);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade700, width: .3),
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1.5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(competition.name + '\n',
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 1.5),
                                      child: Icon(FontAwesomePro.calendar_range,
                                          size: 10,
                                          color: Colors.grey.shade700),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        competition.formatDateRange(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    SvgPicture.asset(
                                        'assets/icons/landmark.svg',
                                        height: 10,
                                        color: Colors.grey.shade700),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(competition.venue,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700)))
                                  ])
                                ]),
                            Image.network(
                              competition.sponsorImageUrl,
                              height: 30,
                            )
                          ]),
                    )
                  ]),
            ),
          )),
    );
  }
}
