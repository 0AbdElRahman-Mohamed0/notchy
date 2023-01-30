import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notchy/providers/auth_provider.dart';
import 'package:notchy/providers/product_provider.dart';
import 'package:notchy/providers/products_provider.dart';
import 'package:notchy/ui/widget/error_pop_up.dart';
import 'package:notchy/ui/widget/loading.dart';
import 'package:notchy/ui/widget/product_card.dart';
import 'package:notchy/utils/extension_methods/dio_error_extention.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _getData() async {
    try {
      await context.read<ProductsProvider>().getProducts();
    } on DioError catch (e) {
      showDialog(
        context: context,
        builder: (_) => ErrorPopUp(message: e.readableError),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => const ErrorPopUp(
            message: 'Something went wrong. Please try again.'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;
    return products == null
        ? const LoadingWidget()
        : products.isEmpty
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                shrinkWrap: true,
                children: products
                    .map(
                      (product) => ChangeNotifierProvider<ProductProvider>(
                        create: (_) => ProductProvider(product),
                        child: const ProductCard(),
                      ),
                    )
                    .toList(),
              );
  }
}
