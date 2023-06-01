import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:wibubarber/barber/index.dart';

class BarberBloc extends Bloc<BarberEvent, BarberState> {

  BarberBloc(BarberState initialState) : super(initialState){
   on<BarberEvent>((event, emit) {
      return emit.forEach<BarberState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'BarberBloc', error: error, stackTrace: stackTrace);
          return ErrorBarberState(error.toString());
        },
      );
    });
  }
}
