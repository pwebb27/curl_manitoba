class Tweet {
  final String id;
  final String createdAt;

  Tweet.fromJson(Map<String, dynamic> json) : id = json['id'], createdAt = json['created_at'] ;

  String toString() {
    return 'Tweet: {id = $id}';
  }
}
