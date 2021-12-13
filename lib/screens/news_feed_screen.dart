import 'package:flutter/material.dart';

import '../news_stories_data.dart';
import '../widgets/news_story_item.dart';


class NewsFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemBuilder: (ctx, index) {
            return NewsStoryItem(
                id: NEWS_STORIES[index].id,
                imageUrl: NEWS_STORIES[index].imageURL,
                title: NEWS_STORIES[index].headline,
                author: NEWS_STORIES[index].author,
                date: NEWS_STORIES[index].date,
                subtext: NEWS_STORIES[index].subtext,);
          },
          itemCount: NEWS_STORIES.length);
  }
}
