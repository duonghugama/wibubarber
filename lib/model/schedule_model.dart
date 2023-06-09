import 'package:equatable/equatable.dart';
import 'package:wibubarber/model/style_model.dart';

class ScheduleModel extends Equatable {
  List<StyleModel> models;
  ColorModel? colors;
  ScheduleModel({required this.models, this.colors});
  factory ScheduleModel.fromListStyleModel(List<StyleModel> models) => ScheduleModel(models: models);
  @override
  List<Object?> get props => [];
}
