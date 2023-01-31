import 'package:flutter/material.dart';
import 'package:notchy/providers/cart_provider.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/ui/widget/cart_card.dart';
import 'package:notchy/ui/widget/loading.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    return cart == null
        ? const LoadingWidget()
        : cart.products?.isEmpty ?? true
            ? Center(
                child: Text(
                  'No Products',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: cart.products!
                      .map(
                        (product) => ChangeNotifierProvider<ProductProvider>(
                          create: (_) => ProductProvider(product),
                          child: Column(
                            children: const [
                              CartCard(),
                              SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
  }
}
