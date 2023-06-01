import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:wibubarber/schedule/index.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  ScheduleBloc(ScheduleState initialState) : super(initialState){
   on<ScheduleEvent>((event, emit) {
      return emit.forEach<ScheduleState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'ScheduleBloc', error: error, stackTrace: stackTrace);
          return ErrorScheduleState(error.toString());
        },
      );
    });
  }
}
