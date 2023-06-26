import 'package:equatable/equatable.dart';

class ScheduleModel extends Equatable {
  final String barberEmail;
  final String customerEmail;
  final String date;
  final String time;
  final String? color;
  final String? style;
  final bool isConfirm;
  final bool isCancel;
  ScheduleModel(
      {required this.isCancel,
      required this.barberEmail,
      required this.customerEmail,
      required this.date,
      required this.time,
      required this.isConfirm,
      this.color,
      this.style});

  // factory ScheduleModel.fromJson(Map json) => ScheduleModel(
  //       barberEmail: json[''],
  //       customerEmail: json[''],
  //       date: json[''],
  //       time: json[''],
  //       color: json['color'],
  //       style: json['style'],
  //     );

  @override
  List<Object?> get props => [barberEmail, customerEmail, date, time, isConfirm, isCancel];
}
