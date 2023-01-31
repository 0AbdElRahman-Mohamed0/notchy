import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/screens/add_product_screen.dart';
import 'package:notchy/ui/widget/product_card.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().myProducts;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My products',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => const AddProductScreen(),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Text(
                'No Products',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 190 / 183,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: products
                  .map(
                    (product) => ChangeNotifierProvider<ProductProvider>(
                      create: (_) => ProductProvider(product),
                      child: const ProductCard(
                        myProduct: true,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
