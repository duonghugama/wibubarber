import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wibubarber/barber/index.dart';
import 'package:meta/meta.dart';
import 'package:wibubarber/model/barber_model.dart';

@immutable
abstract class BarberEvent {
  Stream<BarberState> applyAsync({BarberState currentState, BarberBloc bloc});
}

class UnBarberEvent extends BarberEvent {
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    yield UnBarberState();
  }
}

class LoadBarberEvent extends BarberEvent {
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    try {
      yield UnBarberState();
      List<BarberModel> barbers = [];

      barbers = await getbarber();
      yield InBarberState(barbers);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBarberEvent', error: _, stackTrace: stackTrace);
      yield ErrorBarberState(_.toString());
    }
  }
}

Future<List<BarberModel>> getbarber() async {
  CollectionReference collectionRef = FirebaseFirestore.instance.collection("barber");
  QuerySnapshot snapshot = await collectionRef.get();
  return snapshot.docs.map((e) => BarberModel.fromJson(e.data() as Map)).toList();
}

class AddBarberEvent extends BarberEvent {
  @override
  Stream<BarberState> applyAsync({BarberState? currentState, BarberBloc? bloc}) async* {
    try {} catch (_, stackTrace) {
      developer.log('$_', name: 'LoadBarberEvent', error: _, stackTrace: stackTrace);
      yield ErrorBarberState(_.toString());
    }
  }
}
