import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:wibubarber/schedule/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ScheduleEvent {
  static String stylename = "";
  static String colorName = "";
  static String barber = "";
  static List<String> scheduled = [];
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
      yield InScheduleState(ScheduleEvent.stylename, ScheduleEvent.colorName, null, []);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadScheduleEvent', error: _, stackTrace: stackTrace);
      yield ErrorScheduleState(_.toString());
    }
  }
}

class SelectServicesEvent extends ScheduleEvent {
  final String styleName;
  final String colorName;

  SelectServicesEvent(this.styleName, this.colorName);
  @override
  Stream<ScheduleState> applyAsync({ScheduleState? currentState, ScheduleBloc? bloc}) async* {
    try {
      yield UnScheduleState();
      // await Future.delayed(const Duration(seconds: 1));
      ScheduleEvent.stylename = styleName;
      ScheduleEvent.colorName = colorName;
      Future.delayed(Duration(seconds: 1));
      yield InScheduleState(ScheduleEvent.stylename, ScheduleEvent.colorName, null, []);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadScheduleEvent', error: _, stackTrace: stackTrace);
      yield ErrorScheduleState(_.toString());
    }
  }
}

class SelectBarberAndDatetimeEvent extends ScheduleEvent {
  final String barber;
  final DateTime dateTime;
  SelectBarberAndDatetimeEvent(this.barber, this.dateTime);
  @override
  Stream<ScheduleState> applyAsync({ScheduleState? currentState, ScheduleBloc? bloc}) async* {
    try {
      yield UnScheduleState();

      await getSchedule(barber, dateTime);
      yield InScheduleState(
          ScheduleEvent.stylename, ScheduleEvent.colorName, barber, ScheduleEvent.scheduled);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadScheduleEvent', error: _, stackTrace: stackTrace);
      yield ErrorScheduleState(_.toString());
    }
  }
}

Future<bool> getSchedule(String barber, DateTime dateTime) async {
  final ref = FirebaseDatabase.instance.ref();
  final b = barber.substring(0, barber.indexOf("@"));
  final String day = dateTime.day < 0 ? "0${dateTime.day}" : dateTime.day.toString();
  final String month = dateTime.month < 0 ? "0${dateTime.month}" : dateTime.month.toString();
  final snapshot = await ref.child('schedule/$b/$day$month${dateTime.year}').get();
  ScheduleEvent.barber = b;
  ScheduleEvent.scheduled = [];
  if (snapshot.exists) {
    for (final child in snapshot.children) {
      // Map item = child.value as Map;
      ScheduleEvent.scheduled.add(child.key ?? "");
    }
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

class AddSchedule extends ScheduleEvent {
  final int time;
  final DateTime date;
  AddSchedule(this.time, this.date);
  @override
  Stream<ScheduleState> applyAsync({ScheduleState? currentState, ScheduleBloc? bloc}) async* {
    try {
      // final date = ScheduleEvent.dateTime;
      final String customerEmail = FirebaseAuth.instance.currentUser!.email.toString();
      Map<String, dynamic> map = {
        ScheduleEvent.barber: {
          "${date.day}${date.month}${date.year}": {
            "${time.toString().padLeft(2, "0")}:00": {
              "color": ScheduleEvent.colorName,
              "style": ScheduleEvent.stylename,
              "customerEmail": customerEmail
            },
          },
        },
      };
      DatabaseReference dataRef = FirebaseDatabase.instance.ref("schedule");
      DatabaseEvent check = await dataRef
          .child(
              "${ScheduleEvent.barber}/${date.day}${date.month}${date.year}/${time.toString().padLeft(2, "0")}:00")
          .once();
      if (check.snapshot.exists)
        dataRef
            .child(
                "${ScheduleEvent.barber}/${date.day}${date.month}${date.year}/${time.toString().padLeft(2, "0")}:00")
            .update({
          "color": ScheduleEvent.colorName,
          "style": ScheduleEvent.stylename,
          "customerEmail": customerEmail
        });
      else {
        DatabaseEvent check1 = await dataRef.child(ScheduleEvent.barber).once();
        if (check1.snapshot.exists) {
          DatabaseEvent check2 =
              await dataRef.child("${ScheduleEvent.barber}/${date.day}${date.month}${date.year}").once();
          if (check2.snapshot.exists)
            dataRef.child("${ScheduleEvent.barber}/${date.day}${date.month}${date.year}").update({
              "${time.toString().padLeft(2, "0")}:00": {
                "color": ScheduleEvent.colorName,
                "style": ScheduleEvent.stylename,
                "customerEmail": customerEmail
              },
            });
          else
            dataRef.child(ScheduleEvent.barber).update({
              "${date.day}${date.month}${date.year}": {
                "${time.toString().padLeft(2, "0")}:00": {
                  "color": ScheduleEvent.colorName,
                  "style": ScheduleEvent.stylename,
                  "customerEmail": customerEmail
                },
              },
            });
        } else
          dataRef
              .child(
                  "${ScheduleEvent.barber}/${date.day}${date.month}${date.year}/${time.toString().padLeft(2, "0")}:00")
              .update(map);
      }
      yield ScheduleSuccessState();
      ScheduleEvent.barber = "";
      ScheduleEvent.colorName = "";
      ScheduleEvent.scheduled = [];
      ScheduleEvent.stylename = "";
      yield InScheduleState("", "", null, []);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadScheduleEvent', error: _, stackTrace: stackTrace);
      yield ErrorScheduleState(_.toString());
    }
  }
}
