import 'dart:ffi';

class Tweet {
  final String id;
  final String createdAt;
  final List<String> attachments;

  Tweet.fromJson(Map<String, dynamic> json) : id = json['id'], createdAt = json['created_at'], attachments = json['includes.media'] ;

}
