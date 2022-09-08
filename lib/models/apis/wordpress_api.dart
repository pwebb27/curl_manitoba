import 'dart:convert';

import 'package:http/http.dart' as http;

class WordPressAPI {

  static String baseUrl = 'https://curlmanitoba.org/wp-json/wp/v2/pages/';
  Future<http.Response> call(String pageNumber) async {
    String URL =
        baseUrl + pageNumber + '?_fields=content';

    final response = await http.get(Uri.parse(URL));
    return response;  

  }
}
