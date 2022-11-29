import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  Client client;
  ApiBaseHelper(this.client);

  Future<http.Response> callApi(
      {required String authority, required String unencodedPath,
      Map<String, String> queryParameters = const {}}) async {
    try {
      final http.Response response =
          await http.get(Uri.https(authority, unencodedPath, queryParameters));
      switch (response.statusCode) {
        case 200:
          return response;
        default:
          throw Exception(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
      }
    } on SocketException {
      throw Failure('No Internet connection');
     } 
    //on FormatException {
    //   throw Failure("Bad response format");
    // }
  }
}

class Failure {
  final String message;
  Failure(this.message);
}
