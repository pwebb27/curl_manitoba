import 'package:equatable/equatable.dart';

abstract class ApiState extends Equatable {
  ApiState([List props = const <dynamic>[]]) : super();
  @override
  List<Object> get props => [];
}

class Empty extends ApiState {}

class Loading extends ApiState {}

class Loaded extends ApiState {
  final dynamic value;
  Loaded({this.value}) : super([value]);
}

class Error extends ApiState {
  final String message;
  Error({required this.message});
}
