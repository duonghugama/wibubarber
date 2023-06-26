import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:wibubarber/home/index.dart';
import 'package:meta/meta.dart';
import 'package:wibubarber/model/barber_model.dart';
import 'package:wibubarber/model/schedule_model.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/model/user_model.dart';

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
      ScheduleModel model = await getSchedule();
      BarberModel barberModel = await getbarber(model.barberEmail);
      StyleModel styleModel = await getStyle(model.style ?? "");
      ColorModel colorModel = await getColor(model.color ?? "");
      yield InHomeState(model, barberModel, styleModel, colorModel);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class LoadBarberHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      yield UnHomeState();
      List<ScheduleModel> schedule = await getListSchedule(FirebaseAuth.instance.currentUser!.email!);
      List<UserModel> user = [];
      for (var schedule in schedule) {
        user.add(await getCustommer(schedule.customerEmail));
      }
      List<ColorModel> color = [];
      for (var schedule in schedule) {
        color.add(await getColor(schedule.color ?? ""));
      }
      List<StyleModel> style = [];
      for (var schedule in schedule) {
        style.add(await getStyle(schedule.style ?? ""));
      }
      yield InBarberHomeState(schedule, color, style, user);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

class ConfirmScheduleEvent extends HomeEvent {
  final String day;
  final String time;
  final String customerEmail;
  final String color;
  final String style;

  ConfirmScheduleEvent(this.day, this.time, this.customerEmail, this.color, this.style);

  @override
  Stream<HomeState> applyAsync({HomeState? currentState, HomeBloc? bloc}) async* {
    try {
      String email = FirebaseAuth.instance.currentUser?.email ?? "";
      DatabaseReference scheduleRef = FirebaseDatabase.instance
          .ref("schedule")
          .child(email.substring(0, email.indexOf("@")))
          .child(day)
          .child(time);
      scheduleRef.update({
        'color': color,
        'style': style,
        'customerEmail': customerEmail,
        'isConfirm': true,
      });
      DatabaseReference historyRef = FirebaseDatabase.instance
          .ref("history")
          .child(customerEmail.substring(0, customerEmail.indexOf("@")))
          .child(day)
          .child(time);
      historyRef.update({
        'color': color,
        'style': style,
        'barberEmail': email,
        'isConfirm': true,
        'time': time,
      });
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_.toString());
    }
  }
}

Future<ScheduleModel> getSchedule() async {
  String email = FirebaseAuth.instance.currentUser!.email!
      .substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf("@"));
  // DateTime now = DateTime.now();
  DatabaseReference ref = FirebaseDatabase.instance.ref("history");
  // String today = "1162023";
  DatabaseEvent event = await ref.child(email).once();
  if (event.snapshot.exists) {
    List<int> listDay = [];
    for (int i = 0; i < event.snapshot.children.length; i++) {
      listDay.add(int.parse(event.snapshot.children.elementAt(i).key!));
    }
    String day = listDay.reduce(max).toString();
    DataSnapshot snapshotDay = event.snapshot.children.firstWhere((element) => element.key == day);
    List<int> listTime = [];
    for (int i = 0; i < snapshotDay.children.length; i++) {
      listTime.add(int.parse(snapshotDay.children.elementAt(i).key!.substring(0, 2)));
    }
    String time = listTime.reduce(max) < 10 ? "0${listTime.reduce(max)}:00" : "${listTime.reduce(max)}:00";
    Map map = snapshotDay.children.firstWhere((element) => element.key == time).value as Map;
    return ScheduleModel(
        barberEmail: map['barberEmail'],
        customerEmail: email,
        date: snapshotDay.key ?? "",
        time: map['time'],
        color: map['color'],
        style: map['style'],
        isConfirm: map['isConfirm'] ?? false,
        isCancel: map['isCancel'] ?? false);
  } else {
    return ScheduleModel(
        barberEmail: "", customerEmail: "", date: "", isConfirm: false, time: "", isCancel: false);
  }
}

Future<List<ScheduleModel>> getListSchedule(String barberEmail) async {
  List<ScheduleModel> listSchedule = [];
  DatabaseReference ref = FirebaseDatabase.instance.ref("schedule");
  DatabaseEvent event = await ref.child(barberEmail.substring(0, barberEmail.indexOf("@"))).once();
  if (event.snapshot.exists) {
    List<int> listDay = [];
    for (int i = 0; i < event.snapshot.children.length; i++) {
      listDay.add(int.parse(event.snapshot.children.elementAt(i).key!));
    }
    String day = listDay.reduce(max).toString();
    DataSnapshot snapshotDay = event.snapshot.children.firstWhere((element) => element.key == day);
    List<String> listTime = [];
    for (int i = 0; i < snapshotDay.children.length; i++) {
      listTime.add((snapshotDay.children.elementAt(i).key!));
    }
    for (var time in listTime) {
      Map map = snapshotDay.children.firstWhere((element) => element.key == time).value as Map;
      listSchedule.add(ScheduleModel(
          barberEmail: barberEmail,
          customerEmail: map['customerEmail'],
          date: snapshotDay.key ?? "",
          time: time,
          color: map['color'],
          style: map['style'],
          isConfirm: map['isConfirm'] ?? false,
          isCancel: map['isCancel'] ?? false));
    }
  }
  return listSchedule;
}

Future<BarberModel> getbarber(String email) async {
  BarberModel model = BarberModel();
  if (email != "") {
    model = await FirebaseFirestore.instance
        .collection('barber')
        .where("email", isEqualTo: email)
        .get()
        .then((value) => BarberModel.fromJson(value.docs[0].data()));
  }
  return model;
}

Future<StyleModel> getStyle(String styleName) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("style");
  // String today = "1162023";
  DatabaseEvent event = await ref.child(styleName).once();
  if (event.snapshot.exists && styleName != "") {
    Map map = event.snapshot.value as Map;
    return StyleModel.fromJson(map);
  } else
    return StyleModel();
}

Future<ColorModel> getColor(String colorName) async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("colors");
  // String today = "1162023";
  DatabaseEvent event = await ref.child(colorName).once();
  if (event.snapshot.exists && colorName != "") {
    Map map = event.snapshot.value as Map;
    return ColorModel.fromJson(map);
  } else
    return ColorModel(hex: "", name: "", price: 0, time: "");
}

Future<UserModel> getCustommer(String email) async {
  UserModel model = UserModel();
  if (email != "") {
    model = await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .get()
        .then((value) => UserModel.fromJson(value.docs[0].data()));
  }
  return model;
}
