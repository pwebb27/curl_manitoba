import 'package:http/http.dart' as http;

class TwitterApi {
  static const String _bearerToken =
      'AAAAAAAAAAAAAAAAAAAAANDnWgEAAAAAQ0%2BkRHKSb1CbJ0I1nJPhAlyBggU%3DqvnkZaPQjBQZ4DPAPDyArtDcTq2JTPkdYJoUqxTQLV921z3WuC';
  static const Map<String, String> _queryParameters = {
    "user_id": "92376817",
    "count": "15",
    "tweet_mode": "extended"
  };
  static const _path = "1.1/statuses/user_timeline.json";

  Future<http.Response> fetchTweets() async =>
     await http
        .get(Uri.https("api.twitter.com", _path, _queryParameters), headers: {
      "Authorization": 'Bearer $_bearerToken',
      "Content-Type": "application/json"
    });
    
  }
