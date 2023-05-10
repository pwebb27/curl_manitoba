// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:string_extensions/string_extensions.dart';

import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/player.dart';

class PlayerModel extends Player {
  PlayerModel(
      {required String city,
      required String club,
      required String delivery,
      required String position,
      required String name,
      required profilePicUrl})
      : super(
            city: city,
            club: club,
            delivery: delivery,
            name: name,
            profilePicUrl: profilePicUrl,
            position: position);

  factory PlayerModel.fromJson(Map<String, dynamic> jsonPlayer) {
    return PlayerModel(
        name: '${jsonPlayer['athlete']['first_name']}'.capitalize! +
            ' ' +
            '${jsonPlayer['athlete']['last_name']}'.capitalize!,
        position: '${jsonPlayer['position']}'.capitalize!,
        city: jsonPlayer['athlete']['city'],
        club: jsonPlayer['athlete']['club_name'],
        delivery: jsonPlayer['athlete']['delivery'],
        profilePicUrl: jsonPlayer['photo_url']);
  }
}
