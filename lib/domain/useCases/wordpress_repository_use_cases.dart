import 'package:curl_manitoba/core/error/failures.dart';
import 'package:curl_manitoba/core/useCases/use_case.dart';
import 'package:curl_manitoba/data/repositories/word_press_repository.dart';
import 'package:curl_manitoba/domain/entities/calendar_event.dart';
import 'package:curl_manitoba/domain/entities/news_story.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetNewsStoryContent implements UseCase<String> {
  late final WordPressRepository wordPressRepository;

  GetNewsStoryContent(this.wordPressRepository);

  Future<Either<Failure, String>> call(GetNewsStoryContentParams params) async {
    return await wordPressRepository.fetchPostContent(params.postId);
  }
}

class GetNewsStoryContentParams extends Equatable {
  final String postId;
  List<Object> get props => [postId];
  GetNewsStoryContentParams({required this.postId});
}

class GetNewsStoryPosts implements UseCase<List<NewsStory>> {
  late final WordPressRepository wordPressRepository;

  GetNewsStoryPosts(this.wordPressRepository);

  Future<Either<Failure, List<NewsStory>>> call(
      GetNewsStoryPostsParams params) async {
    return await wordPressRepository.fetchPosts(
        amountOfPosts: params.amountOfPosts);
  }
}

class GetNewsStoryPostsParams extends Equatable {
  final int amountOfPosts;
  List<Object> get props => [amountOfPosts];
  GetNewsStoryPostsParams({required this.amountOfPosts});
}

class GetCalendarEvents implements UseCase<Map<DateTime, List<CalendarEvent>>> {
  late final WordPressRepository wordPressRepository;

  GetCalendarEvents(this.wordPressRepository);

  Future<Either<Failure, Map<DateTime, List<CalendarEvent>>>> call(
      NoParams params) async {
    return await wordPressRepository.fetchCalendarData();
  }
}

class GetElectronicEntryMap implements UseCase<Map<String, dynamic>> {
  late final WordPressRepository wordPressRepository;

  GetElectronicEntryMap(this.wordPressRepository);

  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) async =>
      await wordPressRepository.fetchElectronicEntryPage();
}

class GetPageContent implements UseCase<String> {
  late final WordPressRepository wordPressRepository;

  GetPageContent(this.wordPressRepository);

  Future<Either<Failure, String>> call(String pageNumber) async =>
      await wordPressRepository.fetchPage(pageNumber);
}

class GetPageContentParams extends Equatable {
  final String pageNumber;
  List<Object> get props => [pageNumber];
  GetPageContentParams({required this.pageNumber});
}
