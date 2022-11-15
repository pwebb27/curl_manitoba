import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//Provider class gives access to single client that remains open throughout app for CurlingIOApi

class WordPressClientProvider with ChangeNotifier {
  http.Client _client = http.Client();

  http.Client getClient() => _client;
}
