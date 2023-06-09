import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String username;
  final String email;
  final List<String>? permission;
  final String name;
  UserModel(this.username, this.email, this.permission, this.name);

  @override
  List<Object?> get props => [username, email];

  Map<String, dynamic> toJson() =>
      {'username': username, 'email': email, 'permission': permission, 'name': name};
}
