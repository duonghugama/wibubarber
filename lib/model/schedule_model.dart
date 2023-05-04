import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final String userID;

  final String barberID;

  final DateTime time;

  final bool isPrePay;

  final double price;

  Schedule(this.userID, this.barberID, this.time, this.isPrePay, this.price);

  @override
  List<Object?> get props => [];
}
