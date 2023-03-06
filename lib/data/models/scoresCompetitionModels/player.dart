import 'package:string_extensions/string_extensions.dart';

class Player {
  final String? name;
  final String? profilePicUrl;
  final String? position;
  final String? city;
  final String? club;
  final String? delivery;

  Player.fromJson(Map<String, dynamic> jsonPlayer)
      : this.name = '${jsonPlayer['athlete']['first_name']}'.capitalize! +
            ' ' +
            '${jsonPlayer['athlete']['last_name']}'.capitalize!,
        this.position = '${jsonPlayer['position']}'.capitalize!,
        this.city = jsonPlayer['athlete']['city'],
        this.club = jsonPlayer['athlete']['club_name'],
        this.delivery = jsonPlayer['athlete']['delivery'],
        this.profilePicUrl = (jsonPlayer['athlete']['photo_url']);
}
