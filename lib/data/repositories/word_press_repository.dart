import 'package:curl_manitoba/apis/api_base_helper.dart';
import 'package:curl_manitoba/apis/wordpress_api.dart';
import 'package:curl_manitoba/core/error/exceptions.dart';
import 'package:curl_manitoba/core/error/failures.dart';
import 'package:curl_manitoba/core/network/network_info.dart';
import 'package:curl_manitoba/data/models/calendar_event_model.dart';
import 'package:curl_manitoba/data/models/news_story_model.dart';
import 'package:curl_manitoba/domain/entities/calendar_event.dart';
import 'package:curl_manitoba/domain/entities/e_entry_competition.dart';
import 'package:curl_manitoba/domain/entities/news_story.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;

abstract class WordPressRepository {
  Future<Either<Failure, Map<String, dynamic>>> fetchElectronicEntryPage();

  Future<Either<Failure, String>> fetchPage(String pageNumber);

  Future<Either<Failure, List<NewsStory>>> fetchPosts(
      {required int amountOfPosts});

  Future<Either<Failure, String>> fetchPostContent(String postId);

  Future<Either<Failure, Map<DateTime, List<CalendarEvent>>>>
      fetchCalendarData();
}

class WordPressRepositoryImp implements WordPressRepository {
  late final WordPressApi _wordPressApi;
  late final ApiBaseHelper _apiBaseHelper;

  static final WordPressRepositoryImp _singleton =
      WordPressRepositoryImp._internal();
  WordPressRepositoryImp._internal() {
    _wordPressApi = WordPressApi();
    _apiBaseHelper = ApiBaseHelper(http.Client());
  }

  factory WordPressRepositoryImp() => _singleton;

  Future<Either<Failure, Map<String, dynamic>>>
      fetchElectronicEntryPage() async {
    try {
      final result = await _wordPressApi.fetchPage('1979');
      return Right(parseElectronicEntryData(result));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String>> fetchPage(String pageNumber) async {
    try {
      final result = await _wordPressApi.fetchPage(pageNumber);
      return Right(parsePageContent(result));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, String>> fetchPostContent(String postId) async {
    try {
      final response = await _wordPressApi.fetchPost(postId);
      final document = parse(json.decode(response.body)['content']['rendered']);

      return Right(parse(document.body!.text).documentElement!.text);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, List<NewsStory>>> fetchPosts(
      {required int amountOfPosts}) async {
    try {
      final response =
          await _wordPressApi.fetchPosts(amountOfPosts: amountOfPosts);
      List<dynamic> jsonPosts = json.decode(response.body);
      return Right([
        for (Map<String, dynamic> jsonPost in jsonPosts)
          (NewsStoryModel.fromJson(jsonPost))
      ]);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, Map<DateTime, List<CalendarEvent>>>>
      fetchCalendarData() async {
    return getWordPressData(()async {
      final response = await _wordPressApi.fetchCalendarData();
      Map<String, dynamic> calendarMap = json.decode(response.body);

      List<CalendarEvent> calendarEvents = [
        for (var event in calendarMap['events'])
          (CalendarEventModel.fromJson(event))
      ];
      return _createEventsMap(calendarEvents);}) ;
    }
  }

  Future<Either<Failure, dynamic>> getWordPressData(
      Future<dynamic> Function() getAndParseData)async {  
    if (await NetworkInfo.isConnected)
      try {
        final data = getAndParseData();
        return Right(data);
      } on ServerException {
        return Left(ServerFailure());
  }
}

  //Takes electronic-entry webpage content response and builds all eEntryCompetitions from existing table mapped to categories
  static Map<String, dynamic> parseElectronicEntryData(
      http.Response eEntryResponse) {
    Map<String, dynamic> eEntryJsonMap = json.decode(eEntryResponse.body);
    dom.Document eEntryHtmlDocument =
        parse(eEntryJsonMap['content']['rendered']);

    List<html.Element> eEntryHtmlRows = eEntryHtmlDocument
        .getElementsByTagName('table')[1]
        .getElementsByTagName('tr');
    return getEEntryCompetitionsMapFromHtmlRows(eEntryHtmlRows);
  }

  static getEEntryCompetitionsMapFromHtmlRows(
      List<html.Element> eEntryHtmlRows) {
    String competitionCategory = '';
    List<html.Element> htmlRowCells;
    Map<String, List<eEntryCompetition>> competitionsMap = {};
    int rowCellsOccupied;

    eEntryHtmlRows.forEach((htmlRow) {
      rowCellsOccupied = 0;

      htmlRowCells = htmlRow.getElementsByTagName('td');

      //Determine if row is beginning of new category (only one cell will be occupied with category title)
      htmlRowCells.forEach((htmlCell) {
        if (htmlCell.text.isNotEmpty) ++rowCellsOccupied;
      });

      if (rowCellsOccupied == 1) {
        competitionCategory = htmlRowCells[4].text;
        competitionsMap[competitionCategory] = [];

        //If it is not an empty row and not a header row, create eEntryCompetition from row data
      } else if (htmlRowCells[0].text.toLowerCase() != 'type' &&
          rowCellsOccupied > 1) {
        competitionsMap[competitionCategory]!.add(eEntryCompetition(
            type: htmlRowCells[0].text,
            month: htmlRowCells[1].text,
            dateRange: htmlRowCells[2].text,
            fee: '\$' +
                ((htmlRowCells[3].text.replaceAll(new RegExp(r'[^0-9]'), ''))),
            name: htmlRowCells[4].text,
            location: htmlRowCells[5].text,
            deadline: htmlRowCells[6].text));
      }
    });
    return competitionsMap;
  }

  String parsePageContent(http.Response result) {
    final document = parse((json.decode(result.body)
        as Map<String, dynamic>)['content']['rendered']);
    return parse(document.body!.text).documentElement!.text;
  }

  Map<DateTime, List<CalendarEvent>> parseCalendarData(
      http.Response calendarResponse) {
    Map<String, dynamic> calendarMap = json.decode(calendarResponse.body);
    List<CalendarEvent> calendarEvents = [
      for (var event in calendarMap['events'])
        (CalendarEventModel.fromJson(event))
    ];
    return _createEventsMap(calendarEvents);
  }

  Map<DateTime, List<CalendarEvent>> _createEventsMap(
      List<CalendarEvent> eventsList) {
    //eventsMap maps all events with same days with one DateTime instance of the date
    Map<DateTime, List<CalendarEvent>> eventsMap = {};
    for (CalendarEvent event in eventsList) {
      //Get list of days that the calendar event falls on
      List<DateTime> eventDays = [
        for (int i = 0;
            i <= event.endDate.difference(event.startDate).inDays;
            i++)
          (DateUtils.dateOnly((event.startDate).add(Duration(days: i))))
      ];
      ;
      //Add event to eventsMap for each day event falls on
      for (DateTime day in eventDays) {
        //Create empty day map if no events exist for day
        eventsMap[day] ??= [];
        eventsMap[day]!.add(event);
      }
    }
    return eventsMap;
  }
}
