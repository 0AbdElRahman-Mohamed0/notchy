import 'package:notchy/models/product_model.dart';

class CartModel {
  int? id;
  int? userId;
  String? date;
  List<ProductModel>? products;

  CartModel({this.products, this.date, this.userId});

  CartModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    date = json['date'];
    if (json['products'] != null) {
      products = [];
      json['products']
          .forEach((product) => products!.add(ProductModel.fromMap(product)));
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date,
      'products': products
          ?.map((product) => {
                'productId': product.id,
                'quantity': product.quantity ?? 1,
              })
          .toList(),
    };
  }
}
