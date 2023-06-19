import 'package:equatable/equatable.dart';

abstract class ScheduleState extends Equatable {
  ScheduleState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnScheduleState extends ScheduleState {
  UnScheduleState();

  @override
  String toString() => 'UnScheduleState';
}

/// Initialized
class InScheduleState extends ScheduleState {
  final String style;
  final String color;
  final String? barberID;
  final List<String> scheduled;

  InScheduleState(this.style, this.color, this.barberID, this.scheduled);
}

class ErrorScheduleState extends ScheduleState {
  ErrorScheduleState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorScheduleState';

  @override
  List<Object> get props => [errorMessage];
}

class ScheduleSuccessState extends ScheduleState {}
