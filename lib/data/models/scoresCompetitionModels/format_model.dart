import 'package:curl_manitoba/domain/entities/scoresCompetitionModels/format.dart';

class FormatModel extends Format {
  FormatModel({
    required String name,
    required String type,
  }) : super(name: name, type: type);

  factory FormatModel.fromJson(Map<String, dynamic> json) {
    return FormatModel(name: json['name'], type: json['type']);
  }
}
