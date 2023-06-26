import 'package:equatable/equatable.dart';

class BarberModel extends Equatable {
  final String? email;
  final String? name;
  final String? exp;
  final String? description;
  final String? avatarURL;
  BarberModel({this.avatarURL, this.email, this.name, this.exp, this.description});

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'description': description, 'exp': exp, 'avatarURL': avatarURL};
  factory BarberModel.fromJson(Map json) => BarberModel(
        avatarURL: json["avatarURL"],
        email: json['email'],
        description: json['description'],
        exp: json['exp'],
        name: json['name'],
      );
}
