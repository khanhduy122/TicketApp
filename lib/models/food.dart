import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/enum_model.dart';
part 'food.g.dart';

@JsonSerializable()
class Food {
  Food({
    required this.cgv,
    required this.galaxy,
    required this.lotte,
  });
  final FoodDetail cgv;
  final FoodDetail lotte;
  final FoodDetail galaxy;

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);

  Map<String, dynamic> toJson() => _$FoodToJson(this);
}

@JsonSerializable()
class FoodDetail {
  FoodDetail({
    required this.data,
    required this.type,
  });
  final CinemasType type;
  final List<FoodItem> data;

  factory FoodDetail.fromJson(Map<String, dynamic> json) =>
      _$FoodDetailFromJson(json);

  Map<String, dynamic> toJson() => _$FoodDetailToJson(this);
}

@JsonSerializable()
class FoodItem {
  FoodItem({
    required this.description,
    required this.name,
    required this.price,
    required this.thumbnail,
    this.quantity,
  });
  final String thumbnail;
  final String name;
  final int price;
  final String description;
  int? quantity;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodItemToJson(this);
}
