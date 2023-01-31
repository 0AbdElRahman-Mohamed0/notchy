import 'dart:io';

import 'package:notchy/models/rating_model.dart';

class ProductModel {
  int? id;
  String? title;
  num? price;
  String? category;
  String? description;
  String? image;
  File? fileImage;
  RatingModel? rating;

  ProductModel(
      {this.fileImage,
      this.title,
      this.id,
      this.category,
      this.image,
      this.description,
      this.price});

  ProductModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    category = json['category'];
    description = json['description'];
    image = json['image'];
    if (json['rating'] != null) {
      rating = RatingModel.fromMap(json['rating']);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'image': fileImage != null ? 'https://i.pravatar.cc' : image,
      'title': title,
      'category': category,
      'description': description,
      'price': price,
    };
  }
}
