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
  final List<String> servicePackage;
  final String? barberID;
  final DateTime? schedule;

  InScheduleState(this.servicePackage, this.barberID, this.schedule);
}

class ErrorScheduleState extends ScheduleState {
  ErrorScheduleState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorScheduleState';

  @override
  List<Object> get props => [errorMessage];
}
