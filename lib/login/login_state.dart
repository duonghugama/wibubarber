import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  LoginState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnLoginState extends LoginState {
  UnLoginState();
}

/// Initialized
class InLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

class ErrorLoginState extends LoginState {
  ErrorLoginState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
