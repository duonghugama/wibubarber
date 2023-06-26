import 'package:equatable/equatable.dart';
import 'package:wibubarber/model/barber_model.dart';
import 'package:wibubarber/model/schedule_model.dart';
import 'package:wibubarber/model/style_model.dart';
import 'package:wibubarber/model/user_model.dart';

abstract class HomeState extends Equatable {
  HomeState();

  @override
  List<Object?> get props => [];
}

/// UnInitialized
class UnHomeState extends HomeState {
  UnHomeState();

  @override
  String toString() => 'UnHomeState';
}

/// Initialized
class InHomeState extends HomeState {
  final ScheduleModel? model;
  final BarberModel? barberName;
  final StyleModel? style;
  final ColorModel? color;
  InHomeState(this.model, this.barberName, this.style, this.color);
  @override
  List<Object?> get props => [model, barberName];
}

class InBarberHomeState extends HomeState {
  final List<ScheduleModel>? schedule;
  final List<UserModel>? user;
  final List<ColorModel>? color;
  final List<StyleModel>? style;

  InBarberHomeState(this.schedule, this.color, this.style, this.user);

  @override
  List<Object?> get props => [schedule, style];
}

class ErrorHomeState extends HomeState {
  ErrorHomeState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorHomeState';

  @override
  List<Object> get props => [errorMessage];
}
