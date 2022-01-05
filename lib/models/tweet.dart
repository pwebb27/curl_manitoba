import 'dart:ffi';

class Tweet {
  final dynamic createdAt;
  final dynamic text;
  final dynamic mediaUrl;

  Tweet.fromJson(Map<String, dynamic> json)
      : createdAt = json['created_at'],
        text = json['full_text'],
        mediaUrl = json['entities']['media'][0]['media_url'];
      
}
