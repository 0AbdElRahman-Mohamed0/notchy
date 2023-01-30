import 'package:flutter/material.dart';
import 'package:notchy/models/product_model.dart';
import 'package:notchy/utils/api_connect.dart';

export 'package:provider/provider.dart';

class ProductsProvider extends ChangeNotifier {
  final _api = ApiProvider.instance;
  List<ProductModel>? products;
  List<ProductModel>? categoryProducts;

  Future<void> getProducts() async {
    products = null;
    notifyListeners();
    products = await _api.getProducts();
    notifyListeners();
  }

  Future<void> getCategoryProducts(String category) async {
    categoryProducts = null;
    notifyListeners();
    categoryProducts = await _api.getCategoryProducts(category);
    notifyListeners();
  }
}
