import 'package:curl_manitoba/models/apis/curling_io_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


//Provider class gives access to single client that remains open throughout app for CurlingIOAPI

class CurlingIOClientProvider with ChangeNotifier {
  http.Client _client = http.Client();

  http.Client getClient() {
    return _client;
  }
}
