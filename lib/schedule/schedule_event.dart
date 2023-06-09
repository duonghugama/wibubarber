import 'dart:async';
import 'dart:developer' as developer;

import 'package:wibubarber/schedule/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScheduleEvent {
  Stream<ScheduleState> applyAsync({ScheduleState currentState, ScheduleBloc bloc});
}

class UnScheduleEvent extends ScheduleEvent {
  @override
  Stream<ScheduleState> applyAsync({ScheduleState? currentState, ScheduleBloc? bloc}) async* {
    yield UnScheduleState();
  }
}

class LoadScheduleEvent extends ScheduleEvent {
  @override
  Stream<ScheduleState> applyAsync({ScheduleState? currentState, ScheduleBloc? bloc}) async* {
    try {
      yield UnScheduleState();
      // await Future.delayed(const Duration(seconds: 1));
      yield InScheduleState([], null, null);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadScheduleEvent', error: _, stackTrace: stackTrace);
      yield ErrorScheduleState(_.toString());
    }
  }
}
