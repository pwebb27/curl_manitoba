import 'dart:convert';

import 'package:http/http.dart' as http;

class TwitterAPI{
  final String bearerToken = 'AAAAAAAAAAAAAAAAAAAAANDnWgEAAAAAQ0%2BkRHKSb1CbJ0I1nJPhAlyBggU%3DqvnkZaPQjBQZ4DPAPDyArtDcTq2JTPkdYJoUqxTQLV921z3WuC';
  String? responsed;
  Future<String> callTwitterAPI(String path, Map<String,dynamic> queryParameters) async {
        var response = await http.get(
        Uri.https("api.twitter.com", path, queryParameters),
        headers: {
          "Authorization": 'Bearer $bearerToken',
          "Content-Type": "application/json"
        }
        );
        return response.body;
    
  }
}