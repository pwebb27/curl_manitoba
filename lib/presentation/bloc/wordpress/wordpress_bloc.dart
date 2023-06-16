import 'package:curl_manitoba/core/useCases/use_case.dart';
import 'package:curl_manitoba/domain/useCases/wordpress_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/bloc/wordpress/wordpress_event.dart';
import 'package:curl_manitoba/presentation/bloc/wordpress/wordpress_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../api_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class WordPressBloc extends Bloc<WordPressEvent, ApiState> {
  final GetCalendarEvents getCalendarEvents;
  final GetElectronicEntryMap getElectronicEntryMap;
  final GetPageContent getPageContent;
  final GetNewsStoryContent getNewsStoryContent;
  final GetNewsStoryPosts getNewsStoryPosts;

  WordPressBloc(
      {required this.getCalendarEvents,
      required this.getElectronicEntryMap,
      required this.getNewsStoryContent,
      required this.getNewsStoryPosts,
      required this.getPageContent});

  Stream<ApiState> mapEventToState(WordPressEvent event) async* {
    yield Loading();
    final failureOrValue = await getAwaitFunction(event);
    yield* _eitherLoadedOrErrorState(failureOrValue);
  }

  Stream<ApiState> _eitherLoadedOrErrorState(
    Either<Failure, dynamic> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (value) => Loaded(value: value),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }

  getAwaitFunction(WordPressEvent event) {
    switch (event.runtimeType) {
      case GetCalendarEventsEvent:
        return getCalendarEvents(NoParams());
      case GetElectronicEntryMapEvent:
        return getElectronicEntryMap(NoParams());
      case GetPageContentEvent:
        return getPageContent((event as GetPageContentEvent).pageNumber);
      case GetNewsStoryContentEvent:
        return getNewsStoryContent(GetNewsStoryContentParams(
            postId: (event as GetNewsStoryContentEvent).postId));
      case GetNewsStoryPostsEvent:
        return getNewsStoryPosts(GetNewsStoryPostsParams(
            amountOfPosts: (event as GetNewsStoryPostsEvent).amountOfPosts));
    }
  }
}
