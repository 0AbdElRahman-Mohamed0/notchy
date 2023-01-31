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
}
