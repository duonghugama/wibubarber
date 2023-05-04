import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/style/index.dart';

@immutable
abstract class StyleEvent {
  static List<StyleModel> styles = [];
  Stream<StyleState> applyAsync({StyleState currentState, StyleBloc bloc});
}

class LoadStyleEvent extends StyleEvent {
  @override
  Stream<StyleState> applyAsync({StyleState? currentState, StyleBloc? bloc}) async* {
    try {
      yield UnStyleState();
      StyleEvent.styles.clear();
      await getStyle();
      yield InStyleState(StyleEvent.styles);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadStyleEvent', error: _, stackTrace: stackTrace);
      yield ErrorStyleState(_.toString());
    }
  }
}

Future<bool> getStyle() async {
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('style').get();
  if (snapshot.exists) {
    for (final child in snapshot.children) {
      Map item = child.value as Map;
      if (kDebugMode) {
        print(item);
      }
      StyleEvent.styles.add(StyleModel.fromObject(item));
    }
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

class AddStyleEvent extends StyleEvent {
  final StyleModel styleModel;

  AddStyleEvent(this.styleModel);
  @override
  Stream<StyleState> applyAsync({StyleState? currentState, StyleBloc? bloc}) async* {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref("style");
      await ref.update(styleModel.toJson());
      StyleEvent.styles.add(styleModel);
      yield AddStyleSuccessState();
      await Future.delayed(Duration(milliseconds: 100));
      yield InStyleState(StyleEvent.styles);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadStyleEvent', error: _, stackTrace: stackTrace);
      yield ErrorStyleState(_.toString());
    }
  }
}
