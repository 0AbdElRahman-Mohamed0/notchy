import 'package:flutter/material.dart';
import 'package:notchy/models/product_model.dart';
import 'package:notchy/utils/api_connect.dart';

export 'package:provider/provider.dart';

class ProductsProvider extends ChangeNotifier {
  final _api = ApiProvider.instance;
  List<ProductModel> myProducts = [];
  List<ProductModel>? products;
  List<ProductModel>? categoryProducts;

  Future<void> getProducts({Map<String, dynamic>? filters}) async {
    products = null;
    notifyListeners();
    products = await _api.getProducts(filters: filters);
    notifyListeners();
  }

  Future<void> getCategoryProducts(String category,
      {Map<String, dynamic>? filters}) async {
    categoryProducts = null;
    notifyListeners();
    categoryProducts =
        await _api.getCategoryProducts(category, filters: filters);
    notifyListeners();
  }

  Future<void> addProduct(ProductModel productModel) async {
    final product = await _api.addProduct(productModel);
    myProducts.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel productModel) async {
    final product = await _api.updateProduct(productModel);
    myProducts.removeWhere((p) => p.id == productModel.id);
    myProducts.add(product);
    notifyListeners();
  }

  Future<void> deleteProduct(int productId) async {
    await _api.deleteProduct(productId);
    myProducts.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
