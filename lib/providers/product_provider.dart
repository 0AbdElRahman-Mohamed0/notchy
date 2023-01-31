import 'package:flutter/material.dart';
import 'package:notchy/models/product_model.dart';
import 'package:notchy/utils/api_connect.dart';

export 'package:provider/provider.dart';

class ProductProvider extends ChangeNotifier {
  ProductModel product;
  ProductProvider(this.product);

  final _api = ApiProvider.instance;

  Future<void> getSingleProduct() async {
    final quantity = product.quantity;
    product = await _api.getSingleProduct(product.id ?? 0);
    product.quantity = quantity;
    notifyListeners();
  }
}
