import 'package:equatable/equatable.dart';

class StyleModel extends Equatable {
  final String? styleName;
  final String? styleType;
  final String? styleTime;
  final int? stylePrice;
  final String? description;
  final String? imageURL;
  StyleModel(
      {this.styleName, this.styleType, this.styleTime, this.stylePrice, this.description, this.imageURL});

  @override
  List<Object?> get props => [];

  factory StyleModel.fromJson(Map json) {
    return StyleModel(
      styleName: json["styleName"],
      description: json["description"],
      stylePrice: json["stylePrice"],
      styleTime: json["styleTime"],
      styleType: json["styleType"],
      imageURL: json["imageURL"],
    );
  }
  Map<String, dynamic> toJson() => {
        styleName ?? "": {
          'description': description,
          'stylePrice': stylePrice,
          'styleTime': styleTime,
          'styleType': styleType,
          'styleName': styleName,
          'imageURL': imageURL ?? ""
        }
      };
}

class ColorStyle {
  final String? hex;
  int? price;
  String? time;
  final String name;

  ColorStyle({this.hex, this.price, this.time, required this.name});

  factory ColorStyle.fromJson(Map<String, dynamic> json) {
    return ColorStyle(
      name: json['name'],
      hex: json['hex'],
      price: json['price'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        name: {
          'hex': hex,
          'name': name,
          'price': price,
          'time': time,
        },
      };
}
