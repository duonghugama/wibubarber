import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:wibubarber/home/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {
  Stream<HomeState> applyAsync({HomeState currentState, HomeBloc bloc});
}

class UnHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc}) async* {
    yield UnHomeState();
  }
}

class LoadHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield InHomeState();
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

// class LoadStyleEventTest extends HomeEvent {
//   @override
//   Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc}) async* {
//     try {
//       yield UnHomeState();
//       final ref = FirebaseDatabase.instance.ref();
//       final snapshot = await ref.child('/Style').get();
//       if (snapshot.exists) {
//         print(snapshot.value);
//       } else {
//         print('No data available.');
//       }
//       await Future.delayed(Duration(seconds: 1));
//       yield InHomeState();
//     } catch (_, stackTrace) {
//       developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
//       yield ErrorHomeState(_.toString());
//     }
//   }
// }
