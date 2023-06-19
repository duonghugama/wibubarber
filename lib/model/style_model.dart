import 'package:equatable/equatable.dart';

class StyleModel extends Equatable {
  final String? styleName;
  final String? styleTime;
  final int? stylePrice;
  final String? description;
  final String? imageURL;
  StyleModel({this.styleName, this.styleTime, this.stylePrice, this.description, this.imageURL});

  @override
  List<Object?> get props => [];

  factory StyleModel.fromJson(Map json) {
    return StyleModel(
      styleName: json["styleName"],
      description: json["description"],
      stylePrice: json["stylePrice"],
      styleTime: json["styleTime"],
      imageURL: json["imageURL"],
    );
  }
  Map<String, dynamic> toJson() => {
        styleName ?? "": {
          'description': description,
          'stylePrice': stylePrice,
          'styleTime': styleTime,
          'styleName': styleName,
          'imageURL': imageURL ?? ""
        }
      };
}

class ColorModel {
  final String hex;
  int price;
  String time;
  final String name;

  ColorModel({required this.hex, required this.price, required this.time, required this.name});

  factory ColorModel.fromJson(Map json) {
    return ColorModel(
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
