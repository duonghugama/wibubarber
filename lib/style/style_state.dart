import 'package:equatable/equatable.dart';
import 'package:wibubarber/model/style_model.dart';

abstract class StyleState extends Equatable {
  StyleState();

  @override
  List<Object?> get props => [];
}

/// UnInitialized
class UnStyleState extends StyleState {
  UnStyleState();

  @override
  String toString() => 'UnStyleState';
}

/// Initialized
class InStyleState extends StyleState {
  final List<StyleModel>? styles;

  InStyleState(this.styles);

  @override
  List<Object?> get props => [styles];
}

class AddStyleSuccessState extends StyleState {
  @override
  List<Object> get props => [];
}

class UpdateStyleSuccessState extends StyleState {
  @override
  List<Object> get props => [];
}

class DeleteStyleSuccessState extends StyleState {
  @override
  List<Object> get props => [];
}

class ErrorStyleState extends StyleState {
  ErrorStyleState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorStyleState';

  @override
  List<Object> get props => [errorMessage];
}
