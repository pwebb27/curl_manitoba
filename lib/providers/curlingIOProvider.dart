import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


//Provider class gives access to Global CurlingIOAPI so single client remains open for app

class CurlingIOProvider with ChangeNotifier {
  CurlingIOAPI curlingIOAPI = CurlingIOAPI();

  Future<http.Response> fetchCompetitions([String id = '', int pageNumber = 1]) async {
    return await curlingIOAPI.fetchCompetitions(id, pageNumber);
  }
}
