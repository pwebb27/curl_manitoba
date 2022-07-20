import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:string_extensions/string_extensions.dart';
class Player {
  late String name;
  late String profilePicUrl;
  late String position;
  String? city;
  String? club;
  String? delivery;

  Player.fromJson(Map<String, dynamic> json) {
    this.name = (json['athlete']['first_name'] as String).capitalize! + ' ' + (json['athlete']['last_name'] as String).capitalize!;
    this.position = (json['position'] as String).capitalize!;
    this.city = json['athlete']['city'];
    this.club = json['athlete']['club_name'];
    this.delivery = json['athlete']['delivery'];

    this.profilePicUrl = (json['athlete']['photo_url']);
  }
}
