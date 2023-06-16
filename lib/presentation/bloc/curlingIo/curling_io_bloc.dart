// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:curl_manitoba/domain/useCases/curling_io_repository_use_cases.dart';
import 'package:curl_manitoba/presentation/bloc/api_state.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';

part 'curling_io_event.dart';
part 'curling_io_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String DEFAULT_MESSAGE = 'Unexpected error';

class CurlingIoBloc extends Bloc<CurlingIoEvent, ApiState> {
  final GetScoresCompetitions getScoresCompetitions;
  final GetGames getGames;

  CurlingIoBloc({
    required this.getScoresCompetitions,
    required this.getGames,
  });

  @override
  ApiState get initialState => Empty();

  @override
  Stream<ApiState> mapEventToState(CurlingIoEvent event) async* {
    if (event is GetScoresCompetitions) {
      final test = await getScoresCompetitions(
          GetScoresCompetitionParams(pageNumber: '1', tag: '2'));
    }
  }

  Stream<ApiState> _eitherLoadedorErrorState(
      Either<Failure, dynamic> failureOrValue) async* {
    yield failureOrValue.fold(
        (failure) => Error(message: _mapFailuretoMessage(failure)),
        (value) => Loaded(value: value));
  }

  String _mapFailuretoMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return DEFAULT_MESSAGE;
    }
  }
}
