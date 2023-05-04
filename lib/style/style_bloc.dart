import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:wibubarber/style/index.dart';

class StyleBloc extends Bloc<StyleEvent, StyleState> {

  StyleBloc(StyleState initialState) : super(initialState){
   on<StyleEvent>((event, emit) {
      return emit.forEach<StyleState>(
        event.applyAsync(currentState: state, bloc: this),
        onData: (state) => state,
        onError: (error, stackTrace) {
          developer.log('$error', name: 'StyleBloc', error: error, stackTrace: stackTrace);
          return ErrorStyleState(error.toString());
        },
      );
    });
  }
}
