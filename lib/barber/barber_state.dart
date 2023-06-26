import 'package:equatable/equatable.dart';
import 'package:wibubarber/model/barber_model.dart';

abstract class BarberState extends Equatable {
  BarberState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnBarberState extends BarberState {
  UnBarberState();

  @override
  String toString() => 'UnBarberState';
}

/// Initialized
class InBarberState extends BarberState {
  final List<BarberModel> barbers;

  InBarberState(this.barbers);
  @override
  List<Object> get props => [barbers];
}

class ErrorBarberState extends BarberState {
  ErrorBarberState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorBarberState';

  @override
  List<Object> get props => [errorMessage];
}

class AddBarberState extends BarberState {}
