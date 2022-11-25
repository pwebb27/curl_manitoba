import 'package:http/http.dart' as http;
import 'dart:convert';

class Format {
  final String? name;
  final String? type;
  Format.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        type = json['type'];

  static List<Format> parseFormatData(http.Response response) {
    List<dynamic> jsonList = json.decode(response.body);
    List<Format> formats = [];
    for (Map<String,dynamic> jsonFormat in jsonList) {
      Format format = Format.fromJson(jsonFormat);
      if (format.type != 'Bracket') formats.add(format);
    }
    return formats;
  }
}
