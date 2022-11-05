import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:string_extensions/string_extensions.dart';
class Player {
  late String? name;
  late String? profilePicUrl;
  late String? position;
  String? city;
  String? club;
  String? delivery;

  Player.fromJson(Map<String, dynamic> jsonPlayer) {
    this.name = (jsonPlayer['athlete']['first_name'] as String).capitalize! + ' ' + (jsonPlayer['athlete']['last_name'] as String).capitalize!;
    this.position = (jsonPlayer['position'] as String).capitalize!;
    this.city = jsonPlayer['athlete']['city'];
    this.club = jsonPlayer['athlete']['club_name'];
    this.delivery = jsonPlayer['athlete']['delivery'];

    this.profilePicUrl = (jsonPlayer['athlete']['photo_url']);
  }
}
