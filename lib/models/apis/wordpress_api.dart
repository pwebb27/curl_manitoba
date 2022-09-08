import 'dart:convert';

import 'package:http/http.dart' as http;

class WordPressAPI {

  static String baseUrl = 'https://curlmanitoba.org/wp-json/wp/v2/';
  Future<http.Response> fetchPage(String pageNumber) async {
    String URL =
        baseUrl +  'pages/' + pageNumber + '?_fields=content';

    final response = await http.get(Uri.parse(URL));
    return response;  

  }
   Future<http.Response> fetchPost(String postId) async {
    String URL =
        baseUrl + 'posts/' + postId + '?_fields=content';

    final response = await http.get(Uri.parse(URL));
    return response;  

  }

}
