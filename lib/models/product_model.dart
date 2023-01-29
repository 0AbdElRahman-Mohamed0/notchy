import 'package:notchy/models/rating_model.dart';

class ProductModel {
  int? id;
  String? title;
  num? price;
  String? category;
  String? description;
  String? image;
  RatingModel? rating;

  ProductModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    category = json['category'];
    description = json['description'];
    image = json['image'];
    rating = RatingModel.fromMap(json['rating']);
  }
}
