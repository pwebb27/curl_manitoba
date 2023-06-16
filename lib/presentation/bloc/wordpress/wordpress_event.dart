import 'package:equatable/equatable.dart';

abstract class WordPressEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetCalendarEventsEvent extends WordPressEvent {}

class GetElectronicEntryMapEvent extends WordPressEvent {}

class GetPageContentEvent extends WordPressEvent {
  final String pageNumber;
  GetPageContentEvent(this.pageNumber);
  List<Object> get props => [pageNumber];
}

class GetNewsStoryContentEvent extends WordPressEvent {
  final String postId;
  GetNewsStoryContentEvent(this.postId);
  List<Object> get props => [postId];
}

class GetNewsStoryPostsEvent extends WordPressEvent {
  final int amountOfPosts;
  GetNewsStoryPostsEvent(this.amountOfPosts);
  List<Object> get props => [amountOfPosts];
}
