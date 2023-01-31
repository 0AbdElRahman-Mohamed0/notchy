import 'package:flutter/material.dart';
import 'package:notchy/models/cart_model.dart';
import 'package:notchy/utils/api_connect.dart';

export 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier {
  final _api = ApiProvider.instance;
  CartModel? cart;

  Future<void> addCart(CartModel cartModel) async {
    if (cart == null) {
      cart = await _api.addNewCart(cartModel);
    } else {
      final CartModel tmp = await _api.updateCart(cartModel, cartId: cart?.id);
      cart?.products?.addAll(tmp.products ?? []);
    }
    notifyListeners();
  }

  Future<void> deleteProduct(int productId) async {
    cart?.products?.removeWhere((product) => product.id == productId);
    final tmp = cart;
    cart = null;
    notifyListeners();
    await Future.delayed(const Duration(microseconds: 500));
    cart = tmp;
    notifyListeners();
  }

  Future<void> updateProduct(int productId) async {
    final product =
        cart?.products?.firstWhere((product) => product.id == productId);
    product?.quantity = product.quantity! + 1;
    await _api.updateCart(cart!);
    notifyListeners();
  }

  Future<void> getCart() async {
    if (cart != null) return;
    cart = await _api.getCart();
    notifyListeners();
  }
}
