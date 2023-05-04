import 'package:equatable/equatable.dart';

class StyleModel extends Equatable {
  final String? styleName;
  final String? styleType;
  final String? styleTime;
  final int? stylePrice;
  final String? description;

  StyleModel({this.styleName, this.styleType, this.styleTime, this.stylePrice, this.description});

  @override
  List<Object?> get props => [];

  factory StyleModel.fromObject(Map json) {
    return StyleModel(
      styleName: json["styleName"],
      description: json["description"],
      stylePrice: json["stylePrice"],
      styleTime: json["styleTime"],
      styleType: json["styleType"],
    );
  }
  Map<String, dynamic> toJson() => {
        styleName ?? "": {
          'description': description,
          'stylePrice': stylePrice,
          'styleTime': styleTime,
          'styleType': styleType,
          'styleName': styleName
        }
      };
}
