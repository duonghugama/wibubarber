import 'package:equatable/equatable.dart';
import 'package:wibubarber/model/user_model.dart';

abstract class LoginState extends Equatable {
  LoginState();

  @override
  List<Object?> get props => [];
}

/// UnInitialized
class UnLoginState extends LoginState {
  UnLoginState();
}

/// Initialized
class InLoginState extends LoginState {
  final UserModel? user;

  InLoginState(this.user);
  @override
  List<Object?> get props => [user];
}

class LoginSuccessState extends LoginState {
  @override
  List<Object> get props => [];
}

class LogoutState extends LoginState {
  @override
  List<Object> get props => [];
}

class ErrorLoginState extends LoginState {
  ErrorLoginState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

class CreateUserSuccessState extends LoginState {
  final String email;

  CreateUserSuccessState(this.email);
  @override
  List<Object?> get props => [email];
}
